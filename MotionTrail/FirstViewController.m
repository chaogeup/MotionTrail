//
//  FirstViewController.m
//  MotionTrail
//
//  Created by chao on 16/4/5.
//  Copyright © 2016年 DoctorMundo. All rights reserved.
//

#import "FirstViewController.h"
#import <BaiduTraceSDK/BaiduTraceSDK-Swift.h>

#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

#import "UtilityClass.h"
#import "LocationModel.h"
#import "FmdbClass.h"
#import "Contant.h"

#import "LaunchViewController.h"

#define SCREENWIDTH self.view.bounds.size.width
#define SCREENHEIGHT self.view.bounds.size.height

@interface FirstViewController ()<BMKLocationServiceDelegate,BMKMapViewDelegate,BMKGeoCodeSearchDelegate>
{
    BMKLocationService  *_locService;
    BMKMapView          *_mapView;
    BMKUserLocation     *_userLocation;
    //BMKPolygon          *_polygon;
    BMKPolyline         *_poline;
    double              _currentLon;//经度
    double              _currentLat;//纬度
    //CLLocation          *_preLocation;
    NSMutableArray      *_recordArray;
    NSMutableArray      *_saveRecordArray;
    NSTimer             *_timer;
    NSInteger            _timeCount;
    NSString            *_textFieldName;
    NSString            *_startAddress; //记录的起点
    NSString            *_endAddress;   //记录的终点
    BOOL                startAddressFlag; //标记是否是起点
    
    UIButton            *_startButton;

}

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 44, SCREENWIDTH, SCREENHEIGHT-47-44)];
    //[mapView setMapType:BMKMapTypeSatellite];
    //_mapView.showMapScaleBar = YES;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.delegate = self;
    [_mapView setZoomLevel:18];
    
    [self.view addSubview:_mapView];
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //_locService.allowsBackgroundLocationUpdates = YES;
    //启动LocationService
    [_locService startUserLocationService];
    [self createPathButton];
    
    
    _timeCount = 0;
    [self initConfig];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _mapView.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _mapView.delegate = nil;
    
}
- (void)initConfig {
    _recordArray = [[NSMutableArray alloc] init];
    _saveRecordArray = [[NSMutableArray alloc] init];
}

