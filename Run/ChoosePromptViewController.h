//
//  ChoosePromptViewController.h
//  Run
//
//  Created by Daniel Howard on 3/22/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFJSONRequestOperation.h"
#import "Game.h"
#import "Prompt.h"

@interface ChoosePromptViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *onePoint;
@property (weak, nonatomic) IBOutlet UIButton *twoPoints;
@property (weak, nonatomic) IBOutlet UIButton *threePoints;
@property Prompt *prompt1;
@property Prompt *prompt2;
@property Prompt *prompt3;
@property Prompt *chosenPrompt;
@property (strong, nonatomic) Game *game;

@end
