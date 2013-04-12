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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (bool)placeLetter: (LetterView*) letter
{
    if(taken)
        return false;
    
    letter.center = self.center;
    letter.holder = self;
    taken = true;
    return true;
}

- (void)setVacant
{
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
