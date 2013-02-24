//
//  MapViewController.m
//  Run
//
//  Created by Daniel Howard on 2/23/13.
//  Copyright (c) 2013 RDG. All rights reserved.
//

#import "MapViewController.h"

#define METERS_PER_MILE 1609.344

@implementation MapViewController

- (void)viewDidAppear:(BOOL)animated {
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 39.281516;
    zoomLocation.longitude= -76.580806;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.1*METERS_PER_MILE, 0.1*METERS_PER_MILE);
    [_map setRegion:viewRegion animated:NO];
}

@end
