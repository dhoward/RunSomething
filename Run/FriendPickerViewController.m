//
//  FriendPickerViewController.m
//  Run
//
//  Created by Daniel Howard on 2/25/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import "FriendPickerViewController.h"

@implementation FriendPickerViewController

@synthesize selectedFriendsView = _friendResultText;
@synthesize friendPickerController = _friendPickerController;

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
