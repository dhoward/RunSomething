//
//  FriendPickerViewController.h
//  Run
//
//  Created by Daniel Howard on 2/25/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FriendPickerViewController : UIViewController<FBFriendPickerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITextView *selectedFriendsView;
@property (retain, nonatomic) FBFriendPickerViewController *friendPickerController;
@property (weak, nonatomic) IBOutlet UITableView *gamesTable;
@property NSArray *games;

- (IBAction)pickFriendsButtonClick:(id)sender;

@end
