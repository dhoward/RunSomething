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
    _games = [context executeFetchRequest:fetchRequest error:&error];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [_gamesTable insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
        
        PFObject *pfPlayer1 = [PFObject objectWithClassName:@"MyUser"];
        [pfPlayer1 setObject:newUser.name forKey:@"name"];
        [pfPlayer1 setObject:newUser.facebookId forKey:@"facebookId"];
        
        PFObject *pfGame = [PFObject objectWithClassName:@"Game"];
        [pfGame setObject:pfPlayer1 forKey:@"player1"];
        [pfGame setObject:pfPlayer1 forKey:@"player2"];
        
        NSArray *objectsToSave = [NSArray arrayWithObjects: pfPlayer1, pfGame, nil];
        [PFObject saveAllInBackground:objectsToSave];
    }

    [self dismissModalViewControllerAnimated:YES];
    [self performSegueWithIdentifier: @"startGameSegue" sender: self];
}

- (void)facebookViewControllerCancelWasPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
