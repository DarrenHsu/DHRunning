//
//  DHHistoryTableViewController.h
//  DHRunning
//
//  Created by skcu1805 on 2014/5/2.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHHistoryTableViewController : UITableViewController

@end

@interface DHHistoryTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *avgSpeedLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *recordDateLabel;

@end