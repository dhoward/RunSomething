//
//  FriendPickerViewController.m
//  Run
//
//  Created by Daniel Howard on 2/25/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Parse/Parse.h>
#import "FriendPickerViewController.h"
#import "Game.h"
#import "User.h"
#import "GameTableCell.h"

@implementation FriendPickerViewController

@synthesize friendPickerController = _friendPickerController;

- (void) viewDidLoad {
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

- (void) getGames {
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 240);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    PFQuery *gamesQuery = [PFQuery queryWithClassName:@"Game"];
    [gamesQuery includeKey:@"player1"];
    [gamesQuery includeKey:@"player2"];
    [gamesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            for (NSManagedObject * oldGame in _games) {
                [_context deleteObject:oldGame];
            }
            
            [spinner stopAnimating];
            _games = [NSMutableArray array];
            for (PFObject *game in objects) {
                Game *newGame = [self parseGameFromPFObject:game];
                [_games addObject:newGame];
            }
            
            NSError *saveError = nil;
            [_context save:&saveError];
            
            [_gamesTable reloadData];

        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];    
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
    cell.profilePhoto.profileID = game.opponentFacebookId;
    cell.gameLabel.text = game.opponentName;
    return cell;
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
    
    NSManagedObjectContext *context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *userEntity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    NSEntityDescription *gameEntity = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:context];

    NSArray *friendsSelected = self.friendPickerController.selection;    
    
    for (id<FBGraphUser> user in friendsSelected) {
        User *newUser = (User*) [[NSManagedObject alloc] initWithEntity:userEntity insertIntoManagedObjectContext:context];
        [newUser init:user.name withFacebookId:user.id];
        
        Game *newGame = (Game*) [[NSManagedObject alloc] initWithEntity:gameEntity insertIntoManagedObjectContext:context];
        newGame.opponentName = user.name;
        newGame.opponentFacebookId = user.id;
        
        [self savePFObjectsFromGame:newGame];
    }

    [self dismissModalViewControllerAnimated:YES];
    
    if(friendsSelected.count > 0)
        [self performSegueWithIdentifier: @"startGameSegue" sender: self];
}

- (void)facebookViewControllerCancelWasPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void) savePFObjectsFromGame: (Game*)game {
    PFObject *pfPlayer1 = [PFObject objectWithClassName:@"MyUser"];
    [pfPlayer1 setObject:game.opponentName forKey:@"name"];
    [pfPlayer1 setObject:game.opponentFacebookId forKey:@"facebookId"];
    
    PFObject *pfGame = [PFObject objectWithClassName:@"Game"];
    [pfGame setObject:pfPlayer1 forKey:@"player1"];
    [pfGame setObject:pfPlayer1 forKey:@"player2"];
    
    NSArray *objectsToSave = [NSArray arrayWithObjects: pfPlayer1, pfGame, nil];
    [PFObject saveAllInBackground:objectsToSave];
}

- (Game*) parseGameFromPFObject: (PFObject*)game {
    Game *newGame = (Game*)[[NSManagedObject alloc] initWithEntity:_gameEntity insertIntoManagedObjectContext:_context];
    newGame.gameId = game.objectId;
    newGame.opponentName = [[game objectForKey:@"player1"] objectForKey:@"name" ];
    newGame.opponentFacebookId = [[game objectForKey:@"player1"] objectForKey:@"facebookId" ];
    return newGame;
}

@end
