//
//  DHNavigationController.m
//  DHRunning
//
//  Created by skcu1805 on 2014/5/2.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#import "DHNavigationController.h"
#import "DHRunningAppDelegate.h"

@interface DHNavigationController ()

@end

@implementation DHNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationBar.barTintColor = [UIColor redColor];
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:24],
                                               NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end