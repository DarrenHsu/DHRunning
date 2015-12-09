//
//  DHTabBarController.m
//  DHRunning
//
//  Created by skcu1805 on 2014/5/2.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#import "DHTabBarController.h"

@interface DHTabBarController ()

@end

@implementation DHTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBar.backgroundColor = [UIColor redColor];
    self.tabBar.tintColor = [UIColor redColor];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    NSLog(@"%@ %@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
}

@end
