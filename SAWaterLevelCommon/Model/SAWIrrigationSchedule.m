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

#import "SAWIrrigationSchedule.h"

@interface SAWIrrigationSchedule ()

@property (nonatomic, strong, readwrite) NSArray *timeOfDayRanges;
@property (nonatomic, assign, readwrite) SAWIrrigationScheduleFrequency frequency;
@property (nonatomic, assign, readwrite) SAWIrrigationDay irrigationDays;

@end

@implementation SAWIrrigationSchedule

#pragma mark - Instance Creation

+ (instancetype)irrigationScheduleForStageLevel:(SAWStageLevel *)stageLevel streetNumber:(NSString *)streetNumber {
    if (stageLevel == nil || streetNumber == nil || streetNumber.length == 0) {
        return nil;
    }

    NSArray *ranges = [SAWIrrigationSchedule timeRangesForStageLevel:stageLevel.level streetNumber:streetNumber];
    SAWIrrigationScheduleFrequency frequency = [SAWIrrigationSchedule irrigationFrequencyForStageLevel:stageLevel.level];

    SAWIrrigationSchedule *schedule = [[SAWIrrigationSchedule alloc] init];
    schedule.timeOfDayRanges = ranges;
    schedule.frequency = frequency;
    schedule.irrigationDays = [SAWIrrigationSchedule irrigationDayForStreetNumber:streetNumber];

    return schedule;
}

+ (NSArray *)timeRangesForStageLevel:(SAWStageLevelType)level streetNumber:(NSString *)streetNumber {
    NSMutableArray *ranges = [[NSMutableArray alloc] init];

    NSRange midnightToSeven = NSMakeRange(0, 7);
    NSRange nineteenToMidnight = NSMakeRange(19, 5);
    NSRange seventToEleven = NSMakeRange(7, 4);
    NSRange nineteenToTwentyThree = NSMakeRange(19, 4);

    switch (level) {
        case SAWStageLevelNormal: {
            [ranges addObject:[NSValue valueWithRange:midnightToSeven]];
            [ranges addObject:[NSValue valueWithRange:nineteenToMidnight]];
        }
            break;
        case SAWStageLevel1: {
            [ranges addObject:[NSValue valueWithRange:midnightToSeven]];
            [ranges addObject:[NSValue valueWithRange:nineteenToMidnight]];
        }
            break;
        case SAWStageLevel2: {
            [ranges addObject:[NSValue valueWithRange:seventToEleven]];
            [ranges addObject:[NSValue valueWithRange:nineteenToTwentyThree]];
        }
            break;
        case SAWStageLevel3:
        case SAWStageLevel4:
        case SAWStageLevel5: {
            [ranges addObject:[NSValue valueWithRange:seventToEleven]];
            [ranges addObject:[NSValue valueWithRange:nineteenToTwentyThree]];
        }
            break;
    }

    return ranges;
}

+ (SAWIrrigationScheduleFrequency)irrigationFrequencyForStageLevel:(SAWStageLevelType)level {
    switch (level) {
        case SAWStageLevelNormal:
            return SAWIrrigationScheduleFrequencyDaily;
        case SAWStageLevel1:
        case SAWStageLevel2:
            return SAWIrrigationScheduleFrequencyWeekly;
        case SAWStageLevel3:
        case SAWStageLevel4:
        case SAWStageLevel5:
            return SAWIrrigationScheduleFrequencyBiweekly;
    }
}

+ (SAWIrrigationDay)irrigationDaysForStageLevel:(SAWStageLevelType)level streetNumber:(NSString *)streetNumber {
    SAWIrrigationDay day;

    switch (level) {
        case SAWStageLevelNormal: {
            day = SAWIrrigationDayFriday | SAWIrrigationDayMonday | SAWIrrigationDaySaturday | SAWIrrigationDaySunday | SAWIrrigationDayThursday | SAWIrrigationDayTuesday | SAWIrrigationDayWednesday;
        }
            break;
        case SAWStageLevel1:
        case SAWStageLevel2:
        case SAWStageLevel3:
        case SAWStageLevel4:
        case SAWStageLevel5: {
            day = [SAWIrrigationSchedule irrigationDayForStreetNumber:streetNumber];
        }
            break;
    }

    return day;
}

+ (SAWIrrigationDay)irrigationDayForStreetNumber:(NSString *)streetNumber {
    char lastNumber = [streetNumber characterAtIndex:streetNumber.length - 1];

    switch (lastNumber) {
        case '0':
        case '1':
            return SAWIrrigationDayMonday;
        case '2':
        case '3':
            return SAWIrrigationDayTuesday;
        case '4':
        case '5':
            return SAWIrrigationDayWednesday;
        case '6':
        case '7':
            return SAWIrrigationDayThursday;
        case '8':
        case '9':
            return SAWIrrigationDayFriday;
        default:
            return SAWIrrigationDayWednesday;
    }
}

+ (NSString *)localizedIrrigationDayForStageLevel:(SAWStageLevel *)stageLevel streetNumber:(NSString *)streetNumber {
    switch (stageLevel.level) {
        case SAWStageLevel1:
        case SAWStageLevel2:
        case SAWStageLevel3:
        case SAWStageLevel4:
        case SAWStageLevel5: {
            SAWIrrigationDay day = [SAWIrrigationSchedule irrigationDayForStreetNumber:streetNumber];
            switch (day) {
                case SAWIrrigationDaySunday:
                    return NSLocalizedString(@"IRRIGATION_DAY_SUN", nil);
                    break;
                case SAWIrrigationDayMonday:
                    return NSLocalizedString(@"IRRIGATION_DAY_MON", nil);
                    break;
                case SAWIrrigationDayTuesday:
                    return NSLocalizedString(@"IRRIGATION_DAY_TUE", nil);
                    break;
                case SAWIrrigationDayWednesday:
                    return NSLocalizedString(@"IRRIGATION_DAY_WED", nil);
                    break;
                case SAWIrrigationDayThursday:
                    return NSLocalizedString(@"IRRIGATION_DAY_THU", nil);
                    break;
                case SAWIrrigationDayFriday:
                    return NSLocalizedString(@"IRRIGATION_DAY_FRI", nil);
                    break;
                case SAWIrrigationDaySaturday:
                    return NSLocalizedString(@"IRRIGATION_DAY_SAT", nil);
                    break;
            }
        }
            break;
        case SAWStageLevelNormal:
            return NSLocalizedString(@"IRRIGATION_DAY_DAILY", nil);
    }
}

#pragma mark - Debug

- (NSString *)debugDescription {
    NSDictionary *values = @{
                             @"timeOfDayRanges" : self.timeOfDayRanges ?: [NSNull null],
                             @"irrigationDays" : @(self.irrigationDays),
                             @"frequency" : @(self.frequency)
                             };
    NSString *description = [NSString stringWithFormat:@"%@ %@", [super debugDescription], [values debugDescription]];

    return description;
}

@end
