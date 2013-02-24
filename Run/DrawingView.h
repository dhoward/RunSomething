//
//  DrawingView.h
//  HelloWorld
//
//  Created by Daniel Howard on 2/22/13.
//  Copyright (c) 2013 Erica Sadun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBezierPath-Smoothing.h"

#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]

#define IS_IPAD	(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define RESIZABLE(_VIEW_) [_VIEW_ setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth]

#ifndef HelloWorld_DrawingView_h
#define HelloWorld_DrawingView_h

@interface DrawingView : UIView
{
	UIBezierPath *path;
}
- (void) clear;
@end

#endif
