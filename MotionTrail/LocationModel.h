//
//  LocationModel.h
//  MotionTrail
//
//  Created by chao on 16/4/5.
//  Copyright © 2016年 DoctorMundo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationModel : NSObject

@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *time;
@property (nonatomic,strong)NSString *startAddress;
@property (nonatomic,strong)NSString *endAddress;

@property (nonatomic,assign)double  longitude;//经度
@property (nonatomic,assign)double  latitude;//纬度

@end
