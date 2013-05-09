//
//  FriendPickerViewController.m
//  Run
//
//  Created by Daniel Howard on 2/25/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Parse/Parse.h>
#import "AFJSONRequestOperation.h"
#import "GamesViewController.h"
#import "RunViewController.h"
#import "GuessViewController.h"
#import "Game.h"
#import "User.h"
#import "GameTableCell.h"

@implementation GamesViewController

@synthesize friendPickerController = _friendPickerController;

- (void) viewDidLoad {
    
    NSArray *fonts = [UIFont fontNamesForFamilyName:@"Oxygen"];
    
    for(NSString *string in fonts){
        NSLog(@"%@", string);
    }
    
    RunAppDelegate *appDelegate = (RunAppDelegate *)[[UIApplication sharedApplication] delegate];
    _currentUser = appDelegate.currentUser;
    
    _context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    _gameEntity = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:_context];
    
    [self loadGames];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_gamesTable insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [_gamesTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    _gamesTable.layer.cornerRadius = 5;
    _gamesTable.layer.masksToBounds = YES;
    [self getGames];
}

- (void) loadGames {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:_gameEntity];
    NSError *error;
    NSMutableArray* gamesArray  = [NSMutableArray arrayWithArray:[_context executeFetchRequest:fetchRequest error:&error]];
    
    NSMutableArray* yourMove = [NSMutableArray array];
    NSMutableArray* notYourMove = [NSMutableArray array];
    for (Game *game in gamesArray) {
        if(game.yourMove)
            [yourMove addObject:game];
        else
            [notYourMove addObject:game];
    }
    
    NSDictionary *yourMoveDict = [NSDictionary dictionaryWithObject:yourMove forKey:@"games"];
    NSDictionary *notYourMoveDict = [NSDictionary dictionaryWithObject:notYourMove forKey:@"games"];
    
    [_games addObject:yourMoveDict];
    [_games addObject:notYourMoveDict];
}

