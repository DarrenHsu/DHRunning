//
//  main.m
//  DHRunning
//
//  Created by skcu1805 on 2014/4/30.
//  Copyright (c) 2014年 SKL. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DHRunningAppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        @try {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([DHRunningAppDelegate class]));
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        @finally {
        }
        
    }
}
