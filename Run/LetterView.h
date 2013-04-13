//
//  LetterView.h
//  Run
//
//  Created by Daniel Howard on 4/11/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LetterHolderView;

@interface LetterView : UIImageView

@property int startX;
@property int startY;
@property NSString* letter;
@property LetterHolderView* holder;

- (void) setWithLetter: (NSString*) letter;
- (bool) placeLetterInHolder:(LetterHolderView*) holder;
- (bool) tapLetterToHolder:(LetterHolderView*) holder;
- (bool) hasHolder;
- (void) returnHome;

@end
