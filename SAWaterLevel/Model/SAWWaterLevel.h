//
//  SAWWaterLevel.h
//  SAWaterLevel
//
//  Created by Wayne Hartman on 5/31/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SAWStageLevel;

@interface SAWWaterLevel : NSObject <NSCoding>

@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, strong) NSNumber *level;
@property (nonatomic, strong) NSNumber *average;
@property (nonatomic, strong) SAWStageLevel *stageLevel;
@property (nonatomic, assign, getter = isIrrigationAllowedThisWeek) BOOL irrigationAllowedThisWeek;

@end
