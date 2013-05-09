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
    
    //_guessImage.image = [UIImage imageNamed: _game, ];
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: _game.promptImage]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            // WARNING: is the cell still using the same data by this point??
            _guessImage.image = [UIImage imageWithData: data];
        });
    });
    
    NSMutableArray *guessLetters = [NSMutableArray array];
    for (NSInteger charIdx=0; charIdx < _game.promptWord.length; charIdx++) {
        // Do something with character at index charIdx, for example:
        NSString *s = [NSString stringWithFormat:@"%c", [_game.promptWord characterAtIndex:charIdx]];
        [guessLetters addObject:s];
    }
    
    while(guessLetters.count < 12) {
        NSUInteger randomIndex = arc4random() % [[GuessViewController alphabet] count];
        [guessLetters addObject:[GuessViewController alphabet][randomIndex]];
    }
    
    guessLetters = [GuessViewController shuffleArray:guessLetters];
    
    letterHolders = [[NSMutableArray alloc] init];
    int totalWidth = (38 * _game.promptWord.length) + (7 * (_game.promptWord.length - 1));
    int startPosition = 160 - totalWidth/2;
    
    for(int i=0; i < _game.promptWord.length; i++) {
        LetterHolderView* newView = [[LetterHolderView alloc] init];
        newView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"letter-holder.png"]];
        newView.taken = false;
        newView.frame = CGRectMake(startPosition+(i*45.0), 434.0, 38, 37);
        [self.view addSubview:newView];
        [letterHolders addObject:newView];
    }
    
    int i = 0;
    for (LetterView *iView in self.view.subviews) {
        if ([iView isMemberOfClass:[LetterView class]]) {
            [iView setWithLetter:[guessLetters[i] uppercaseString]];
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
            if([guessWord isEqualToString:[_game.promptWord uppercaseString]])
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

+ (NSMutableArray*)shuffleArray:(NSMutableArray*)array {
    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:array];
    
    for(NSUInteger i = [array count]; i > 1; i--) {
        NSUInteger j = arc4random_uniform(i);
        [temp exchangeObjectAtIndex:i-1 withObjectAtIndex:j];
    }
    
    return [NSArray arrayWithArray:temp];
}

@end
