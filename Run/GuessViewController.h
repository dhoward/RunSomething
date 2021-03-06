//
//  GuessViewController.h
//  Run
//
//  Created by Daniel Howard on 3/6/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "LetterView.h"

@interface GuessViewController : UIViewController

@property (strong, nonatomic) Game *game;
@property bool inDrag;
@property bool answeredCorrectly;
@property UIView *draggedView;
@property UIView *objectToDrag;
@property NSMutableArray* letterHolders;

@property (nonatomic, strong) LetterView *dragObject;
@property (nonatomic, assign) CGPoint touchOffset;
@property (weak, nonatomic) IBOutlet UIImageView *guessImage;

-(void)correctAnswer;
-(IBAction)giveUp:(id)sender;

@end
