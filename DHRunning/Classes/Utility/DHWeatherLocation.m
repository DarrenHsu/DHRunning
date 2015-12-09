//
//  DHWeatherLocation.m
//  DHRunning
//
//  Created by skcu1805 on 2014/5/8.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#import "DHWeatherLocation.h"

static DHWeatherLocation *location = nil;

@interface DHWeatherLocation () <CLLocationManagerDelegate> {
    CLLocationDegrees _longitude;
    CLLocationDegrees _latitude;
}

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation DHWeatherLocation

+ (id) shardDHWeatherLocation {
    @synchronized(location) {
        if (!location) {
            location = [DHWeatherLocation new];
        }
    }
    return location;
}

- (void) startWeatherLocation {
    _locationManager = [CLLocationManager new];
    [_locationManager setDelegate:self];
    [_locationManager setDistanceFilter:kCLDistanceFilterNone];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [_locationManager setDistanceFilter:1000];
    [_locationManager startUpdatingLocation];
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager requestAlwaysAuthorization];
}

- (void) stoptWeatherLocation {
    if (_locationManager)
        [_locationManager stopUpdatingLocation];
}

- (void) dealloc {
    [self startWeatherLocation];
}

#pragma mark - CLLocationManagerDelegate Methods
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (_longitude == manager.location.coordinate.longitude &&
        _latitude == manager.location.coordinate.latitude)
        return;
    
    _longitude = manager.location.coordinate.longitude;
    _latitude = manager.location.coordinate.latitude;
        
    if (_delegate && [_delegate respondsToSelector:@selector(receiverLocationLongitude:latitude:)])
        [_delegate receiverLocationLongitude:manager.location.coordinate.longitude latitude:manager.location.coordinate.latitude];
}

@end