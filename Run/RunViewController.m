//
//  RunViewController.m
//  Run
//
//  Created by Daniel Howard on 2/23/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import <Parse/Parse.h>
#import "RunViewController.h"
#import "RunAppDelegate.h"

@interface RunViewController ()

@end

@implementation RunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	mouseMoved = 0;
    lineSize = 5.0;
    isDrawing = false;
    mapView.delegate = self;
    mapInitted = false;
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

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    
    [self drawUserPoint];

    if(mapInitted){
        return;
    }
    
    mapInitted = true;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [aMapView setRegion:region animated:NO];
}

- (IBAction)enableDRawing:(id) sender {
    isDrawing = !isDrawing;
}

- (void)drawUserPoint {
    
    CGPoint currentPoint = [mapView convertCoordinate:mapView.userLocation.coordinate toPointToView:mapView];
    
    if(!isDrawing){
        lastPoint = currentPoint;
        return;
    }
	
	UIGraphicsBeginImageContext(self.view.frame.size);
	[drawing.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), lineSize);
	CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), color);
	CGContextBeginPath(UIGraphicsGetCurrentContext());
	CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
	CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
	CGContextStrokePath(UIGraphicsGetCurrentContext());
	drawing.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
    
}

-(IBAction)captureScreen:(id)sender
{
    UIGraphicsBeginImageContext(drawing.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [drawing.layer renderInContext:context];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImageJPEGRepresentation(screenshot, 0.05f);
    [self uploadMove:imageData forGame:_game];
}

- (void) uploadMove: (NSData*) imageData forGame: game {
    PFFile *image = [PFFile fileWithName:@"Image.jpg" data:imageData];
    
    [image saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            RunAppDelegate *appDelegate = (RunAppDelegate *)[[UIApplication sharedApplication] delegate];
            User *currentUser = appDelegate.currentUser;
            
            NSLog(@"CURRENT USER ID: %@", currentUser.userId);
            
            PFObject *move = [PFObject objectWithClassName:@"Move"];
            [move setObject:image forKey:@"image"];
            [move setObject:[PFObject objectWithoutDataWithClassName:@"Game" objectId:_game.gameId] forKey:@"game"];
            [move setObject:[PFObject objectWithoutDataWithClassName:@"MyUser" objectId:currentUser.userId] forKey:@"user"];
            
            [move saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [self performSegueWithIdentifier: @"returnToGamesSegue" sender: self];
                }
                else{
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
            
            PFObject *pfGame = [PFQuery getObjectOfClass:@"Game" objectId:_game.gameId];
            [pfGame setValue:move forKey:@"lastMove"];
            [pfGame saveInBackground];
        }
        else{            
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        //HUD.progress = (float)percentDone/100;
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

