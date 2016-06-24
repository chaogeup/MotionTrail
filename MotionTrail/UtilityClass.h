//
//  UtilityClass.h
//  MotionTrail
//
//  Created by chao on 16/4/5.
//  Copyright © 2016年 DoctorMundo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface UtilityClass : NSObject
/**
 *返回当前日期 时间的字符串
 *
*/
+ (NSString *)timestamp;
+ (NSString *)timestamp1;

/**
 * 传入记录的开始时间和结束时间
 * 返回 时间   单位（分钟）
 */
///字符串转化为时间
+ (NSTimeInterval )stringToSecondStartTime:(NSString *)time1 endTime:(NSString *)time2;

/**
 *  根据坐标计算 两点的距离
 * 返回距离  单位（米）
 */
+ (double)calculateDistanceLocation:(CLLocationCoordinate2D *)location1  endLocation:(CLLocationCoordinate2D *)location2;

/*
 *
 *
 */
+ (NSDate *)stringToDate:(NSString *)string;
@end
