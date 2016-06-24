//
//  UtilityClass.m
//  MotionTrail
//
//  Created by chao on 16/4/5.
//  Copyright © 2016年 DoctorMundo. All rights reserved.
//

#import "UtilityClass.h"

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@implementation UtilityClass 


+ (NSString *)timestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0.1];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localDate = [date dateByAddingTimeInterval:interval];
    return localDate.description;
}

+ (NSString *)timestamp1 {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0.1];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate:date];
//    NSDate *localDate = [date dateByAddingTimeInterval:interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *string = [dateFormatter stringFromDate:date];
    return string;
}

+ (NSTimeInterval )stringToSecondStartTime:(NSString *)time1 endTime:(NSString *)time2 {
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"YYYY-MM-dd HH:mm:ss"];
    NSDate  *date1 = [formatter dateFromString:time1];
    NSDate  *date2 = [formatter dateFromString:time2];
    
    NSTimeInterval time = [date2 timeIntervalSinceDate:date1];
    NSLog(@"time2=%@-time1=%@-time:%.f",time2,time1,time/60);
    return time;
}

+ (double)calculateDistanceLocation:(CLLocationCoordinate2D *)location1  endLocation:(CLLocationCoordinate2D *)location2 {
    
    BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(39.915,116.4044));
    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(38.915,116.4045));
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
    return distance;
}
+ (NSDate *)stringToDate:(NSString *)string {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"YYYY-MM-dd HH:mm:ss"];
    NSDate  *date1 = [formatter dateFromString:string];
    return date1;
}


@end
