//
//  DHGMapViewController.m
//  DHRunning
//
//  Created by skcu1805 on 2014/5/13.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#import "DHGMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "DHMap.h"
#import "DHLocation.h"
#import "UserEntity.h"

@interface DHGMapViewController () <GMSMapViewDelegate,DHLocationDelegate> {
    CLLocationCoordinate2D _currentCoordinate;
}

@property (nonatomic, strong) GMSMapView *mapView;
@property (nonatomic, strong) GMSMarker *marker;
@property (nonatomic, strong) GMSMutablePath *path;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) NSString *snippet;

@end

@implementation DHGMapViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    [GMSServices provideAPIKey:@"AIzaSyBRA9y8POa8I4-NLr21c9dCi3phh5PVGLE"];
    
    GMSCameraPosition *camera = nil;
    
    CLLocationManager *clm = [[CLLocationManager alloc] init];
	[clm setDistanceFilter:10];
	[clm setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
	[clm startUpdatingLocation];
	if (clm.location) {
        _currentCoordinate = clm.location.coordinate;
        camera = [GMSCameraPosition cameraWithLatitude:clm.location.coordinate.latitude longitude:clm.location.coordinate.longitude zoom:18];
	}else {
        camera = [GMSCameraPosition cameraWithLatitude:-33.86 longitude:151.20 zoom:6];
    }
	[clm stopUpdatingHeading];

    _mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    _mapView.myLocationEnabled = YES;
    _mapView.accessibilityElementsHidden = YES;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    DHLocation *object = [DHLocation shardDHLocation];
    [object registerDelegate:self];
    
    _icon = [UIImage imageNamed:@"Header"];
    _path = [DHMap drawMap:_mapView coordinates:object.coordinates];
    
    UserEntity *user = [UserEntity getCurrentUser];
    _snippet = [NSString stringWithFormat:@"Sexy:%@\nHeight:%@\nWeight:%@",[user.sexy boolValue] ? @"Man" : @"Woman",user.height,user.weight];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addMarker {
    if (!_marker) {
        UserEntity *user = [UserEntity getCurrentUser];
        _marker = [DHMap drawMap:_mapView markIcon:_icon title:user.name snippet:_snippet latitude:_mapView.camera.target.latitude longtitude:_mapView.camera.target.longitude];
    }else {
        if (!_marker.map)
            [_marker setMap:_mapView];
        
        if (_mapView.myLocation)
            [DHMap moveMark:_marker latitude:_mapView.myLocation.coordinate.latitude longtitude:_mapView.myLocation.coordinate.longitude];
    }
}

#pragma mark - GMSMapViewDelegate
- (void) mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    [self addMarker];
}

- (void) mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)cameraPosition {
    [self addMarker];
}

#pragma mark - NSNotification Methods
- (void) receiverStopDHLocation:(DHLocation *) location {
    [_mapView clear];
    [self addMarker];
}

- (void) receiverChangeDHLocation:(DHLocation *) location {
    if (!location.currentLocation) return;
    
    [_mapView clear];
    
    CLLocationCoordinate2D coordinate = location.currentLocation.coordinate;
    [DHMap addMap:_mapView path:_path latitude:coordinate.latitude longtitude:coordinate.longitude];
    
    UserEntity *user = [UserEntity getCurrentUser];
    _marker = [DHMap drawMap:_mapView markIcon:_icon title:user.name snippet:_snippet latitude:coordinate.latitude longtitude:coordinate.longitude];
}

@end
