//
//  DHHistoryDetailViewController.h
//  DHRunning
//
//  Created by skcu1805 on 2014/5/12.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHHistoryDetailViewController : UIViewController

@property (nonatomic, copy) NSString *recordId;

@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, weak) IBOutlet UIView *detalBaseView;
@property (nonatomic, weak) IBOutlet UIView *mapBaseView;

@property (nonatomic, weak) IBOutlet UILabel *recordNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *maxSpeedLabel;
@property (nonatomic, weak) IBOutlet UILabel *startTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *endTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *avgSpeedLabel;

- (IBAction) segmentedControlProcess:(id)sender;

@end