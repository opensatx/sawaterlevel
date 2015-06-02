//
//  SAWLocalNotificationManagerTest.m
//  SAWaterLevel
//
//  Created by Wayne Hartman on 7/12/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

@import XCTest;
@import SAWaterLevelCommon;

#import "SAWLocalNotificationManager.h"
#import "SAWWaterLevel.h"

@interface SAWLocalNotificationManager (PRIVATE)

- (NSDate *)determineNextFireDateForSchedule:(SAWIrrigationSchedule *)schedule timeRange:(NSRange)range;

@end

@interface SAWLocalNotificationManagerTest : XCTestCase

@end

@implementation SAWLocalNotificationManagerTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testDetermineNextFireDateForSchedule_timeRange__dailyHappyPath {
    SAWWaterLevel *waterLevel = [[SAWWaterLevel alloc] init];
    waterLevel.level = @([SAWStageLevel footStartingLevelForStageLevel:SAWStageLevelNormal]);
    waterLevel.average = waterLevel.level;
    waterLevel.stageLevel = [SAWStageLevel stageLevelForWaterLevel:waterLevel];

    SAWStageLevel *stageLevel = waterLevel.stageLevel;
    SAWIrrigationSchedule *schedule = [SAWIrrigationSchedule irrigationScheduleForStageLevel:stageLevel streetNumber:@"13307"];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    NSCalendarUnit units = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *currentComps = [calendar components:units fromDate:currentDate];
    
    SAWLocalNotificationManager *notificationManager = [[SAWLocalNotificationManager alloc] init];
    NSInteger hoursToAdd = 1;
    NSDate *fireDate = [notificationManager determineNextFireDateForSchedule:schedule timeRange:NSMakeRange(currentComps.hour + hoursToAdd, 4)];

    NSDateComponents *fireComps = [calendar components:units fromDate:fireDate];
    NSDateComponents *expectedComps = [currentComps copy];
    expectedComps.hour += hoursToAdd;
    
    NSDate *expectedDate = [calendar dateFromComponents:expectedComps];
    expectedComps = [calendar components:units fromDate:expectedDate];

    XCTAssertEqual(fireComps.day, expectedComps.day);
    XCTAssertEqual(fireComps.month, expectedComps.month);
    XCTAssertEqual(fireComps.year, expectedComps.year);
    XCTAssertEqual(fireComps.hour, expectedComps.hour);
}

- (void)testDetermineNextFireDateForSchedule_timeRange__weeklyHappyPath {
    SAWWaterLevel *waterLevel = [[SAWWaterLevel alloc] init];
    waterLevel.level = @([SAWStageLevel footStartingLevelForStageLevel:SAWStageLevel1]);
    waterLevel.average = waterLevel.level;
    waterLevel.stageLevel = [SAWStageLevel stageLevelForWaterLevel:waterLevel];
    
    
    SAWStageLevel *stageLevel = waterLevel.stageLevel;
    SAWIrrigationSchedule *schedule = [SAWIrrigationSchedule irrigationScheduleForStageLevel:stageLevel streetNumber:@"13308"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    NSCalendarUnit units = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *currentComps = [calendar components:units fromDate:currentDate];
    
    SAWLocalNotificationManager *notificationManager = [[SAWLocalNotificationManager alloc] init];
    NSInteger hoursToAdd = 1;
    NSDate *fireDate = [notificationManager determineNextFireDateForSchedule:schedule timeRange:NSMakeRange(currentComps.hour + hoursToAdd, 4)];

    NSLog(@"fire date: %@", fireDate);
}

@end