- (void)createPathButton {
    
    _startButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _startButton.frame = CGRectMake(SCREENWIDTH/2-20, SCREENHEIGHT-47-110, 40, 40);
    //[startButton setBackgroundColor:[UIColor whiteColor]];
    [_startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[startButton setTitle:@"开始" forState:UIControlStateNormal];
    [_startButton setBackgroundImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
    [_startButton addTarget:self action:@selector(startRecordPath) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:_startButton];
    UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeSystem];
    stopButton.frame = CGRectMake(_startButton.frame.origin.x+100, SCREENHEIGHT-47-110, 40, 40);
    //[stopButton setTitle:@"结束" forState:UIControlStateNormal];
    //[stopButton setBackgroundColor:[UIColor whiteColor]];
    [stopButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [stopButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [stopButton addTarget:self action:@selector(stopRecordPath) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:stopButton];
    
    UIButton *clearbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    clearbutton.frame = CGRectMake(250, SCREENHEIGHT-47-40-44, 50, 50);
    [clearbutton setTitle:@"清除" forState:UIControlStateNormal];
    [clearbutton setBackgroundColor:[UIColor cyanColor]];
    [clearbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [clearbutton addTarget:self action:@selector(clearReacrdPath) forControlEvents:UIControlEventTouchUpInside];
    //[_mapView addSubview:clearbutton];
    
    UIButton *LocationButton = [UIButton buttonWithType:UIButtonTypeSystem];
    LocationButton.frame = CGRectMake(10, SCREENHEIGHT-47-110, 40, 40);
    //[LocationButton setTitle:@"定位" forState:UIControlStateNormal];
    [LocationButton setBackgroundColor:[UIColor whiteColor]];
    [LocationButton setBackgroundImage:[UIImage imageNamed:@"define_location"] forState:UIControlStateNormal];
    [LocationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [LocationButton addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
    LocationButton.layer.cornerRadius = 5;
    LocationButton.clipsToBounds = YES;
    [_mapView addSubview:LocationButton];
    
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeSystem];
    testButton.frame = CGRectMake(SCREENWIDTH-50, SCREENHEIGHT-47-40-44-50-100, 40, 40);
    [testButton setTitle:@"test" forState:UIControlStateNormal];
    [testButton setBackgroundColor:[UIColor cyanColor]];
    [testButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(testButton) forControlEvents:UIControlEventTouchUpInside];
    //[_mapView addSubview:testButton];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 20, SCREENWIDTH-16, 24)];
    titleLabel.text = @"生命在于运动。 ——伏尔泰";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    //titleLabel.textColor = [UIColor blueColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:titleLabel];

}
//测试的方法  不用的时候注释掉
- (void)testButton {
//    NSArray *arr = [FmdbClass selectAllData];
//    NSLog(@"AllArray=%lu",arr.count);
//    
//    for (LocationModel *model  in arr) {
//        NSArray *arr = [FmdbClass selectData:model.name];
//        LocationModel *model = arr[0];
//        //NSLog(@"%f--%f",model.longitude,model.latitude);
//        
//        
//        NSLog(@"name=%f--time= %@",model.latitude,model.time);
//        NSLog(@"arr.count===%lu",arr.count);
//    }
//    NSArray *arr = [FmdbClass selectData:@"超"];
//    NSLog(@"--%lu",arr.count);
//    
//    NSLog(@"time = %@",[UtilityClass timestamp1]);
//    //[UtilityClass stringToSecond:@"2016-04-15 14:09:12" time:@"2016-04-15 14:10:12"];
//    [UtilityClass stringToSecondStartTime:@"2016-04-15 14:09:12" endTime:@"2016-04-15 14:10:12"];
//   double distance = [UtilityClass calculateDistanceLocation:nil endLocation:nil];
//    NSLog(@"diatance=%f",distance);
    
//    LaunchViewController *launch = [[LaunchViewController alloc] init];
//    launch.view.frame = CGRectMake(100, 200, 200, 200);
//    
//        [self.view addSubview:launch.view];
//        [self addChildViewController:launch];

    
    [FmdbClass test];
    

}

- (void)getGeoCodeLatitude:(double)latitude longtitude:(double)longitude {
    
    BMKReverseGeoCodeOption *reverseGeo = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeo.reverseGeoPoint = CLLocationCoordinate2DMake(latitude,longitude);
    BMKGeoCodeSearch *search =[[BMKGeoCodeSearch alloc] init];
    search.delegate = self;
    BOOL result = [search reverseGeoCode:reverseGeo];
    NSLog(@"result=%d",result);
}
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    
    BMKAddressComponent *detailComponent = result.addressDetail;
    NSLog(@"re---%@--%@--%@--%@--%@--%@",result.address,detailComponent.city,detailComponent.streetName,detailComponent.district,detailComponent.streetNumber,detailComponent.province);

    if (startAddressFlag) {
        _startAddress = result.address;
    }else {
        _endAddress = result.address;
    }
}
- (void)locationAction {
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(_currentLat,_currentLon);
    _mapView.centerCoordinate = coor;
}
- (void)clearReacrdPath {
    DLog(@"clear");
}
- (void)startRecordPath {
    DLog(@"start");
    if (!_timer) {
           _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(startRecord) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        startAddressFlag = YES;
        [self getGeoCodeLatitude:_currentLat longtitude:_currentLon];
        
        [_startButton setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
         _locService.allowsBackgroundLocationUpdates = YES;
    }
    
}
- (void)startRecord {
    
    //计时开始
    _timeCount += 1;
    
    LocationModel *model = [[LocationModel alloc] init];
    model.time = [UtilityClass timestamp1];
    model.longitude = _currentLon;
    model.latitude  = _currentLat;
    
    if (_recordArray.count > 0) {
        LocationModel *model1 = [_recordArray lastObject];
        if (model1.longitude == _currentLon && model1.latitude == _currentLat) {
            return;
        }
    }
    
    [_recordArray addObject:model];
    DLog(@"+++++%lu",(unsigned long)_recordArray.count);
  
    [self updateCurrentRecordPath];
}
- (void)updateCurrentRecordPath {

    CLLocationCoordinate2D *locations = malloc([_recordArray count] * sizeof(CLLocationCoordinate2D));
//    int n =100;
//    CLLocationCoordinate2D *p = new CLLocationCoordinate2D [n];
    //CLLocationCoordinate2D coords[100] = {0};
    for (int i = 0; i<_recordArray.count; i++) {
        locations[i].latitude = [[_recordArray objectAtIndex:i] latitude];
        locations[i].longitude = [[_recordArray objectAtIndex:i] longitude];
        //DLog(@"---%f----%f",locations[i].longitude,locations[i].latitude);
    }
    
    
    if (_poline) {
        [_mapView removeOverlay:_poline];
    }
         _poline = [BMKPolyline polylineWithCoordinates:locations count:_recordArray.count];
    
    [_mapView addOverlay:_poline];
    //[_recordArray removeAllObjects];
    
    
    
    
    
}

- (void)stopRecordPath {
    DLog(@"stop  %ld",(long)_timeCount);
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
        startAddressFlag = NO;
        [self getGeoCodeLatitude:_currentLat longtitude:_currentLon];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入本次记录的名字" delegate:self cancelButtonTitle:@"不保存" otherButtonTitles:@"保存", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
        [_startButton setBackgroundImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
    }
    
   
    
    
}

//实现相关delegate 处理位置信息更新

#pragma mark -
#pragma mark implement BMKMapViewDelegate

//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        if (overlay == _poline) {
            polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:1];
            polylineView.lineWidth = 5.0;

        return polylineView;
        }
    }
    return nil;
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //DLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //DLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    [_mapView updateLocationData:userLocation];
    _currentLat = userLocation.location.coordinate.latitude;
    _currentLon = userLocation.location.coordinate.longitude;
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0) {
    UITextField *textField = [alertView textFieldAtIndex:0];
    //NSLog(@"--startaddress = %@-%@",_startAddress,_endAddress);
    if(buttonIndex == 1) {
       
        if(textField.text.length > 0) {
            DLog(@"保存数据 name=%@",textField.text);
            if(_timeCount <= 60) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"时间少于1分钟，不予保存" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                _startAddress = @"";
                _timeCount = 0;
                [_recordArray removeAllObjects];
                [_mapView removeOverlay:_poline];
                
                return;
            }
            [FmdbClass createDataTable:textField.text startAddress:_startAddress endAddress:_endAddress];
            _textFieldName = textField.text;
            NSArray *array = [NSArray arrayWithArray:_recordArray];
           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
               [FmdbClass addData:_textFieldName array:array];
               _startAddress = @"";
               _endAddress = @"";
                _locService.allowsBackgroundLocationUpdates = NO;
           });
            
            _timeCount = 0;
            [_recordArray removeAllObjects];
            [_mapView removeOverlay:_poline];
        }

    }else if(buttonIndex == 0){
        _timeCount = 0;
        [_recordArray removeAllObjects];
        [_mapView removeOverlay:_poline];
        _locService.allowsBackgroundLocationUpdates = NO;
    }
    
}
@end
