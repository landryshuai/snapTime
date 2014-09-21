//
//  DatabaseUtils.h
//  SnapTime
//
//  Created by shuaijiman on 9/20/14.
//  Copyright (c) 2014 shuaijiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimeRecordModel.h"
@interface DatabaseUtils : NSObject
/**
 准备数据库，如果没有数据库，创建数据库
 */
+ (BOOL)prepareDatabase;
/**
 添加数据
 */
+ (void)insertTimeRecord:(TimeRecordModel*)record withResult:(void (^)(BOOL result))block;
/**
 以时间来查询数据。NSArray是个TimeRecordModel的对象
 */
+ (void)queryTimeRecord:(NSTimeInterval)time withResult:(void (^)(NSArray* result))block;
@end
