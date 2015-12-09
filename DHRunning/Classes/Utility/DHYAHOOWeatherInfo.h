//
//  DHYAHOOWeatherInfo.h
//  DHRunning
//
//  Created by skcu1805 on 2014/8/28.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DHYAHOOWeatherCodeTornado,
    DHYAHOOWeatherCodeTropicalStorm,
    DHYAHOOWeatherCodeHurricane,
    DHYAHOOWeatherCodeSevereThunderstorms,
    DHYAHOOWeatherCodeThunderstorms,
    DHYAHOOWeatherCodeMixedRainAndSnow,
    DHYAHOOWeatherCodeMixedRainAndSleet,
    DHYAHOOWeatherCodeMixedSnowAndSleet,
    DHYAHOOWeatherCodeFreezingDrizzle,
    DHYAHOOWeatherCodeDrizzle,
    DHYAHOOWeatherCodeFreezingRain,
    DHYAHOOWeatherCodeShowers,
    DHYAHOOWeatherCodeShowers2,
    DHYAHOOWeatherCodeSnowFlurries,
    DHYAHOOWeatherCodeLightSnowShowers,
    DHYAHOOWeatherCodeBlowingSnow,
    DHYAHOOWeatherCodeSnow,
    DHYAHOOWeatherCodeHail,
    DHYAHOOWeatherCodeSleet,
    DHYAHOOWeatherCodeDust,
    DHYAHOOWeatherCodeFoggy,
    DHYAHOOWeatherCodeHaze,
    DHYAHOOWeatherCodeSmoky,
    DHYAHOOWeatherCodeBlustery,
    DHYAHOOWeatherCodeWindy,
    DHYAHOOWeatherCodeCold,
    DHYAHOOWeatherCodeCloudy,
    DHYAHOOWeatherCodeMostlyCloudyNight,
    DHYAHOOWeatherCodeMostlyCloudyDay,
    DHYAHOOWeatherCodePartlyCloudyNight,
    DHYAHOOWeatherCodePartlyCloudyDay,
    DHYAHOOWeatherCodeClearNight,
    DHYAHOOWeatherCodeSunny,
    DHYAHOOWeatherCodeFairNight,
    DHYAHOOWeatherCodeFairDay,
    DHYAHOOWeatherCodeMixedRainAndHail,
    DHYAHOOWeatherCodeHot,
    DHYAHOOWeatherCodeIsolatedThunderstorms,
    DHYAHOOWeatherCodeScatteredThunderstorms,
    DHYAHOOWeatherCodeScatteredThunderstorms2,
    DHYAHOOWeatherCodeScatteredShowers,
    DHYAHOOWeatherCodeHeavySnow,
    DHYAHOOWeatherCodeScatteredSnowShowers,
    DHYAHOOWeatherCodeHeavySnow2,
    DHYAHOOWeatherCodePartlyCloudy,
    DHYAHOOWeatherCodeThundershowers,
    DHYAHOOWeatherCodeSnowShowers,
    DHYAHOOWeatherCodeIsolatedThundershowers,
    DHYAHOOWeatherCodeNotAvailable = 3200
} DHYAHOOWeatherCode;

@interface DHYAHOOWeatherInfo : NSObject

@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, assign) NSInteger humidity;
@property (nonatomic, strong) NSString *sunrise;
@property (nonatomic, strong) NSString *sunset;
@property (nonatomic, assign) NSInteger direction;
@property (nonatomic, assign) NSInteger speed;
@property (nonatomic, assign) NSInteger chill;
@property (nonatomic, assign) NSInteger temp;
@property (nonatomic, assign) DHYAHOOWeatherCode code;
@property (nonatomic, strong) NSMutableArray *forecasts;

+ (id) shardDHYAHOOWeatherInfo;

@end

@interface DHYAHOOWeatherForecast : NSObject

@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, assign) NSInteger low;
@property (nonatomic, assign) NSInteger high;
@property (nonatomic, assign) DHYAHOOWeatherCode code;

@end