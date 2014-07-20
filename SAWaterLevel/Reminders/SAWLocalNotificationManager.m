//
//  SAWLocalNotificationManager.m
//  SAWaterLevel
//
//  Created by Wayne Hartman on 7/12/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import "SAWLocalNotificationManager.h"
#import "SAWIrrigationSchedule.h"

@interface SAWLocalNotificationManager()

@property (nonatomic, strong) SAWLocalNotificationManager *strongSelf;
@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskID;

@end

@implementation SAWLocalNotificationManager

+ (instancetype)localNotificationManager {
    return [[SAWLocalNotificationManager alloc] init];
}

- (void)removeAllNotifications {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)scheduleNotificationsForStageLevel:(SAWStageLevel *)stageLevel streetNumber:(NSString *)streetNumber completion:(SAWLocalNotificationScheduleCompletionHandler)completionHandler {
    //  Sanity Check
    if (stageLevel == nil || streetNumber == nil || streetNumber.length == 0) {
        return;
    }

    self.strongSelf = self;

    __weak typeof(self) weakSelf = self;
    self.backgroundTaskID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        if (weakSelf.backgroundTaskID != UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:weakSelf.backgroundTaskID];
        }
    }];

    dispatch_async(dispatch_queue_create("com.opensatx.sawaterlevel", 0), ^{
        static NSInteger maxiumumNumberOfNotifications = 64;

        [[UIApplication sharedApplication] cancelAllLocalNotifications];

        SAWIrrigationSchedule *irrigationSchedule = [SAWIrrigationSchedule irrigationScheduleForStageLevel:stageLevel streetNumber:streetNumber];

        for (NSValue *value in irrigationSchedule.timeOfDayRanges) {
            UILocalNotification *notification = [weakSelf createNotificationForSchedule:irrigationSchedule timeRange:value.rangeValue];
            notification.fireDate = [self determineNextFireDateForSchedule:irrigationSchedule timeRange:value.rangeValue];
            
            switch (irrigationSchedule.frequency) {
                case SAWIrrigationScheduleFrequencyDaily: {
                    notification.repeatInterval = NSCalendarUnitDay;
                }
                    break;
                case SAWIrrigationScheduleFrequencyWeekly: {
                    notification.repeatInterval = NSCalendarUnitWeekOfYear;
                }
                    break;
                /*
                 *  Apple's APIs for repeating notifications are pretty limiting.  So in cases of bi-weekly notifications
                 *  we have to manually schedule those ourselves.  An app can schedule up to 64 notifications, so we're going to
                 *  take that and divide it by the number of ranges that need to be scheduled, then repeat the notification that
                 *  many times.  Therefore, if there are two ranges, we will schedule "23 bi-weeks" (nearly, a year) of
                 *  notifications into the future.
                 *  
                 *  Thanks, Apple.
                 */
                case SAWIrrigationScheduleFrequencyBiweekly: {
                    NSInteger numberOfNotificationsToRepeat = maxiumumNumberOfNotifications / irrigationSchedule.timeOfDayRanges.count;
                    for (int i = 0; i < numberOfNotificationsToRepeat; i++) {
#warning TODO: schedule the additional notifications
                    }
                }
                    break;
            }

            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }

        NSLog(@"Finished scheduling notifications");
        
        if (completionHandler) {
            NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
            notifications = [notifications sortedArrayUsingComparator:^NSComparisonResult(UILocalNotification *obj1, UILocalNotification *obj2) {
                return [obj1.fireDate compare:obj2.fireDate];
            }];

            completionHandler(notifications);
        }

        [[UIApplication sharedApplication] endBackgroundTask:weakSelf.backgroundTaskID];
        weakSelf.backgroundTaskID = UIBackgroundTaskInvalid;
        weakSelf.strongSelf = nil;
    });
}

- (UILocalNotification *)nextNotification {
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    notifications = [notifications sortedArrayUsingComparator:^NSComparisonResult(UILocalNotification *obj1, UILocalNotification *obj2) {
        return [obj1.fireDate compare:obj2.fireDate];
    }];

    return [notifications firstObject];
}

- (NSDate *)determineNextFireDateForSchedule:(SAWIrrigationSchedule *)schedule timeRange:(NSRange)range {
    BOOL shouldStartToday = NO;

    if (schedule.frequency == SAWIrrigationScheduleFrequencyDaily) {
        shouldStartToday = YES;
    }

    NSDate* curDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *curComps = [calendar components:NSWeekdayCalendarUnit fromDate:curDate];
    NSCalendarUnit units = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitWeekday | NSCalendarUnitWeekOfYear;

    NSDateComponents *rangeComps = [calendar components:units fromDate:curDate];
    rangeComps.hour = range.location;
    rangeComps.minute = 0;

    NSDate *rangeDate = [calendar dateFromComponents:rangeComps];

    if (schedule.frequency == SAWIrrigationScheduleFrequencyDaily) {
        if ([rangeDate compare:curDate] == NSOrderedDescending) { // We can still schedule this notification
            //  DO NOTHING
        } else { // It is passed.  Go to the next day
            rangeComps.day += 1;
            rangeDate = [calendar dateFromComponents:rangeComps];
        }

        return rangeDate;
    } else if (schedule.frequency == SAWIrrigationScheduleFrequencyWeekly) {
        SAWIrrigationDay currentDayOfTheWeek = [self irrigationDayFromDate:[NSDate date]];

        if (currentDayOfTheWeek <= [schedule irrigationDays]) {  //  Their day hasn't passed yet
            rangeComps.day += [self weekdayFromIrrigationDay:schedule.irrigationDays] - curComps.weekday;
        } else {    //  It is past their day for this week
            NSInteger weekDayToSet = [self weekdayFromIrrigationDay:schedule.irrigationDays];
            rangeComps.day += weekDayToSet;
        }

        NSDate *rangeDate = [calendar dateFromComponents:rangeComps];

        return rangeDate;
    }

    return nil;
}

- (SAWIrrigationDay)irrigationDayFromDate:(NSDate *)date {
    NSCalendarUnit weekDay = NSCalendarUnitWeekday;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComps = [calendar components:weekDay fromDate:date];

    NSInteger dayComp = [dayComps weekday];

    switch (dayComp) {
        case 1:
            return SAWIrrigationDaySunday;
        case 2:
            return SAWIrrigationDayMonday;
        case 3:
            return SAWIrrigationDayTuesday;
        case 4:
            return SAWIrrigationDayWednesday;
        case 5:
            return SAWIrrigationDayThursday;
        case 6:
            return SAWIrrigationDayFriday;
        case 7:
            return SAWIrrigationDaySaturday;
        default:
            return SAWIrrigationDayWednesday;
    }
}

- (NSInteger)weekdayFromIrrigationDay:(SAWIrrigationDay)irrigationDay {
    switch (irrigationDay) {
        case SAWIrrigationDaySunday:
            return 1;
        case SAWIrrigationDayMonday:
            return 2;
        case SAWIrrigationDayTuesday:
            return 3;
        case SAWIrrigationDayWednesday:
            return 4;
        case SAWIrrigationDayThursday:
            return 5;
        case SAWIrrigationDayFriday:
            return 6;
        case SAWIrrigationDaySaturday:
            return 7;
    }
}

- (UILocalNotification *)createNotificationForSchedule:(SAWIrrigationSchedule *)schedule timeRange:(NSRange)range {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.hasAction = NO;

    return notification;
}

- (void)dealloc {
    NSLog(@"Notification Manager Destroyed");
}

@end
