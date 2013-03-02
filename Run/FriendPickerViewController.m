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

@implementation FriendPickerViewController

@synthesize friendPickerController = _friendPickerController;

- (void) viewDidLoad {
    NSManagedObjectContext *context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Game"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    _games = [NSMutableArray arrayWithArray:[context executeFetchRequest:fetchRequest error:&error]];
    [_gamesTable insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
    [_gamesTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self getGames];
}

- (void) getGames {
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 240);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    PFQuery *gamesQuery = [PFQuery queryWithClassName:@"Game"];
    [gamesQuery includeKey:@"player1"];
    [gamesQuery includeKey:@"player2"];
    [gamesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [spinner stopAnimating];
            _games = [NSMutableArray array];
            int i = 0;
            for (PFObject *game in objects) {
                [_games addObject:[self parseGameFromPFObject:game]];
                i++;
            }
            
            NSLog(@"GAMES: %i", [_games count]);
            [_gamesTable reloadData];

        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return 2;
    return [_games count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Game *game = ((Game*) [_games objectAtIndex:indexPath.row]);
    NSString *otherPlayerName = game.player2.name;
    NSLog(@"OTHER PLAYER NAME: %@", otherPlayerName);
    cell.textLabel.text = otherPlayerName;
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
        [newGame initWithPlayer1:newUser andPlayer2:newUser];
        
        [self savePFObjectsFromGame:newGame];
    }

    [self dismissModalViewControllerAnimated:YES];
    [self performSegueWithIdentifier: @"startGameSegue" sender: self];
}

- (void)facebookViewControllerCancelWasPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void) savePFObjectsFromGame: (Game*)game {
    PFObject *pfPlayer1 = [PFObject objectWithClassName:@"MyUser"];
    [pfPlayer1 setObject:game.player1.name forKey:@"name"];
    [pfPlayer1 setObject:game.player2.facebookId forKey:@"facebookId"];
    
    PFObject *pfGame = [PFObject objectWithClassName:@"Game"];
    [pfGame setObject:pfPlayer1 forKey:@"player1"];
    [pfGame setObject:pfPlayer1 forKey:@"player2"];
    
    NSArray *objectsToSave = [NSArray arrayWithObjects: pfPlayer1, pfGame, nil];
    [PFObject saveAllInBackground:objectsToSave];
}

- (Game*) parseGameFromPFObject: (PFObject*)game {
    
    NSManagedObjectContext *context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *userEntity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    NSEntityDescription *gameEntity = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:context];
        
    User *newUser = (User*) [[NSManagedObject alloc] initWithEntity:userEntity insertIntoManagedObjectContext:context];
    //[newUser init:[[game objectForKey:@"player1"] objectForKey:@"name" ] withFacebookId:[[game objectForKey:@"player1"] objectForKey:@"facebookId" ]];
    newUser.facebookId = [[game objectForKey:@"player1"] objectForKey:@"facebookId" ];
    newUser.name = [[game objectForKey:@"player1"] objectForKey:@"name" ];
    
    User *newUser2 = (User*) [[NSManagedObject alloc] initWithEntity:userEntity insertIntoManagedObjectContext:context];
    //[newUser init:[[game objectForKey:@"player2"] objectForKey:@"name" ] withFacebookId:[[game objectForKey:@"player2"] objectForKey:@"facebookId" ]];
    newUser2.facebookId = [[game objectForKey:@"player2"] objectForKey:@"facebookId" ];
    newUser2.name = [[game objectForKey:@"player2"] objectForKey:@"name" ];
    
    NSError *error;
    //[context save:&error];
    
    NSLog(@"GAME: %@", game);
    NSLog(@"PLAYER: %@", [game objectForKey:@"player2"]);
    NSLog(@"NAME: %@", [[game objectForKey:@"player2"] objectForKey:@"name" ]);
    
    NSLog(@"USER2: %@", newUser2);
        
    Game *newGame = (Game*) [[NSManagedObject alloc] initWithEntity:gameEntity insertIntoManagedObjectContext:context];
    [newGame initWithPlayer1:newUser andPlayer2:newUser2];
    
    NSLog(@"GAME: %@", newGame);
    NSLog(@"PLAYER: %@", newGame.player2);
    NSLog(@"NAME: %@", newGame.player2.name);
    
    return newGame;
    
}

@end
