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
#import "AnswerViewController.h"
#import "Game.h"
#import "User.h"
#import "GameTableCell.h"

@implementation GamesViewController

@synthesize friendPickerController = _friendPickerController;

- (void) viewDidLoad {
    
    RunAppDelegate *appDelegate = (RunAppDelegate *)[[UIApplication sharedApplication] delegate];
    _currentUser = appDelegate.currentUser;
    
    _context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    _gameEntity = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:_context];
    
    [self loadGames];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_gamesTable insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [_gamesTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self getGames];
}

- (void) loadGames {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:_gameEntity];
    NSError *error;
    _games = [NSMutableArray arrayWithArray:[_context executeFetchRequest:fetchRequest error:&error]];
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
        for (NSDictionary *game in gamesArray) {
            Game *newGame = [self parseGameFromJson:game];
            [_games addObject:newGame];
        }
        
        NSError *saveError = nil;
        [_context save:&saveError];        
        [_gamesTable reloadData];
        
    } failure:nil];
    [operation start];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_games count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"GameTableCellPrototype";
    
    GameTableCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[GameTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Game *game = ((Game*) [_games objectAtIndex:indexPath.row]);
    cell.profilePhoto.profileID = [game.opponentFacebookId stringValue];
    cell.gameLabel.text = game.opponentName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _chosenGame = (Game*)[_games objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"guessSegue" sender: self];
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

- (void) createGame: (NSString*)opponentId {
    NSLog(@"Create game");
    NSString *queryString = [NSString stringWithFormat:@"player1=%@&player2=%@", _currentUser.facebookId, opponentId];
    NSString *requestString = [NSString stringWithFormat:@"http://localhost:3000/createGame?%@", queryString];
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                  timeoutInterval:60.0];
    [theRequest setHTTPMethod: @"POST"];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:theRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //NSLog(<#NSString *format, ...#>)
        [self performSegueWithIdentifier: @"startGameSegue" sender: self];
    } failure:nil];
    [operation start];
}

- (Game*) parseGameFromJson: (NSDictionary*)json {
    Game *newGame = (Game*)[[NSManagedObject alloc] initWithEntity:_gameEntity insertIntoManagedObjectContext:_context];
    newGame.gameId = [json objectForKey:@"_id"];
    
    NSString *playerKey = @"player1";
    if([[[json objectForKey:@"player1"] objectForKey:@"_id"] isEqualToString: _currentUser.userId]) {
        playerKey = @"player2";     
    }
    
    newGame.opponentName = [[json objectForKey:playerKey] objectForKey:@"name" ];
    newGame.opponentFacebookId = [[json objectForKey:playerKey] objectForKey:@"facebookId" ];
    return newGame;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"guessSegue"]) {
        AnswerViewController *vc = [segue destinationViewController];
        vc.game = _chosenGame;
    } else if([segue.identifier isEqualToString:@"startGameSegue"]) {
        RunViewController *vc = [segue destinationViewController];
        vc.game = _chosenGame;
    }
}

@end
