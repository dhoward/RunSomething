//
//  MapViewController.m
//  Run
//
//  Created by Daniel Howard on 2/23/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import "MapViewController.h"

#define METERS_PER_MILE 1609.344

@interface MapViewController ()

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    
    NSLog(@"VIEW LOADED");
    // 1
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 39.281516;
    zoomLocation.longitude= -76.580806;
    
    // 2
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    // 3
    [_map setRegion:viewRegion animated:YES];
    
    NSLog(@"DONE");
}

@end
