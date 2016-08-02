//
//  DHRecordViewController.m
//  DHRunning
//
//  Created by skcu1805 on 2014/5/2.
//  Copyright (c) 2014年 DH. All rights reserved.
//

@import CoreLocation;

#import "DHRecordViewController.h"
#import "DHLocation.h"
#import "DHYAHOOWeatherInfo.h"
#import "DHRunningAppDelegate.h"
#import "DHWeather.h"

@interface DHRecordViewController () <DHLocationDelegate>

@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation DHRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self syncValue];
    
    [[DHLocation shardDHLocation] registerDelegate:self];
    
    DHYAHOOWeatherInfo *info = [DHYAHOOWeatherInfo shardDHYAHOOWeatherInfo];
    [info addObserver:self forKeyPath:@"city" options:NSKeyValueObservingOptionNew context:NULL];
    [info addObserver:self forKeyPath:@"humidity" options:NSKeyValueObservingOptionNew context:NULL];
    [info addObserver:self forKeyPath:@"temp" options:NSKeyValueObservingOptionNew context:NULL];
    [info addObserver:self forKeyPath:@"speed" options:NSKeyValueObservingOptionNew context:NULL];
    [info addObserver:self forKeyPath:@"code" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    DHYAHOOWeatherInfo *info = [DHYAHOOWeatherInfo shardDHYAHOOWeatherInfo];
    if ([keyPath isEqualToString:@"city"])
        [_cityLabel setText:info.city];
    else if ([keyPath isEqualToString:@"humidity"])
        [_humidityLabel setText:[NSString stringWithFormat:@"%zd",info.humidity]];
    else if ([keyPath isEqualToString:@"temp"])
        [_tempLabel setText:[NSString stringWithFormat:@"%zd",info.temp]];
    else if ([keyPath isEqualToString:@"speed"])
        [_winSpeedLabel setText:[NSString stringWithFormat:@"%zd",info.speed]];
    if ([keyPath isEqualToString:@"code"]) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://l.yimg.com/a/i/us/we/52/%d.gif",info.code]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_weatherWebView loadRequest:request];
    }
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    [[DHLocation shardDHLocation] removeDelegate:self];
    
    DHYAHOOWeatherInfo *info = [DHYAHOOWeatherInfo shardDHYAHOOWeatherInfo];
    [self removeObserver:info forKeyPath:@"city"];
    [self removeObserver:info forKeyPath:@"humidity"];
    [self removeObserver:info forKeyPath:@"temp"];
    [self removeObserver:info forKeyPath:@"speed"];
    [self removeObserver:info forKeyPath:@"code"];
}

- (IBAction) playButtonPressed:(id) sender {
    DHLocation *object = [DHLocation shardDHLocation];
    if (object.appCurrentActionTag == KATStopRecoding) {
        int r = rand() % 100;
        [object startWithLocationName:[NSString stringWithFormat:@"my record %d",r] locationId:[DHLocation stringWithNewUUID]];
        
        DHRunningAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate startSyncWeatherInfo];
    }else if (object.appCurrentActionTag == KATPlayRecoding) {
        [object stopLocation];
        [self syncValue];
    }
}

- (void) syncValue {
    DHLocation *object = [DHLocation shardDHLocation];
    
    [_recordNameLabel setText:object.LocationName];
    
    if (object.appCurrentActionTag == KATPlayRecoding) {
        [_playButton setImage:[UIImage imageNamed:@"AP-02_menu_r1_c5.png"] forState:UIControlStateNormal];
    } else if (object.appCurrentActionTag == KATStopRecoding) {
        [_playButton setImage:[UIImage imageNamed:@"AP-02_menu_r1_c1.png"] forState:UIControlStateNormal];
    }

    [_cityLabel setText:object.locality];
    [_countryLabel setText:object.countryName];

    [_distanceLabel setText:[NSString stringWithFormat:@"%.01f",object.cumulativeKM]];
    [_currentSpeedLabel setText:[NSString stringWithFormat:@"%.01f",object.currentSpeed]];
    [_heightLabel setText:[NSString stringWithFormat:@"%.01f",object.altitude]];
    [_maxSpeedLabel setText:[NSString stringWithFormat:@"%.01f",object.hightSpeed]];
    [_avgSpeedLabel setText:[NSString stringWithFormat:@"%.01f",object.averageSpeed]];
    [_startLocationImageView setImage:[UIImage imageNamed:object.locationOn ? @"AP-02_gps-on.png" : @"AP-02_gps.png"]];
    
    unsigned int internal = object.cumulativeTimeInternal;
    NSString *cumulativeTime = 	[[NSString alloc] initWithFormat:@"%02d:%02d:%02d", internal / 3600,(internal % 3600) / 60 , internal % 60];
	[_elapseedLabel setText:cumulativeTime];
}

#pragma mark - NSNotification Methods
- (void) receiverStartDHLocation:(DHLocation *) location {
    
}

- (void) receiverSuspendedDHLocation:(DHLocation *) location {
    
}

- (void) receiverStopDHLocation:(DHLocation *) location {
    
}

- (void) receiverChangeTimeDHLocation:(DHLocation *) location {
    [self syncValue];
}

- (void) receiverChangeValueDHLocation:(DHLocation *) location {
    [self syncValue];
}

- (void) receiverChangeDHLocation:(DHLocation *) location {
    [self syncValue];
}

- (void) receiverErrorDHLocation:(DHLocation *) location {
}

@end