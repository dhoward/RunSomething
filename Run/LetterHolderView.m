//
//  LetterHolderView.m
//  Run
//
//  Created by Daniel Howard on 4/9/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import "LetterView.h"
#import "LetterHolderView.h"

@implementation LetterHolderView

@synthesize taken;
@synthesize letter;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (bool)placeLetter: (LetterView*) letterView
{
    if(taken)
        return false;
    
    letter = letterView.letter;
    taken = true;
    return true;
}

- (void)setVacant
{
    letter = @"";
    taken = false;
    NSLog(@"Set vacant");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
