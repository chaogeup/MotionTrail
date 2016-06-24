//
//  TestViewController.m
//  MotionTrail
//
//  Created by chao on 16/4/19.
//  Copyright © 2016年 DoctorMundo. All rights reserved.
//

#import "TestViewController.h"
#import<CoreMotion/CoreMotion.h>

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CMMotionManager *motionManager; //定义一个陀螺仪管理器
    motionManager= [[CMMotionManager alloc]init];//初始化
    motionManager.deviceMotionUpdateInterval=1.0/60.0;//设置更新间隔每秒60次；
    if (motionManager.isDeviceMotionAvailable) {
        [motionManager startDeviceMotionUpdates];
    }//开启陀螺仪
    CMDeviceMotion *currentDeviceMotion = motionManager.deviceMotion;
    CMAttitude *currentAttitude = currentDeviceMotion.attitude;
    //检测陀螺仪状态，既偏航
    //float yaw = roundf((float)(CC_RADIANS_TO_DEGREES(currentAttitude.yaw))); //角度转换
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
