//
//  TimeRecordModel.h
//  SnapTime
//
//  Created by shuaijiman on 9/20/14.
//  Copyright (c) 2014 shuaijiman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeRecordModel : NSObject
@property (nonatomic) NSTimeInterval time;
@property (strong, nonatomic) NSString *content;
- (id) initWithTime:(NSDate*)data thing:(NSString*)content;
@end
