//
//  TimeListViewController.m
//  SnapTime
//
//  Created by shuaijiman on 9/13/14.
//  Copyright (c) 2014 shuaijiman. All rights reserved.
//

#import "TimeListViewController.h"

@interface TimeListViewController () <UITabBarControllerDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *timeline;
@property (nonatomic,strong) NSMutableArray *timeRecords;
@end

@implementation TimeListViewController
-(void)dealloc
{
    _showDate = nil;
    _timeRecords = nil;
}

- (NSMutableArray *)timeRecords
{
    if (!_timeRecords) {
        _timeRecords = [[NSMutableArray alloc] init];
    }
    return _timeRecords;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSDate *date;
    //如果没有设置时间，取当前时间
    if (!self.showDate) {
        date = [NSDate date];
    }
    //去数据库查询时间
    [DatabaseUtils queryTimeRecord:[date timeIntervalSince1970] withResult:^(NSArray *result) {
        [self.timeRecords removeAllObjects];
        [self.timeRecords addObjectsFromArray:result];
        [self.timeline reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.timeRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tableView:%@", indexPath);
    static NSString *cellId = @"timeList";
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    NSInteger row = [indexPath row];
    NSLog(@"row:");
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:DEFAULT_TIME_STYLE];
    TimeRecordModel *tmp = [self.timeRecords objectAtIndex:row];
    cell.detailTextLabel.text = tmp.content;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:tmp.time];
    cell.textLabel.text = [formatter stringFromDate:date];
    //cell.imageView.image = [self.listImg objectAtIndex:row];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
