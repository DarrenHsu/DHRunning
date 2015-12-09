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
    self.navigationBar.backgroundColor = [UIColor redColor];
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:24],
                                               NSForegroundColorAttributeName : [UIColor redColor]};
    self.navigationBar.tintColor = [UIColor redColor];
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