//
//  DHWeatherLocation.h
//  DHRunning
//
//  Created by skcu1805 on 2014/5/8.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol DHWeatherLocationDelegate;

@interface DHWeatherLocation : NSObject

@property (nonatomic, weak) id<DHWeatherLocationDelegate> delegate;

+ (id) shardDHWeatherLocation;

- (void) startWeatherLocation;
- (void) stoptWeatherLocation;

@end

@protocol DHWeatherLocationDelegate  <NSObject>
@optional
- (void) receiverLocationLongitude:(CLLocationDegrees) lon latitude:(CLLocationDegrees) lat;
@end