//
//  FriendPickerViewController.m
//  Run
//
//  Created by Daniel Howard on 2/25/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "FriendPickerViewController.h"
#import "Game.h"

@implementation FriendPickerViewController

@synthesize selectedFriendsView = _friendResultText;
@synthesize friendPickerController = _friendPickerController;

- (void) viewDidLoad {
    
//    NSManagedObjectContext *context = [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
//    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Game"
//                                              inManagedObjectContext:context];
//    [fetchRequest setEntity:entity];
//    NSError *error;
//    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
//    for (Game *game in fetchedObjects) {
//        //NSLog(@"P1: %@", game.player1);
//        //NSLog(@"P2: %@", game.player2);
//    }
//    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [_gamesTable insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//                          withRowAnimation:UITableViewRowAnimationFade];
//    [_gamesTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [_games count];
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSLog(@"GAME");
    NSNumber *id = [(Game*)[_games objectAtIndex:indexPath.row] id];
    NSString *idString = [id stringValue];
    cell.textLabel.text = @"YO YO YO YO";
    NSLog(@"%@", idString);
    return cell;
}


- (IBAction)pickFriendsButtonClick:(id)sender {
    if (self.friendPickerController == nil) {
        // Create friend picker, and get data loaded into it.
        self.friendPickerController = [[FBFriendPickerViewController alloc] init];
        self.friendPickerController.title = @"Pick Friends";
        self.friendPickerController.allowsMultipleSelection = false;
        self.friendPickerController.delegate = self;
    }
    
    [self.friendPickerController loadData];
    [self.friendPickerController clearSelection];
    
    // iOS 5.0+ apps should use [UIViewController presentViewController:animated:completion:]
    // rather than this deprecated method, but we want our samples to run on iOS 4.x as well.
    [self presentModalViewController:self.friendPickerController animated:YES];
}

- (void)facebookViewControllerDoneWasPressed:(id)sender {
    
    // we pick up the users from the selection, and create a string that we use to update the text view
    // at the bottom of the display; note that self.selection is a property inherited from our base class
    for (id<FBGraphUser> user in self.friendPickerController.selection) {        
        //do stuff with the user
    }
    
    [self dismissModalViewControllerAnimated:YES];
    [self performSegueWithIdentifier: @"startGameSegue" sender: self];
}

- (void)facebookViewControllerCancelWasPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
