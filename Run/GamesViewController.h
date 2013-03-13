//
//  FriendPickerViewController.h
//  Run
//
//  Created by Daniel Howard on 2/25/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "RunAppDelegate.h"
#import "User.h"
#import "Game.h"

@interface GamesViewController : UIViewController<FBFriendPickerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITextView *selectedFriendsView;
@property (retain, nonatomic) FBFriendPickerViewController *friendPickerController;
@property (weak, nonatomic) IBOutlet UITableView *gamesTable;
@property (strong, nonatomic) User *currentUser;
@property NSMutableArray *games;
@property NSManagedObjectContext *context;
@property NSEntityDescription *gameEntity;
@property Game *chosenGame;

- (IBAction)pickFriendsButtonClick:(id)sender;

@end