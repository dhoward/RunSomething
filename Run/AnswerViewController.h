//
//  AnswerViewController.h
//  Run
//
//  Created by Daniel Howard on 3/6/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@interface AnswerViewController : UIViewController

@property (strong, nonatomic) Game *game;
@property bool answeredCorrectly;
@property (weak, nonatomic) IBOutlet UILabel *correctLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end
