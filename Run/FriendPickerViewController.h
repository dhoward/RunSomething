//
//  FriendPickerViewController.h
//  Run
//
//  Created by Daniel Howard on 2/25/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FriendPickerViewController : UIViewController<FBFriendPickerDelegate>

@property (strong, nonatomic) IBOutlet UITextView *selectedFriendsView;
@property (retain, nonatomic) FBFriendPickerViewController *friendPickerController;

- (IBAction)pickFriendsButtonClick:(id)sender;

@end
