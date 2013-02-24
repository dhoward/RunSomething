//
//  RunViewController.m
//  Run
//
//  Created by Daniel Howard on 2/23/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import "RunViewController.h"

@interface RunViewController ()

@end

@implementation RunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	drawImage = [[UIImageView alloc] initWithImage:nil];
	drawImage.frame = self.view.frame;
	[self.view addSubview:drawImage];
	mouseMoved = 0;
    lineSize = 5.0;
}

- (IBAction)setLineSize:(id)sender {
    lineSize = (float)[sender tag];
}

- (IBAction)setColor:(id)sender {
    switch([sender tag]) {
        case 1:
            color = [[UIColor redColor] CGColor];
            break;
        case 2:
            color = [[UIColor greenColor] CGColor];
            break;
        case 3:
            color = [[UIColor blueColor] CGColor];
            break;
        case 4:
            color = [[UIColor yellowColor] CGColor];
            break;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	mouseSwiped = NO;
	UITouch *touch = [touches anyObject];
	
	if ([touch tapCount] == 2) {
		drawImage.image = nil;
		return;
	}
    
	lastPoint = [touch locationInView:self.view];
    
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	mouseSwiped = YES;
	
	UITouch *touch = [touches anyObject];
	CGPoint currentPoint = [touch locationInView:self.view];
	
	UIGraphicsBeginImageContext(self.view.frame.size);
	[drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), lineSize);
	CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), color);
	CGContextBeginPath(UIGraphicsGetCurrentContext());
	CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
	CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
	CGContextStrokePath(UIGraphicsGetCurrentContext());
	drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	lastPoint = currentPoint;
    
	mouseMoved++;
	
	if (mouseMoved == 10) {
		mouseMoved = 0;
	}
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	
	if ([touch tapCount] == 2) {
		drawImage.image = nil;
		return;
	}
	
	
	if(!mouseSwiped) {
		UIGraphicsBeginImageContext(self.view.frame.size);
		[drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
		CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
		CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);
		CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
		CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
		CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
		CGContextStrokePath(UIGraphicsGetCurrentContext());
		CGContextFlush(UIGraphicsGetCurrentContext());
		drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

