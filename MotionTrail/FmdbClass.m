//
//  FmdbClass.m
//  MotionTrail
//
//  Created by chao on 16/4/13.
//  Copyright © 2016年 DoctorMundo. All rights reserved.
//

#import "FmdbClass.h"
#import <FMDB.h>
#import "UtilityClass.h"
#import "LocationModel.h"

FMDatabase    *__db;

@implementation FmdbClass

+ (FmdbClass *)shareFmdbClass {
    
    static FmdbClass *fmdbClass = nil;
    
    dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        fmdbClass = [[FmdbClass alloc] init];
        [self loadFMDB];
    });
    return fmdbClass;
}
+ (void)loadFMDB {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MyDatabase.db"];
    NSLog(@"dbPath=%@",dbPath);
    __db = [FMDatabase databaseWithPath:dbPath];
    [__db open];
    
    if (![__db open]) {
        NSLog(@"Could not open db");
        return;
    }
    if (![__db tableExists:@"MOTIONTRAIL"]) {
        [__db executeUpdate:@"CREATE TABLE MOTIONTRAIL (Name text,Time text,StartAddress text,EndAddress text)"];
        NSLog(@"Creat Motiontrail Table success");
    }
}
+(void)createDataTable:(NSString *)tableName startAddress:(NSString *)str1 endAddress:(NSString *)str2 {
    if (![__db tableExists:tableName]) {
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE %@ (Time text,Latitude Double,Longitude Double)",tableName];
        [__db executeUpdate:sql];
        NSLog(@"Creat db Table success");
    }
    if ([__db tableExists:tableName]) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO MOTIONTRAIL (Name,Time,StartAddress,EndAddress) VALUES ('%@','%@','%@','%@')",tableName,[UtilityClass timestamp1],str1,str2];
        [__db executeUpdate:sql];
    }
    
}


+ (void)addData:(NSString *)name array:(NSArray *)arr {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MyDatabase.db"];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    dispatch_queue_t q1 = dispatch_queue_create("queue1", NULL);
    dispatch_async(q1, ^{
        NSLog(@"启动事务");
        NSDate *date = [NSDate date];
        
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            [db shouldCacheStatements];
            for (int i = 0; i<arr.count; i++) {
                LocationModel *model = arr[i];
                NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(Time,Latitude,Longitude) VALUES ('%@','%f','%f')",name,model.time,model.latitude,model.longitude];
                
                [db executeUpdate:sql];
            }
        }];
        
        float interval = [[NSDate date] timeIntervalSinceDate:date];
        NSLog(@"总耗时：%f", interval);
    });
    
    
   
}



+(void)deleteData:(NSString *)name {
    
    if ([__db tableExists:name]) {
        NSString *sql = [NSString stringWithFormat:@"DROP TABLE %@",name];
        [__db executeUpdate:sql];
        
    }
    NSString *sql1 = [NSString stringWithFormat:@"DELETE FROM MOTIONTRAIL WHERE Name = '%@'",name];
    [__db executeUpdate:sql1];
}
+(NSMutableArray *)selectAllData {
     NSString *sql = @"Select * from MOTIONTRAIL";
    FMResultSet *set = [__db executeQuery:sql];
    NSMutableArray *mArray = [NSMutableArray array];
    while ([set next]) {
        LocationModel *model = [[LocationModel alloc] init];
        model.time = [set stringForColumn:@"Time"];
        model.name = [set stringForColumn:@"Name"];
        model.startAddress = [set stringForColumn:@"StartAddress"];
        model.endAddress  =  [set stringForColumn:@"EndAddress"];
        [mArray addObject:model];
    }
    return mArray;
}

+(NSArray *)selectData:(NSString *)name {
    
    NSString *sql = [NSString stringWithFormat:@"Select * from %@",name];
    FMResultSet *set = [__db executeQuery:sql];
    NSMutableArray *mArray = [NSMutableArray array];
    while ([set next]) {
        LocationModel *model = [[LocationModel alloc] init];
        model.time = [set stringForColumn:@"Time"];
        model.longitude = [set doubleForColumn:@"Longitude"];
        model.latitude  = [set doubleForColumn:@"Latitude"];
        [mArray addObject:model];
    }
    return [NSArray arrayWithArray:mArray];
}
+ (NSMutableArray *)selectDataFromMasterTable:(NSString *)name {
    NSString *sql = [NSString stringWithFormat:@"Select * from MOTIONTRAIL where name = '%@'",name];
    FMResultSet *set = [__db executeQuery:sql];
    NSMutableArray *mArray = [NSMutableArray array];
    while ([set next]) {
        LocationModel *model = [[LocationModel alloc] init];
        model.time = [set stringForColumn:@"Time"];
        model.name = [set stringForColumn:@"Name"];
        model.startAddress = [set stringForColumn:@"StartAddress"];
        model.endAddress  =  [set stringForColumn:@"EndAddress"];
        [mArray addObject:model];
    }
    return mArray;
}
+ (void)test {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MyDatabase.db"];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    dispatch_queue_t q1 = dispatch_queue_create("queue1", NULL);
    dispatch_async(q1, ^{
        NSLog(@"启动事务");
        NSDate *date = [NSDate date];
        
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            [db shouldCacheStatements];
            for (int i = 0; i < 5467; i++) {
                NSString *string = [NSString stringWithFormat:@"%d",i+10000];
                NSString *sql = [NSString stringWithFormat:@"INSERT INTO MOTIONTRAIL (Name,Time,StartAddress,EndAddress) VALUES ('%@','%@','%@','%@')",string,@"sss",@"qqq",@"jjj"];
                
                [db executeUpdate:sql];
            }
        }];
        
        float interval = [[NSDate date] timeIntervalSinceDate:date];
        NSLog(@"总耗时：%f", interval);
    });
    
}
@end
