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

@import Foundation;

@class SAWStageLevel;

/*!
 *  Object that represents a reported water level
 */
@interface SAWWaterLevel : NSObject <NSSecureCoding>

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
