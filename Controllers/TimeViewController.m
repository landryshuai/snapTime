//
//  TimeViewController.m
//  SnapTime
//
//  Created by shuaijiman on 9/13/14.
//  Copyright (c) 2014 shuaijiman. All rights reserved.
//

#import "TimeViewController.h"
@interface TimeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UITextField *contentField1;
@property (weak, nonatomic) IBOutlet UITextField *contentField2;
@property (weak, nonatomic) IBOutlet UITextField *contentField3;
@property (strong, nonatomic) NSDateFormatter *formatter;
@end

@implementation TimeViewController

-(void)dealloc
{
    _formatter = nil;
}

-(NSDateFormatter *)formatter
{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:DEFAULT_TIME_STYLE];
    }
    return _formatter;
}
-(NSString*) getTodayDateString
{
    NSDate *today = [NSDate date];
    return [self.formatter stringFromDate:today];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self resetData];
}

- (IBAction)addClick:(id)sender {
    NSDate *date = [self.formatter dateFromString:self.timeLable.text];
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    int i = 1;
    if (self.contentField1.text && self.contentField1.text.length != 0) {
        [mutableString appendFormat:@"#%d %@ ", i, self.contentField1.text];
        i++;
    }
    if (self.contentField2.text && self.contentField2.text.length != 0) {
        [mutableString appendFormat:@"#%d %@ ", i, self.contentField2.text];
        i++;
    }
    if (self.contentField3.text && self.contentField3.text.length != 0) {
        [mutableString appendFormat:@"#%d %@", i, self.contentField3.text];
    }
    TimeRecordModel *recordModel = [[TimeRecordModel alloc] initWithTime:date
                                    thing:mutableString];
    [DatabaseUtils insertTimeRecord:recordModel withResult:^(BOOL result) {
        NSLog(@"insert result:%d", result);
        [self resetData];
        if (result) {
            //GOTO list or exit
            [self performSegueWithIdentifier:@"showTimeList" sender:self];
        }
    }];
}

- (void) resetData
{
    self.timeLable.text = [self getTodayDateString];
    self.contentField1.text = nil;
    self.contentField2.text = nil;
    self.contentField3.text = nil;
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
