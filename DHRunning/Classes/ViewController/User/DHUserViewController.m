//
//  DHUserViewController.m
//  DHRunning
//
//  Created by skcu1805 on 2014/5/7.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#import "DHUserViewController.h"
#import "UserEntity.h"
#import "DHRunningAppDelegate.h"

@interface DHUserViewController ()

@property (nonatomic, strong) UserEntity *user;

@end

@implementation DHUserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _user = [UserEntity getCurrentUser];
    
    if (_user) {
        [_userLabel setText:_user.name];
        [_genderLabel setText:_user.sexy.boolValue ? @"Males" : @"Females"];
        [_weightLabel setText:[NSString stringWithFormat:@"%.01f",_user.weight.floatValue]];
        [_heightLabel setText:[NSString stringWithFormat:@"%.01f",_user.height.floatValue]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end