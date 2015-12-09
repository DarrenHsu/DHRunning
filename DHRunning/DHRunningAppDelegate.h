//
//  DHRunningAppDelegate.h
//  DHRunning
//
//  Created by skcu1805 on 2014/4/30.
//  Copyright (c) 2014年 SKL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHRunningAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

+ (DHRunningAppDelegate *) mainAppDelegate;
- (void) startSyncWeatherInfo;

@end