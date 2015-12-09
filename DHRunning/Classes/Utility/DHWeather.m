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
@property (nonatomic, strong) NSMutableData *receiverData;

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
    DHWeatherConnection *connection = [[DHWeatherConnection alloc] initWithRequest:request delegate:self];
    [connection setConnectionType:DHWeatherConnectionTypeWeather];
    [connection start];
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
    DHWeatherConnection *connection = [[DHWeatherConnection alloc] initWithRequest:request delegate:self];
    [connection setConnectionType:DHWeatherConnectionTypeLocation];
    [connection start];
}

#pragma mark - DHWeatherLocationDelegate Methods
- (void) receiverLocationLongitude:(CLLocationDegrees)lon latitude:(CLLocationDegrees)lat {
    [self requestYAHOOLocationWithLongitude:lon latitude:lat];
}

#pragma mark - NSURLConnectionDelegate Methods
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (!_receiverData)
        _receiverData = [NSMutableData new];

    [_receiverData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
//    NSString *str = [[NSString alloc] initWithData:_receiverData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",str);
    switch ([((DHWeatherConnection *)connection) connectionType]) {
        case DHWeatherConnectionTypeLocation:
            [self processLocationData];
            break;
        case DHWeatherConnectionTypeWeather:
            [self processWeatherData];
            break;
        default:
            break;
    }
}

- (void) processLocationData {
    NSError *e = nil;
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:_receiverData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&e];
    
    if (!JSON) return;
    NSDictionary *query = [JSON objectForKey:@"query"];
    NSDictionary *results = [query objectForKey:@"results"];
    NSDictionary *result = [results objectForKey:@"Result"];

    if (!result) return;
    NSString *wid = [result objectForKey:@"woeid"];
    NSString *lang = [result objectForKey:@"lang"];
    
    if ([wid isEqualToString:_weoid]) return;
    
    [self setLang:lang];
    [self setWeoid:wid];
    [self setReceiverData:nil];
    
    [self requestYAHOOWeatherWithWEOID:_weoid];
}

- (void) processWeatherData {
//    NSString *string = [[NSString alloc] initWithData:_receiverData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",string);
    
    TBXML *xml = [[TBXML alloc] initWithXMLData:_receiverData];

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
    [self setReceiverData:nil];
}

@end

@implementation DHWeatherConnection

@end
