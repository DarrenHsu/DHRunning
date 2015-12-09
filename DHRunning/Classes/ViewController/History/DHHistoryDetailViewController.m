//
//  DHHistoryDetailViewController.m
//  DHRunning
//
//  Created by skcu1805 on 2014/5/12.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#import "DHHistoryDetailViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "RecordEntity.h"
#import "DHMap.h"

@interface DHHistoryDetailViewController () <GMSMapViewDelegate> {
    CLLocationCoordinate2D _currentCoordinate;
}

@property (nonatomic, strong) GMSMapView *mapView;
@property (nonatomic, strong) GMSMarker *marker;
@property (nonatomic, strong) RecordEntity *recordEntity;

@end

@implementation DHHistoryDetailViewController

- (IBAction) segmentedControlProcess:(id)sender {
    switch ([(UISegmentedControl *)sender selectedSegmentIndex]) {
        case kGMSTypeNormal - 1: {
            [_mapView setMapType:kGMSTypeNormal];
        } break;
        case kGMSTypeSatellite - 1: {
            [_mapView setMapType:kGMSTypeSatellite];
        } break;
        case kGMSTypeTerrain - 1: {
            [_mapView setMapType:kGMSTypeTerrain];
        } break;
        default: {
            [_mapView setMapType:kGMSTypeHybrid];
        } break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDetail];
    
    [_segmentedControl setSelectedSegmentIndex:kGMSTypeNormal - 1];
    [self segmentedControlProcess:kGMSTypeNormal - 1];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initGoogleMap];
}

- (void) initDetail {
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    
    _recordEntity = [RecordEntity getRecordWithRecordId:_recordId];
    [_recordNameLabel setText:_recordEntity.recordName];
    [_startTimeLabel setText:[fmt stringFromDate:_recordEntity.startTime]];
    [_endTimeLabel setText:[fmt stringFromDate:_recordEntity.endTime]];
    [_distanceLabel setText:[NSString stringWithFormat:@"%.01f",[_recordEntity.distance floatValue]]];
    [_maxSpeedLabel setText:[NSString stringWithFormat:@"%.01f",[_recordEntity.maxSpeed floatValue]]];
    [_avgSpeedLabel setText:[NSString stringWithFormat:@"%.01f",[_recordEntity.avgSpeed floatValue]]];
}

- (void) initGoogleMap {
    [GMSServices provideAPIKey:@"AIzaSyBhtVzuRtWDJhEhTgXQ495JsW5D9j-4QXw"];
    
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
    
    _mapView = [GMSMapView mapWithFrame:_mapBaseView.bounds camera:camera];
    _mapView.myLocationEnabled = NO;
    _mapView.accessibilityElementsHidden = YES;
    _mapView.delegate = self;
    
    [_mapBaseView addSubview:_mapView];
    
    [DHMap drawMap:_mapView coordinates:[_recordEntity unarchivedPoints]];
    
    DHLocationCoordinate *shcoordinate = [[_recordEntity unarchivedPoints] firstObject];
    [DHMap drawMap:_mapView markerColor:[UIColor colorWithRed:0.f green:1.f blue:0.f alpha:1.f] title:@"Start" snippet:nil latitude:shcoordinate.latitude longtitude:shcoordinate.longitude];
    
    DHLocationCoordinate *ehcoordinate = [[_recordEntity unarchivedPoints] lastObject];
    [DHMap drawMap:_mapView markerColor:[UIColor colorWithRed:0.f green:.5f blue:0.f alpha:1.f] title:@"End" snippet:nil latitude:ehcoordinate.latitude longtitude:ehcoordinate.longitude];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    [_mapView setDelegate:nil];
}

@end