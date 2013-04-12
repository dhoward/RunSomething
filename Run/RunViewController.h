//
//  RunViewController.h
//  Run
//
//  Created by Daniel Howard on 2/23/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import "Game.h"
#import "Prompt.h"

@interface RunViewController : UIViewController <MKMapViewDelegate, UIAlertViewDelegate> {
    CGPoint lastPoint;
    __weak IBOutlet UIImageView *drawing;
    __weak IBOutlet MKMapView *mapView;
    UIImageView *drawImage;
    __weak IBOutlet UILabel *promptLabel;
    BOOL mouseSwiped;
    int mouseMoved;
    float lineSize;
    struct CGColor *color;
    bool isDrawing;
    bool mapInitted;
}
@property (strong, nonatomic) Game *game;
@property (strong, nonatomic) Prompt *prompt;
-(void)drawUserPoint;
@end
