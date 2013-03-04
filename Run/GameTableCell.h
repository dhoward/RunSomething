//
//  GameTableCell.h
//  Run
//
//  Created by Daniel Howard on 3/3/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface GameTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *gameLabel;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePhoto;
@end
