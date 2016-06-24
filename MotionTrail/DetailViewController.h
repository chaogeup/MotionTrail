//
//  DetailViewController.h
//  MotionTrail
//
//  Created by chao on 16/4/18.
//  Copyright © 2016年 DoctorMundo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>


@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *startNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *endNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;


@property (strong, nonatomic) NSString *titleName;
@property (strong,nonatomic) NSArray *recordArray;
@end
