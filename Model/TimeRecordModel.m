//
//  TimeRecordModel.m
//  SnapTime
//
//  Created by shuaijiman on 9/20/14.
//  Copyright (c) 2014 shuaijiman. All rights reserved.
//

#import "TimeRecordModel.h"

@implementation TimeRecordModel
-(void)dealloc
{
    _content = nil;
}

- (id)initWithTime:(NSDate *)date thing:(NSString *)content
{
    self = [super init];
    if (self) {
        _content = content;
        _time = [date timeIntervalSince1970];
    }
    return self;
}
@end
