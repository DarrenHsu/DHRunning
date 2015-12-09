//
//  DHCompassViewController.m
//  DHRunning
//
//  Created by skcu1805 on 2014/5/2.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#import "DHCompassViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

#define degreesToRadians(x) (M_PI * x / 180.0)

@interface DHCompassViewController () <CLLocationManagerDelegate> {
    CLLocationDirection _lastKnownHeading;
    int _lastDirection;
}

@property (nonatomic, retain) CLLocationManager *locationManager;

@end

@implementation DHCompassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
	[self setLocationManager:[CLLocationManager new]];
	[self.locationManager setDelegate:self];
	[self.locationManager setHeadingFilter:1];
	[self.locationManager setDistanceFilter:kCLDistanceFilterNone];
	[self.locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.locationManager startUpdatingLocation];
	[self.locationManager startUpdatingHeading];
}

- (void) viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[self.locationManager stopUpdatingLocation];
	[self.locationManager stopUpdatingHeading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark CLLocationManagerDelegate Methods
- (BOOL) locationManagerShouldDisplayHeadingCalibration: (CLLocationManager *)manager {
	return YES;
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	[self updateArrow:newLocation];
	NSString *latitudeString = [[NSString alloc] initWithFormat:@"%g",newLocation.coordinate.latitude];
	NSString *longtitudeString = [[NSString alloc] initWithFormat:@"%g",newLocation.coordinate.longitude];
	[self.longtitudeLabel setText:longtitudeString];
	[self.latitudeLabel setText:latitudeString];
	[self updateArrow:[manager location]];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
	_lastKnownHeading = newHeading.magneticHeading * M_PI / 180.0;
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:NSNumberFormatterNoStyle];
	[formatter setPositiveFormat:@"###"];
	[formatter setLenient:YES];
	
	NSString *value = [formatter stringFromNumber:[NSNumber numberWithDouble:newHeading.magneticHeading]];
	[self.directionLabel setText:value];
	[self updateDirection:newHeading.magneticHeading];
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error  {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
													message:@"GPS Error"
												   delegate:self
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
}

- (void) updateDirection:(int) direction{
    if (_lastDirection == direction) return;
    _lastDirection = direction;
	self.compassImageView.transform = CGAffineTransformMakeRotation(-1 * degreesToRadians(direction));
}

- (void) updateArrow:(CLLocation *) lastKnownLoc{
	if(lastKnownLoc) {
        NSLog(@"update ");
		double itemLon = 0.0;
		double itemLat = 0.0;
		double itemLatRad = itemLat / 180.0 / M_PI ;
		double itemLonRad = itemLon / 180.0 / M_PI;
		double ourLatRad = lastKnownLoc.coordinate.latitude / 180.0 / M_PI;
		double ourLonRad = lastKnownLoc.coordinate.longitude /180.0 / M_PI;
		double angleFromUsToItem = atan( (itemLatRad - ourLatRad) / (itemLonRad - ourLonRad) );
		self.compassImageView.transform = CGAffineTransformMakeRotation(angleFromUsToItem - _lastKnownHeading);
	}
}

@end