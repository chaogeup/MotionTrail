
//  Contant.h
//  MotionTrail
//
//  Created by chao on 16/4/13.
//  Copyright © 2016年 DoctorMundo. All rights reserved.
//
#ifndef Contant_h
#define Contant_h


#endif /* Contant_h */

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)


