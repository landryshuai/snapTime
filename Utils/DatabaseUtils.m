//
//  DatabaseUtils.m
//  SnapTime
//
//  Created by shuaijiman on 9/20/14.
//  Copyright (c) 2014 shuaijiman. All rights reserved.
//

#import "DatabaseUtils.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
@implementation DatabaseUtils

+ (NSString*) getDataBasePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"time.sqlite"];
    return writableDBPath;
}
+ (BOOL)prepareDatabase
{
    NSString *databasePath = [DatabaseUtils getDataBasePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileFinded = [fileManager fileExistsAtPath:databasePath];
    //数据库不存在, 创建。如果需要升级怎么办？
    if (!fileFinded) {
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:databasePath];
        [queue inDatabase:^(FMDatabase *db) {
            BOOL result = [DatabaseUtils createDatabase:(FMDatabase*) db];
            if (result) {
                NSLog(@"create database success");
            } else {
                NSLog(@"create database fail");
            }
        }];
    }
    return YES;
}

+ (void)insertTimeRecord:(TimeRecordModel *)record withResult:(void (^)(BOOL))block
{
    [[DatabaseUtils getDatabaseQueue] inDatabase:^(FMDatabase *db) {
        //插入数据
        block([db executeUpdate:@"insert into time_snaps (time, content) values (?, ?)",
               [[NSNumber alloc] initWithLong:record.time],record.content]);
    }];
}

+ (void)queryTimeRecord:(NSTimeInterval)time withResult:(void (^)(NSArray *))block
{
    [[DatabaseUtils getDatabaseQueue] inDatabase:^(FMDatabase *db) {
        //查询数据
        NSMutableArray * result = [[NSMutableArray alloc] initWithCapacity:10];
        long dayTimeInterval = 24 * 60 * 60;
        long beginDate = (((long)time)/dayTimeInterval) * dayTimeInterval;
        //TODO BUG: 时间差8个时区。原因是我们的所在的时区相关。需要减掉。
        beginDate = beginDate - 8 * 60 * 60;
        long endDate = beginDate + dayTimeInterval;
        FMResultSet *fmResults = [db executeQuery:@"select * from time_snaps where time >= ? AND time <= ?;",
            [NSNumber numberWithLong:beginDate],
            [NSNumber numberWithLong:endDate]];
        while (fmResults.next) {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[fmResults longForColumn:@"time"]];
            NSString *content = [fmResults stringForColumn:@"content"];
            [result addObject:[[TimeRecordModel alloc] initWithTime:date thing:content]];
        }
        block(result);
    }];
}

#pragma mark private message

+ (BOOL)createDatabase:(FMDatabase*) db
{
    return [db executeUpdate:@"create table time_snaps (id integer primary key autoincrement, time long,content text)"];
}

+ (FMDatabaseQueue* )getDatabaseQueue
{
    NSString *databasePath = [DatabaseUtils getDataBasePath];
    return [FMDatabaseQueue databaseQueueWithPath:databasePath];
}


@end

