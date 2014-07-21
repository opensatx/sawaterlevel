//
//  SAWWaterLevel.h
//  SAWaterLevel
//
//  Created by Wayne Hartman on 5/31/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SAWStageLevel;

/*!
 *  Object that represents a reported water level
 */
@interface SAWWaterLevel : NSObject <NSCoding>

/*!
 *  Timestamp of when the reading was last taken
 */
@property (nonatomic, strong) NSDate *lastUpdated;

/*!
 *  The current water level, measured in feet
 */
@property (nonatomic, strong) NSNumber *level;

/*!
 *  The 10-day average of the daily water level.
 */
@property (nonatomic, strong) NSNumber *average;

/*!
 *  The current stage level as declared by SAWS
 */
@property (nonatomic, strong) SAWStageLevel *stageLevel;

/*!
 *  Indicator of whether irrigation is allowed this week, as determined by SAWS
 *  @discussion This flag only comes into play with Stage 3 water restrictions where customers are only allowed to irrigate every other week.
 */
@property (nonatomic, assign, getter = isIrrigationAllowed) BOOL irrigationAllowed;

@end
