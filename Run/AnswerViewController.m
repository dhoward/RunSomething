//
//  AnswerViewController.m
//  Run
//
//  Created by Daniel Howard on 3/6/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import "AnswerViewController.h"
#import "RunViewController.h"

@interface AnswerViewController ()

@end

@implementation AnswerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"ANSWERVC: %@", _game);
    if(_answeredCorrectly)
        [self correctAnswer];
    else
        [self incorrectAnswer];
}

- (void)correctAnswer {
    
}

- (void)incorrectAnswer {
    _correctLabel.text = @"Wrong muthafucka!";
    _nextButton.titleLabel.text = @"Ugh fine";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RunViewController *vc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"promptSegue"]) {
        vc.game = _game;
    }
}

@end
