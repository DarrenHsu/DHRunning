//
//  DHWeather.m
//  DHRunning
//
//  Created by skcu1805 on 2014/5/8.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#import "DHWeather.h"
#import "DHWeatherLocation.h"
#import "DHYAHOOWeatherInfo.h"
#import "TBXML.h"

static DHWeather *weather = nil;

@interface DHWeather () <NSURLConnectionDelegate>

@property (nonatomic, strong) DHWeatherLocation *weatherLocation;

@end

@implementation DHWeather

+ (id) shardWeather {
    @synchronized(weather) {
        if (!weather) {
            weather = [DHWeather new];
        }
    }
    return weather;
}

- (id) init {
    self = [super init];
    if (self) {
        _weatherLocation = [DHWeatherLocation shardDHWeatherLocation];
        [_weatherLocation setDelegate:self];
    }
    return self;
}

- (void) dealloc {
    [self stopWeatherData];
}

- (void) startWeatherData {
    [self setWeoid:nil];
    [_weatherLocation startWeatherLocation];
}

- (void) stopWeatherData {
    [_weatherLocation stoptWeatherLocation];
}

- (void) requestYAHOOWeatherWithWEOID:(NSString *) wid {
    NSMutableString *urlStr = [NSMutableString new];
    [urlStr appendFormat:@"http://weather.yahooapis.com/forecastrss"];
    [urlStr appendFormat:@"?w=%@",wid];
    [urlStr appendFormat:@"&u=c"];
    
    NSLog(@"start request %@\n",urlStr);
    
    NSURL *URL = [[NSURL alloc] initWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
    NSURLSession *session = [NSURLSession new];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self processWeatherData:data];
    }];

    [task resume];
}

- (void) requestYAHOOLocationWithLongitude:(CLLocationDegrees)lon latitude:(CLLocationDegrees)lat {
    NSString *query = [NSString stringWithFormat:@"select * from geo.placefinder where text=\"%f, %f\" and gflags=\"R\"",lon,lat];
    
    NSMutableString *urlStr = [NSMutableString new];
    [urlStr appendFormat:@"https://query.yahooapis.com/v1/public/yql"];
    [urlStr appendFormat:@"?q=%@",query];
    [urlStr appendFormat:@"&format=json"];
    
    NSLog(@"start request %@\n",urlStr);
    
    NSString* encodedUrl = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    NSURL *URL = [[NSURL alloc] initWithString:encodedUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self processLocationData:data];
    }];

    [task resume];
}

#pragma mark - DHWeatherLocationDelegate Methods
- (void) receiverLocationLongitude:(CLLocationDegrees)lon latitude:(CLLocationDegrees)lat {
    [self requestYAHOOLocationWithLongitude:lon latitude:lat];
}

#pragma mark - Process dATA
- (void) processLocationData:(NSData *) data {
//    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",string);

    NSError *e = nil;
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers
                                                           error:&e];
    
    if (!JSON) return;
    NSDictionary *query = [JSON objectForKey:@"query"];
    NSDictionary *results = [query objectForKey:@"results"];
    if ([results isKindOfClass:[NSNull class]]) return;
    
    NSDictionary *result = [results objectForKey:@"Result"];

    if (!result) return;
    NSString *wid = [result objectForKey:@"woeid"];
    NSString *lang = [result objectForKey:@"lang"];
    
    if ([wid isEqualToString:_weoid]) return;
    
    [self setLang:lang];
    [self setWeoid:wid];
    
    [self requestYAHOOWeatherWithWEOID:_weoid];
}

- (void) processWeatherData:(NSData *) data {
//    NSString *string = [[NSString alloc] initWithData:_receiverData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",string);
    
    TBXML *xml = [[TBXML alloc] initWithXMLData:data];

    TBXMLElement *rss = [xml rootXMLElement];
    if (!rss) return;
    
    TBXMLElement *channel = [TBXML childElementNamed:@"channel" parentElement:rss];
    if (!channel) return;
    
    DHYAHOOWeatherInfo *info = [DHYAHOOWeatherInfo shardDHYAHOOWeatherInfo];
    
    TBXMLElement *location = [TBXML childElementNamed:@"yweather:location" parentElement:channel];
    if (location) {
        [info setCountry:[TBXML valueOfAttributeNamed:@"country" forElement:location]];
        [info setCity:[TBXML valueOfAttributeNamed:@"city" forElement:location]];
    }
    
    TBXMLElement *wind = [TBXML childElementNamed:@"yweather:wind" parentElement:channel];
    if (wind) {
        [info setChill:[[TBXML valueOfAttributeNamed:@"chill" forElement:wind] integerValue]];
        [info setDirection:[[TBXML valueOfAttributeNamed:@"direction" forElement:wind] integerValue]];
        [info setSpeed:[[TBXML valueOfAttributeNamed:@"speed" forElement:wind] integerValue]];
    }
    
    TBXMLElement *atmosphere = [TBXML childElementNamed:@"yweather:atmosphere" parentElement:channel];
    if (atmosphere) {
        [info setHumidity:[[TBXML valueOfAttributeNamed:@"humidity" forElement:atmosphere] integerValue]];
    }
    
    TBXMLElement *astronomy = [TBXML childElementNamed:@"yweather:astronomy" parentElement:channel];
    if (astronomy) {
        [info setSunrise:[TBXML valueOfAttributeNamed:@"sunrise" forElement:astronomy]];
        [info setSunset:[TBXML valueOfAttributeNamed:@"sunset" forElement:astronomy]];
    }
    
    TBXMLElement *item = [TBXML childElementNamed:@"item" parentElement:channel];
    if (item) {
        TBXMLElement *condition = [TBXML childElementNamed:@"yweather:condition" parentElement:item];
        if (condition) {
            [info setTemp:[[TBXML valueOfAttributeNamed:@"temp" forElement:condition] intValue]];
            [info setCode:[[TBXML valueOfAttributeNamed:@"code" forElement:condition] intValue]];
        }
        
        [info.forecasts removeAllObjects];
        TBXMLElement *forecast = [TBXML childElementNamed:@"yweather:forecast" parentElement:item];
        do {
            DHYAHOOWeatherForecast *fct = [DHYAHOOWeatherForecast new];
            [fct setCode:[[TBXML valueOfAttributeNamed:@"code" forElement:forecast] intValue]];
            [fct setLow:[[TBXML valueOfAttributeNamed:@"low" forElement:forecast] intValue]];
            [fct setHigh:[[TBXML valueOfAttributeNamed:@"high" forElement:forecast] intValue]];
            [fct setDay:[TBXML valueOfAttributeNamed:@"day" forElement:forecast]];
            [fct setDate:[TBXML valueOfAttributeNamed:@"date" forElement:forecast]];
            [info.forecasts addObject:fct];
        } while ((forecast = [TBXML nextSiblingNamed:@"yweather:forecast" searchFromElement:forecast]));
    }
    
    NSLog(@"%@",info);
}

@end
