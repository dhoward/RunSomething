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
@property (weak, nonatomic) IBOutlet UIView *pencilOptions;
@property (weak, nonatomic) IBOutlet UIView *colorOptions;
@property (weak, nonatomic) IBOutlet UIButton *pencilButton;
@property (weak, nonatomic) IBOutlet UIButton *colorButton;
-(void)drawUserPoint;
-(IBAction)togglePencilOptions:(id)sender;
-(IBAction)toggleColorOptions:(id)sender;

@end
