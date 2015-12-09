//
//  DHCompassViewController.h
//  DHRunning
//
//  Created by skcu1805 on 2014/5/2.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHRecordMainViewController.h"

@interface DHCompassViewController : DHRecordMainViewController

@property (nonatomic, weak) IBOutlet UIImageView *compassImageView;
@property (nonatomic, weak) IBOutlet UILabel *directionLabel;
@property (nonatomic, weak) IBOutlet UILabel *latitudeLabel;
@property (nonatomic, weak) IBOutlet UILabel *longtitudeLabel;

@end
