//
//  DetailViewController.m
//  MotionTrail
//
//  Created by chao on 16/4/18.
//  Copyright © 2016年 DoctorMundo. All rights reserved.
//

#import "DetailViewController.h"
#import "LocationModel.h"
#import "FmdbClass.h"
#import <CoreMotion/CoreMotion.h>
#import "UtilityClass.h"


#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))

@interface DetailViewController ()<BMKMapViewDelegate>
{
    BMKPolyline         *_poline;
    
    CMMotionManager     *_manager;
}
@property (strong, nonatomic)CMPedometer *pedonmeter;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _recordArray = [[NSArray alloc] init];
    
    self.title = self.titleName;
    
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.delegate = self;
    [_mapView setZoomLevel:18];
    
    
    [self updateCurrentLocation];
    [self updateCurrentRecordPath];
    
    [self getClunkController];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _mapView.delegate = nil;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _mapView.delegate = self;
    self.tabBarController.tabBar.hidden = YES;
}


- (void)countUserStepBytime:(NSDate *)startDate endDate:(NSDate *)endDate {
    _pedonmeter = [[CMPedometer alloc] init];
    if ([CMPedometer isStepCountingAvailable]) {
        [_pedonmeter queryPedometerDataFromDate:startDate toDate:endDate withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
            if (error)
            {
                NSLog(@"error===%@",error);
            }
            else {
                NSLog(@"步数===%@",pedometerData.numberOfSteps);
                NSLog(@"距离===%@",pedometerData.distance);
                
                if (pedometerData.numberOfSteps != nil) {
                    _stepLabel.text = [NSString stringWithFormat:@"%@ 步",pedometerData.numberOfSteps];
                    float dis = [pedometerData.distance floatValue];
                    _distanceLabel.text = [NSString stringWithFormat:@"%.f 米",dis];
                }
            }
        }];
    }else{
        NSLog(@"不可用===");
    }
    
    
}
- (void)getClunkController {
    
    _manager = [[CMMotionManager alloc] init];
    DetailViewController * __weak weakSelf = self;
    if (_manager.deviceMotionAvailable) {
        _manager.deviceMotionUpdateInterval = 0.01f;
        [_manager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            //NSLog(@"--%f",motion.userAcceleration.x);
            if (motion.userAcceleration.x < -1.5f) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                //[weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}

- (void)updateCurrentLocation {
    _recordArray = [FmdbClass selectData:self.titleName];
    LocationModel *model = [[LocationModel alloc] init];
    LocationModel *model1 = [[LocationModel alloc] init];
    model = [_recordArray lastObject];
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(model.latitude, model.longitude)];
    model1 = [_recordArray firstObject];
    
    _startTimeLabel.text = model1.time;
    _endTimeLabel.text   = model.time;
    
    NSMutableArray *arr = [FmdbClass selectDataFromMasterTable:self.titleName];
    LocationModel *models = [[LocationModel alloc] init];
    models = [arr firstObject];

    _startNameLabel.text = models.startAddress;
    _endNameLabel.text = models.endAddress;
    //NSLog(@"---%@--%lu",models.startAddress,_startNameLabel.text.length);
    
    if (_startNameLabel.text.length == 6) {
        _startNameLabel.text = @"没有起点名字哦";
    }else {
        
    }
    if (_endNameLabel.text.length == 6) {
        _endNameLabel.text = @"没有终点名字哟";
    }
    
    [self countUserStepBytime:[UtilityClass stringToDate:model1.time] endDate:[UtilityClass stringToDate:model.time]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateCurrentRecordPath {
    
    CLLocationCoordinate2D *locations = malloc([_recordArray count] * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i<_recordArray.count; i++) {
        locations[i].latitude = [[_recordArray objectAtIndex:i] latitude];
        locations[i].longitude = [[_recordArray objectAtIndex:i] longitude];
        
    }
    
    
    if (_poline) {
        [_mapView removeOverlay:_poline];
    }
    _poline = [BMKPolyline polylineWithCoordinates:locations count:_recordArray.count];
    
    [_mapView addOverlay:_poline];
    
    
}
//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        if (overlay == _poline) {
            polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:1];
            polylineView.lineWidth = 2.0;
            
            return polylineView;
        }
    }
    return nil;
}
@end
