//
//  SAWIrrigationSchedule.h
//  SAWaterLevel
//
//  Created by Wayne Hartman on 7/12/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAWStageLevel.h"

typedef NS_ENUM(NSInteger, SAWIrrigationScheduleFrequency) {
    SAWIrrigationScheduleFrequencyDaily = 0,
    SAWIrrigationScheduleFrequencyWeekly,
    SAWIrrigationScheduleFrequencyBiweekly
};

typedef NS_OPTIONS(NSInteger, SAWIrrigationDay) {
    SAWIrrigationDaySunday      = 1 << 1,
    SAWIrrigationDayMonday      = 1 << 2,
    SAWIrrigationDayTuesday     = 1 << 3,
    SAWIrrigationDayWednesday   = 1 << 4,
    SAWIrrigationDayThursday    = 1 << 5,
    SAWIrrigationDayFriday      = 1 << 6,
    SAWIrrigationDaySaturday    = 1 << 7
};

@interface SAWIrrigationSchedule : NSObject

@property (nonatomic, strong, readonly) NSArray *timeOfDayRanges;
@property (nonatomic, assign, readonly) SAWIrrigationDay irrigationDays;
@property (nonatomic, assign, readonly) SAWIrrigationScheduleFrequency frequency;

+ (instancetype)irrigationScheduleForStageLevel:(SAWStageLevel *)stageLevel streetNumber:(NSString *)streetNumber;
+ (instancetype)irrigationScheduleForWaterLevel:(SAWWaterLevel *)waterLevel streetNumber:(NSString *)streetNumber;

@end
