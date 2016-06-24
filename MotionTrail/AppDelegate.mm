//
//  AppDelegate.m
//  MotionTrail
//
//  Created by chao on 16/4/5.
//  Copyright © 2016年 DoctorMundo. All rights reserved.
//

#import "AppDelegate.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "FmdbClass.h"
#import "SystemInfoClass.h"


BMKMapManager *_mapManager;
@interface AppDelegate () <BMKGeneralDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"myHQ92be4PboW7oBOxSPvraO" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    //加载数据库
    [FmdbClass shareFmdbClass];
    [NSThread sleepForTimeInterval:2.0];
    
    [self getSystemDeviceInfo];
    
    

    
    return YES;
}
- (void)getSystemDeviceInfo {
    UIDevice *device = [UIDevice currentDevice];
    NSLog(@"name=%@-model=%@-systemName=%@-systemVersion=%@-localizedModel=%@-uuid=%@",device.name,device.model,device.systemName,device.systemVersion,device.localizedModel,device.identifierForVendor.UUIDString);
    
    NSString *appversion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    NSLog(@"appVersion=%@",appversion);
    
    UIApplication *app = [UIApplication sharedApplication];
    
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    
    int type = 0;
    for (id child in children)
    {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }
    NSLog(@"models=%@,type----%d",[SystemInfoClass deviceModels], type);//1-2G,2-3G,3-4G,5-wifi
    SystemInfoClass *system = [[SystemInfoClass alloc] init];
    [system network];
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}
@end
