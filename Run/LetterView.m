//
//  LetterView.m
//  Run
//
//  Created by Daniel Howard on 4/11/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import "LetterView.h"

@implementation LetterView

@synthesize startX;
@synthesize startY;
@synthesize holder;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) { }
    return self;
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
