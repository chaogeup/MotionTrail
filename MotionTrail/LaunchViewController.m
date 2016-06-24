//
//  LaunchViewController.m
//  MotionTrail
//
//  Created by chao on 16/4/20.
//  Copyright © 2016年 DoctorMundo. All rights reserved.
//

#import "LaunchViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface LaunchViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) CMMotionManager *manager;

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _manager = [[CMMotionManager alloc] init];
    LaunchViewController * __weak weakSelf = self;
    if (_manager.deviceMotionAvailable) {
        NSLog(@"deviceMotionAvailable");
        _manager.deviceMotionUpdateInterval = 0.01f;
        [_manager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                     withHandler:^(CMDeviceMotion *data, NSError *error) {
                                         double rotation = atan2(data.gravity.x, data.gravity.y) - M_PI;
                                         weakSelf.imageView.transform = CGAffineTransformMakeRotation(rotation);
                                     }];
    }else {
        NSLog(@"deviceMotion not Available");
    }
    
    if (_manager.accelerometerAvailable) {
        NSLog(@"accelerometerAvailable");
        _manager.accelerometerUpdateInterval = 0.01f;
        [_manager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue]
                                      withHandler:^(CMAccelerometerData *data, NSError *error) {
                                          double rotation = atan2(data.acceleration.x, data.acceleration.y) - M_PI;
                                          weakSelf.imageView.transform = CGAffineTransformMakeRotation(rotation);
                                      }];
    }else {
        NSLog(@"not accelerometerAvailable");
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
