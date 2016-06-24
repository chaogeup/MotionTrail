//
//  main.m
//  MotionTrail
//
//  Created by chao on 16/4/5.
//  Copyright © 2016年 DoctorMundo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
//全局变量
int const serviceId = 114282; //此处填写在鹰眼管理后台创建的服务的ID
NSString *const AK = @"myHQ92be4PboW7oBOxSPvraO";//此处填写您在API控制台申请得到的ak，该ak必须为iOS类型的ak
NSString *const MCODE = @"com.xiaoming.MotionTrail";//此处填写您申请iOS类型ak时填写的安全码
double const EPSILON = 0.0001;

int main(int argc, char * argv[]) {
    @autoreleasepool {
        [NBSAppAgent startWithAppID:@"0a51ee7d4fea4226861b7e85bf34718a"];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
