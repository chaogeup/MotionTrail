//
//  FmdbClass.h
//  MotionTrail
//
//  Created by chao on 16/4/13.
//  Copyright © 2016年 DoctorMundo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FmdbClass : NSObject

+ (FmdbClass *)shareFmdbClass;
/**
 *
 * 传入表的名字创建一张新表
 */
//建一张表
+ (void)createDataTable:(NSString *)tableName startAddress:(NSString *)str1 endAddress:(NSString *)str2;

/**
 * 传入表名 当前时间 经度 维度
 * 无返回
 */

///增加一条数据
+ (void)addData:(NSString *)name array:(NSArray *)arr;
/**
 * 从主表查询
 * 传出一个数组
 */
///查询所有记录名字
+ (NSMutableArray *)selectAllData;
/**
 * 从主表查询
 * 传出一个数组
 */
///查询某一次记录
+ (NSMutableArray *)selectDataFromMasterTable:(NSString *)name;
/**
 * 传入一次记录的名字
 * 传出一个数组
 */
///查询一次记录
+ (NSArray *)selectData:(NSString *)name;

/**
 * 传入名字 删除记录
 *
 */
///删除一次记录
+ (void)deleteData:(NSString *)name;

///测试方法，测试数据写入数据库的时间
+ (void)test;
@end
