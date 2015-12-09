//
//  DHYAHOOWeatherInfo.m
//  DHRunning
//
//  Created by skcu1805 on 2014/8/28.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#import "DHYAHOOWeatherInfo.h"

static DHYAHOOWeatherInfo *info = nil;

@implementation DHYAHOOWeatherInfo

+ (id) shardDHYAHOOWeatherInfo {
    @synchronized(info) {
        if (!info) {
            info = [DHYAHOOWeatherInfo new];
            [info setForecasts:[NSMutableArray new]];
        }
    }
    return info;
}

- (NSString *) description {
    NSMutableString *str = [NSMutableString new];
    [str appendFormat:@"country = %@ ,",_country];
    [str appendFormat:@"city = %@ ,",_city];
    [str appendFormat:@"humidity = %zd ,",_humidity];
    [str appendFormat:@"sunrise = %@ ,",_sunrise];
    [str appendFormat:@"sunset = %@ ,",_sunset];
    [str appendFormat:@"direction = %zd ,",_direction];
    [str appendFormat:@"speed = %zd ,",_speed];
    [str appendFormat:@"chill = %zd ,",_chill];
    [str appendFormat:@"temp = %zd ,",_temp];
    [str appendFormat:@"code = %d ,",_code];
    [str appendFormat:@"forecasts = %@",_forecasts];
    return str;
}

@end

@implementation DHYAHOOWeatherForecast

- (NSString *) description {
    NSMutableString *str = [NSMutableString new];
    [str appendFormat:@"day = %@ ,",_date];
    [str appendFormat:@"date = %@ ,",_date];
    [str appendFormat:@"low = %zd ,",_low];
    [str appendFormat:@"high = %zd ,",_high];
    [str appendFormat:@"code = %d",_code];
    return str;
}

@end