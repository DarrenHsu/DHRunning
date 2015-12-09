//
//  DHHistoryTableViewController.m
//  DHRunning
//
//  Created by skcu1805 on 2014/5/2.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#import "DHHistoryTableViewController.h"
#import "DHRunningAppDelegate.h"
#import "DHHistoryDetailViewController.h"
#import "RecordEntity.h"

@interface DHHistoryTableViewController () {
    RecordEntity *_selectRecord;
}

@property (nonatomic, strong) NSMutableArray *records;

@end

@implementation DHHistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [RecordEntity getRecordsWithCompletion:^(NSMutableArray *results, NSUInteger count) {
        [self setRecords:results];
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_records count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DHHistoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
    
    RecordEntity *rEntity = [_records objectAtIndex:indexPath.row];
    
    [cell.distanceLabel setText:[NSString stringWithFormat:@"%.01f",rEntity.distance.floatValue]];
    [cell.avgSpeedLabel setText:[NSString stringWithFormat:@"%.01f",rEntity.avgSpeed.floatValue]];

    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = @"yyyy/MM/dd";
    NSString *dateString = [fmt stringFromDate:rEntity.createTime];
    [cell.recordDateLabel setText:dateString];
    
    return cell;
}


#pragma mark - UITableViewDelegate Methods
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        RecordEntity *rEntity = [_records objectAtIndex:indexPath.row];
        [_records removeObject:rEntity];
        [rEntity deleteSelf];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Seque Methods
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"ShowDetail"]){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(DHHistoryTableCell *)sender];
        _selectRecord = [_records objectAtIndex:indexPath.row];
        
        DHHistoryDetailViewController *controller = (DHHistoryDetailViewController *)[segue destinationViewController];
        [controller setRecordId:_selectRecord.recordId];
    }
}

@end

@implementation DHHistoryTableCell

@end