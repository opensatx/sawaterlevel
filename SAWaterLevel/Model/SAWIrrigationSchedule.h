/*
 *
 *  Copyright (c) 2014 Wayne Hartman
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy of
 *  this software and associated documentation files (the "Software"), to deal in the
 *  Software without restriction, including without limitation the rights to use,
 *  copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
 *  Software, and to permit persons to whom the Software is furnished to do so, subject
 *  to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all copies
 *  or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 *  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 *  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 *  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 *  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 *  THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 */

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

/*!
 *  Method for obtaining the localized string for a customer's irrigation day
 *  @param stageLevel the stage level that should be used to determine the customer's irrigation day
 *  @param streetNumber the street number of the customer
 *  @return localized day(s) of the week that a customer is allowed to irrigate
 */
+ (NSString *)localizedIrrigationDayForStageLevel:(SAWStageLevel *)stageLevel streetNumber:(NSString *)streetNumber;

@end