//TODO: Refactor this method once backend supports call the correct way
- (void) getGames {
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 240);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    NSString *queryString = [NSString stringWithFormat:@"user=%@", _currentUser.userId];
    NSString *requestString = [NSString stringWithFormat:@"http://localhost:3000/games?%@", queryString];
    
    NSURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]
                                                         cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                         timeoutInterval:60.0];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:theRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary *gamesArray = (NSDictionary *) JSON;
        
        for (NSManagedObject * oldGame in _games) {
            [_context deleteObject:oldGame];
        }
        
        [spinner stopAnimating];
        _games = [NSMutableArray array];
        NSMutableArray* yourMove = [NSMutableArray array];
        NSMutableArray* notYourMove = [NSMutableArray array];
        
        for (NSDictionary *game in gamesArray) {
            Game *newGame = [self parseGameFromJson:game];
            if(newGame.yourMove)
                [yourMove addObject:newGame];
            else
                [notYourMove addObject:newGame];
        }
        
        NSDictionary *yourMoveDict = [NSDictionary dictionaryWithObject:yourMove forKey:@"games"];
        NSDictionary *notYourMoveDict = [NSDictionary dictionaryWithObject:notYourMove forKey:@"games"];
        
        [_games addObject:yourMoveDict];
        [_games addObject:notYourMoveDict];
        
        NSError *saveError = nil;
        [_context save:&saveError];        
        [_gamesTable reloadData];
        
    } failure:nil];
    [operation start];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [_games count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dictionary = [_games objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"games"];
    return [array count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return @"Yo move";
    else
        return @"Nacho move";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"GameTableCellPrototype";
    
    GameTableCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    UIImage *image = [UIImage imageNamed:@"tablecell-bg.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleToFill;
    cell.backgroundView = imageView;
    
    UIFont *customFont = [UIFont fontWithName:@"Oxygen-Bold.ttf" size:35];
    cell.gameLabel.font = customFont;
    
    cell.profilePhoto.layer.cornerRadius = 4;
    cell.profilePhoto.clipsToBounds = YES;
    
    if (cell == nil) {
        cell = [[GameTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSDictionary *dictionary = [_games objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"games"];
    Game* game = [array objectAtIndex:indexPath.row];
    cell.profilePhoto.profileID = [game.opponentFacebookId stringValue];
    cell.gameLabel.text = game.opponentName;
    
    if(!game.yourMove){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictionary = [_games objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"games"];
    _chosenGame = [array objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"guessSegue" sender: self];
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 43;
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 320, 30)];
    [sectionTitle setFrame:CGRectMake(12, 8, 300, 30)];
    
    if(section == 0)
        sectionTitle.text = @"Your Turn";
    else
        sectionTitle.text = @"Waiting for Turn";
    
    sectionTitle.font = [UIFont fontWithName:@"Oxygen-Bold.ttf" size:35];
    sectionTitle.textColor = [UIColor colorWithWhite:1 alpha:1];
    sectionTitle.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        
    UIImageView *sectionHeaderBG = [[UIImageView alloc] init];
    headerView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"table-header.png"]];
        
    [headerView addSubview:sectionTitle];
    [headerView addSubview:sectionHeaderBG];
    return headerView;
}

- (IBAction)pickFriendsButtonClick:(id)sender {
    if (self.friendPickerController == nil) {
        self.friendPickerController = [[FBFriendPickerViewController alloc] init];
        self.friendPickerController.title = @"Pick Friends";
        self.friendPickerController.allowsMultipleSelection = false;
        self.friendPickerController.delegate = self;
    }
    
    [self.friendPickerController loadData];
    [self.friendPickerController clearSelection];    
    [self presentViewController:self.friendPickerController animated:YES completion:nil];
}

- (void)facebookViewControllerDoneWasPressed:(id)sender {

    NSArray *friendsSelected = self.friendPickerController.selection;
    for (id<FBGraphUser> user in friendsSelected) {
        NSLog(@"%@", user.id);
        [self createGame:user.id];
    }

    [self dismissModalViewControllerAnimated:YES];
}

- (void)facebookViewControllerCancelWasPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                 shouldIncludeUser:(id <FBGraphUser>)user {
    return [[user objectForKey:@"installed"] boolValue];
}

- (void) createGame: (NSString*)opponentId {
    NSLog(@"Create game");
    NSString *queryString = [NSString stringWithFormat:@"player1=%@&player2=%@", _currentUser.facebookId, opponentId];
    NSString *requestString = [NSString stringWithFormat:@"http://localhost:3000/createGame?%@", queryString];
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                  timeoutInterval:60.0];
    [theRequest setHTTPMethod: @"POST"];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:theRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *game = (NSDictionary *) JSON;
        _chosenGame = [self parseGameFromJson: game];
        [self performSegueWithIdentifier: @"startGameSegue" sender: self];
    } failure:nil];
    [operation start];
}

- (Game*) parseGameFromJson: (NSDictionary*)json {
    Game *newGame = (Game*)[[NSManagedObject alloc] initWithEntity:_gameEntity insertIntoManagedObjectContext:_context];
    newGame.gameId = [json objectForKey:@"_id"];
    newGame.promptWord = [[json objectForKey:@"lastMove"] objectForKey:@"word"];
    newGame.promptPoints = [[json objectForKey:@"lastMove"] objectForKey:@"points"];
    
    NSString *imgString = [[json objectForKey:@"lastMove"] objectForKey:@"image"];
    
    newGame.promptImage = imgString;
    
    NSString *playerKey = @"player1";
    if([[[json objectForKey:@"player1"] objectForKey:@"_id"] isEqualToString: _currentUser.userId]) {
        playerKey = @"player2";     
    }
    
    NSLog(@"Comparing: %@, %@, %d", [[json objectForKey:@"lastMove"] objectForKey:@"player"], _currentUser.userId,[[[json objectForKey:@"lastMove"] objectForKey:@"player"] isEqualToString:_currentUser.userId]);
    
    newGame.opponentName = [[json objectForKey:playerKey] objectForKey:@"name" ];
    newGame.opponentFacebookId = [[json objectForKey:playerKey] objectForKey:@"facebookId" ];
    newGame.yourMove = ![[[json objectForKey:@"lastMove"] objectForKey:@"player"] isEqualToString:_currentUser.userId];
    NSLog(@"Your move: %d", newGame.yourMove);
    return newGame;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"guessSegue"]) {
        GuessViewController *vc = [segue destinationViewController];
        vc.game = _chosenGame;
    } else if([segue.identifier isEqualToString:@"startGameSegue"]) {
        RunViewController *vc = [segue destinationViewController];
        vc.game = _chosenGame;
    }
}

@end
