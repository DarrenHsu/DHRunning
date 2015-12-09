//
//  DHWeather.h
//  DHRunning
//
//  Created by skcu1805 on 2014/5/8.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHWeatherLocation.h"

@interface DHWeather : NSObject <DHWeatherLocationDelegate>

@property (nonatomic, strong) NSString *weoid;
@property (nonatomic, strong) NSString *lang;

+ (id) shardWeather;

- (void) startWeatherData;
- (void) stopWeatherData;

@end

typedef enum {
    DHWeatherConnectionTypeLocation,
    DHWeatherConnectionTypeWeather
} DHWeatherConnectionType;

@interface DHWeatherConnection : NSURLConnection

@property (nonatomic) DHWeatherConnectionType connectionType;

@end