//
//  LetterHolderView.h
//  Run
//
//  Created by Daniel Howard on 4/9/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LetterView.h"

@interface LetterHolderView : UIView

@property bool taken;
- (bool)placeLetter:(id)letter;
- (void)setVacant;
@end
