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

/*!
 *  Object representing an irrigation schedule
 */
@interface SAWIrrigationSchedule : NSObject

/*!
 *  Array of NSRange structs indicating when irrigation can occur
 */
@property (nonatomic, strong, readonly) NSArray *timeOfDayRanges;

/*!
 *  Bit mask of days of the week when irrigation can occur
 */
@property (nonatomic, assign, readonly) SAWIrrigationDay irrigationDays;

/*!
 *  The frequency of the irrigation schedule
 */
@property (nonatomic, assign, readonly) SAWIrrigationScheduleFrequency frequency;

/*!
 *  Convenience method for creating an irrigation schedule based on the restriction stage level and street number
 *  @param stageLevel of the current conditions
 *  @param streetNumber the house street number of the customer.  This is used to determine the irrigation day of a customer when in stage levels 2 through 4.
 *  @return fully initialized irrigation schedule that can be used to create local notifications
 */
+ (instancetype)irrigationScheduleForStageLevel:(SAWStageLevel *)stageLevel streetNumber:(NSString *)streetNumber;

@end
