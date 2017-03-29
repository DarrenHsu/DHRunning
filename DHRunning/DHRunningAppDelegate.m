//
//  DHRunningAppDelegate.m
//  DHRunning
//
//  Created by skcu1805 on 2014/4/30.
//  Copyright (c) 2014年 SKL. All rights reserved.
//

#import "DHRunningAppDelegate.h"
#import "DHTabBarController.h"
#import "DHHistoryNavigationController.h"
#import "CoreData+MagicalRecord.h"
#import "DHLocation.h"
#import "DHWeather.h"
#import "RecordEntity.h"
#import "UserEntity.h"

static NSString * const kRecipesStoreName = @"DHRunning.sqlite";

@interface DHRunningAppDelegate () <DHLocationDelegate>
@end

@implementation DHRunningAppDelegate

+ (DHRunningAppDelegate *) mainAppDelegate
{
    return (DHRunningAppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark AppDelegate Methods
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setupCoreDataStackWithStoreNamed:kRecipesStoreName];
    [UserEntity addDefaultUser];
    [self startSyncWeatherInfo];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [[DHLocation shardDHLocation] removeDelegate:self];
    [[DHWeatherLocation shardDHWeatherLocation] stoptWeatherLocation];
}

- (void) startSyncWeatherInfo
{
    [[DHLocation shardDHLocation] registerDelegate:self];
    [[DHWeather shardWeather] startWeatherData];
}

#pragma mark - NSNotification Methods
- (void) receiverStartDHLocation:(DHLocation *) location {
    UserEntity *user = [UserEntity getCurrentUser];
    [RecordEntity addRecordWithRecordId:location.LocationID recordName:location.LocationName startTime:[NSDate date] user:user];
}

- (void) receiverChangeValueDHLocation:(DHLocation *) location {
    RecordEntity *rEntity = [RecordEntity getRecordWithRecordId:location.LocationID];
    if (!rEntity) return;
    [rEntity updateWithRecordName:location.LocationName endTime:nil distance:location.cumulativeKM maxSpeed:location.hightSpeed avgSpeed:location.averageSpeed points:location.coordinates];
}

- (void) receiverStopDHLocation:(DHLocation *)location {
    RecordEntity *rEntity = [RecordEntity getRecordWithRecordId:location.LocationID];
    if (!rEntity) return;
    [rEntity updateWithRecordName:location.LocationName endTime:[NSDate new] distance:location.cumulativeKM maxSpeed:location.hightSpeed avgSpeed:location.averageSpeed points:location.coordinates];
}

@end
