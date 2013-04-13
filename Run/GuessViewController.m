//
//  GuessViewController.m
//  Run
//
//  Created by Daniel Howard on 3/6/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import "GuessViewController.h"
#import "AnswerViewController.h"
#import "LetterView.h"
#import "LetterHolderView.h"

@interface GuessViewController ()

@end

@implementation GuessViewController

@synthesize dragObject;
@synthesize touchOffset;
@synthesize letterHolders;

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
    
    UITapGestureRecognizer *myLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(letterTapHandler:)];
    [self.view addGestureRecognizer:myLabelTap];
    
    letterHolders = [[NSMutableArray alloc] init];
    for(int i=0; i<5; i++) {
        LetterHolderView* newView = [[LetterHolderView alloc] init];
        newView.backgroundColor = [UIColor blackColor];
        newView.taken = false;
        newView.frame = CGRectMake(10+(i*60.0), 300.0, 50, 50);
        [self.view addSubview:newView];
        [letterHolders addObject:newView];
    }
    
    int i = 0;
    for (LetterView *iView in self.view.subviews) {
        if ([iView isMemberOfClass:[LetterView class]]) {            
            [iView setWithLetter: [GuessViewController alphabet][i]];            
            iView.startX = iView.frame.origin.x;
            iView.startY = iView.frame.origin.y;            
            i++;
        }
    }
}

-(void)letterTapHandler:(UIGestureRecognizer *)gestureRecognizer {
    UIView* view = gestureRecognizer.view;
    CGPoint loc = [gestureRecognizer locationInView:view];
    
    for (LetterView *iView in self.view.subviews) {
        if ([iView isMemberOfClass:[LetterView class]]) {
            if (CGRectContainsPoint(iView.frame, loc)) {
                for(int i=0; i<letterHolders.count; i++) {
                    if([iView tapLetterToHolder:(LetterHolderView*)letterHolders[i]]) {
                        [self checkWord];
                        return;
                    }
                }
            }
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.dragObject = nil;
    if ([touches count] == 1) {
        // one finger
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
        for (LetterView *iView in self.view.subviews) {
            if ([iView isMemberOfClass:[LetterView class]]) {
                if (touchPoint.x > iView.frame.origin.x &&
                    touchPoint.x < iView.frame.origin.x + iView.frame.size.width &&
                    touchPoint.y > iView.frame.origin.y &&
                    touchPoint.y < iView.frame.origin.y + iView.frame.size.height)
                {
                    self.dragObject = iView;
                    self.touchOffset = CGPointMake(touchPoint.x - iView.frame.origin.x,
                                                   touchPoint.y - iView.frame.origin.y);
                    [self.view bringSubviewToFront:self.dragObject];
                }
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    CGRect newDragObjectFrame = CGRectMake(touchPoint.x - touchOffset.x,
                                           touchPoint.y - touchOffset.y,
                                           self.dragObject.frame.size.width,
                                           self.dragObject.frame.size.height);
    self.dragObject.frame = newDragObjectFrame;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    bool foundTarget = false;
    for (UIView *anotherView in self.view.subviews) {
        if (self.dragObject == anotherView)
            continue;
        if (CGRectIntersectsRect(self.dragObject.frame, anotherView.frame)) {
            if([anotherView class] == [LetterHolderView class]) {
                foundTarget = [self.dragObject placeLetterInHolder:(LetterHolderView*)anotherView];
            }
        }
    }
    
    if(!foundTarget)
        [self.dragObject returnHome];
    
    [self checkWord];
}

- (void) checkWord {
    NSLog(@"CHECK WORD");
    int letterCount = letterHolders.count;
    NSMutableString* guessWord = [NSMutableString stringWithCapacity:letterCount];
    for(int i=0; i< letterCount; i++) {
        NSString *theLetter = ((LetterHolderView*)letterHolders[i]).letter;
        NSLog(@"%@", theLetter);
        if( theLetter != nil ) {
            [guessWord appendString: theLetter];
            NSLog(@"%@", guessWord);
            if([guessWord isEqualToString:@"ABCDE"])
                [self performSegueWithIdentifier:@"correctSegue" sender:self];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AnswerViewController *vc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"correctSegue"]) {
        vc.game = _game;
    }
}

+ (NSArray *)alphabet
{
    static NSArray *_alphabet;
    
    // This will only be true the first time the method is called...
    //
    if (_alphabet == nil)
    {
        _alphabet = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    }
    
    return _alphabet;
}

@end
