//
//  LetterView.m
//  Run
//
//  Created by Daniel Howard on 4/11/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import "LetterView.h"
#import "LetterHolderView.h"

@implementation LetterView

@synthesize startX;
@synthesize startY;
@synthesize letter;
@synthesize holder;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) { }
    return self;
}

- (void) setWithLetter: (NSString*) theLetter
{
    letter = theLetter;
    
    UILabel* myLabel = [[UILabel alloc] init];
    myLabel.text = letter;
    myLabel.backgroundColor = [UIColor colorWithRed:100 green:0 blue:0 alpha:0];
    myLabel.frame = CGRectMake(0, 0, 50, 50);
    myLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:myLabel];
}

- (bool) hasHolder
{
    return (holder != nil);
}

- (bool) tapLetterToHolder:(LetterHolderView*) newHolder
{
    if(holder == nil)
        return [self placeLetterInHolder:newHolder];
    else
        return [self placeLetterInHolder:holder];
}

- (bool) placeLetterInHolder:(LetterHolderView*) theHolder
{
    NSLog(@"Place letter in holder");
    
    if(theHolder.taken && theHolder != holder)
    {
        NSLog(@"Holder taken");
        return false;
    }
    
    if(holder != nil)
        [holder setVacant];
    
    self.center = theHolder.center;
    self.holder = theHolder;
    theHolder.taken = true;
    theHolder.letter = letter;
    self.holder = theHolder;
    return true;
}

- (void) returnHome
{
    [holder setVacant];
    holder = nil;
    self.frame = CGRectMake(self.startX, self.startY,
                            self.frame.size.width,
                            self.frame.size.height);
}

@end
