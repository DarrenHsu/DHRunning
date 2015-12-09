//
//  DHMapViewController.m
//  DHRunning
//
//  Created by skcu1805 on 2014/5/2.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#import "DHMapViewController.h"
#import "CrumbPath.h"
#import "CrumbPathView.h"
#import "DHLocation.h"

@interface DHMapViewController () <DHLocationDelegate> {
    CLLocationCoordinate2D _mapCoordinate;
    NSTimer *_timer;
}

@property (nonatomic, strong) CrumbPath *crumbs;
@property (nonatomic, strong) CrumbPathView *crumbView;

@end

@implementation DHMapViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
	DHLocation *object = [DHLocation shardDHLocation];
    for (DHLocationCoordinate *coordinate in object.coordinates) {
        [self drawPathWithLatitude:coordinate.latitude longtitude:coordinate.longitude];
    }
    
    [object registerDelegate:self];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mapView setShowsUserLocation:YES];
    [self updateUserLocation];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mapView setShowsUserLocation:NO];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) dealloc {
    [[DHLocation shardDHLocation] removeDelegate:self];
}

- (void) updateUserLocation {
    CLLocationManager *clm = [[CLLocationManager alloc] init];
	[clm setDistanceFilter:10];
	[clm setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
	[clm startUpdatingLocation];
	if (clm.location) {
		MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(clm.location.coordinate, 500, 500);
		MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
		[self.mapView setRegion:adjustedRegion animated:YES];
	}
	[clm stopUpdatingHeading];
}

#pragma mark - NSNotification Methods
- (void) receiverStartDHLocation:(DHLocation *) location {
    
}

- (void) receiverSuspendedDHLocation:(DHLocation *) location {
    
}

- (void) receiverStopDHLocation:(DHLocation *) location {
    
}

- (void) receiverChangeValueDHLocation:(DHLocation *) location {
    
}

- (void) receiverChangeDHLocation:(DHLocation *) location {
    if (!location.currentLocation) return;
    CLLocationCoordinate2D coordinate = location.currentLocation.coordinate;
    [self drawPathWithLatitude:coordinate.latitude longtitude:coordinate.longitude];
}

- (void) receiverErrorDHLocation:(DHLocation *) location {
    
}

- (void) drawPathWithLatitude:(CLLocationDegrees) newlatitude longtitude:(CLLocationDegrees) newlongtitude  {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(newlatitude, newlongtitude);
    
	if (!_crumbs) {
		_crumbs = [[CrumbPath alloc] initWithCenterCoordinate:coordinate];
		[self.mapView addOverlay:_crumbs];
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500);
        [self.mapView setRegion:region animated:NO];
	} else {
		MKMapRect updateRect = [_crumbs addCoordinate:coordinate];

        if (!MKMapRectIsNull(updateRect)) {
            MKZoomScale currentZoomScale = (CGFloat)(self.mapView.bounds.size.width / self.mapView.visibleMapRect.size.width);
            CGFloat lineWidth = MKRoadWidthAtZoomScale(currentZoomScale);
            updateRect = MKMapRectInset(updateRect, -lineWidth, -lineWidth);
            [_crumbView setNeedsDisplayInMapRect:updateRect];
        }
	}
}

#pragma mark -
#pragma mark MKMapViewDelegate Methods
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    if (!_crumbView) {
        _crumbView = [[CrumbPathView alloc] initWithOverlay:overlay];
    }
    
    return _crumbView;
}

@end