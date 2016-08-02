//
//  DHRecordViewController.h
//  DHRunning
//
//  Created by skcu1805 on 2014/5/2.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHRecordMainViewController.h"

@interface DHRecordViewController : DHRecordMainViewController

@property (nonatomic, weak) IBOutlet UILabel *recordNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *currentSpeedLabel;
@property (nonatomic, weak) IBOutlet UILabel *elapseedLabel;
@property (nonatomic, weak) IBOutlet UILabel *maxSpeedLabel;
@property (nonatomic, weak) IBOutlet UILabel *heightLabel;
@property (nonatomic, weak) IBOutlet UILabel *avgSpeedLabel;
@property (nonatomic, weak) IBOutlet UIImageView *startLocationImageView;
@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, weak) IBOutlet UILabel *countryLabel;
@property (nonatomic, weak) IBOutlet UILabel *cityLabel;
@property (nonatomic, weak) IBOutlet UILabel *tempLabel;
@property (nonatomic, weak) IBOutlet UILabel *humidityLabel;
@property (nonatomic, weak) IBOutlet UILabel *winSpeedLabel;
@property (nonatomic, weak) IBOutlet UIWebView *weatherWebView;

- (IBAction) playButtonPressed:(id) sender;

@end