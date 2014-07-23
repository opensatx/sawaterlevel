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

@class SAWWaterLevel;

typedef NS_ENUM(NSInteger, SAWStageLevelType) {
    SAWStageLevelNormal = 0,
    SAWStageLevel1,
    SAWStageLevel2,
    SAWStageLevel3,
    SAWStageLevel4,
    SAWStageLevel5
};

/*!
 *  Represents a restriction stage level
 */
@interface SAWStageLevel : NSObject <NSCoding>

/*!
 *  Type of the stage level
 */
@property (nonatomic, assign) SAWStageLevelType level;

/*!
 *  Flag for indicating if irrigation is allowed for the current week
 */
@property (nonatomic, assign, getter = isIrrigationAllowed) BOOL irrigationAllowed;

/*!
 *  Title of the stage level that should be displayed to the user
 */
@property (nonatomic, strong, readonly) NSString *localizedTitle;

/*!
 *  URL that points to content that can be displayed related to the stage level
 */
@property (nonatomic, strong, readonly) NSURL *localizedContentURL;

- (instancetype)initWithStageLevel:(SAWStageLevelType)stageLevel;

/*!
 *  Convenience method for obtaining the water level where a stage starts
 *  @param level The stage level
 *  @return a float value of the what the starting water level is for the stage
 */
+ (CGFloat)footStartingLevelForStageLevel:(SAWStageLevelType)level;

/*!
 *  Convenience method for creating a SAWStageLevel object based on a water level
 *  @param waterLevel The WaterLevel for which a stage level should be created
 *  @return a fully initialized SAWStageLevel from the water level object based on published Edwards Aquifer Authority (EAA) rules.
 *  @discussion This method should not be used to calculate what the current stage level is.  The stage level is decided by SAWS based on criteria that it keeps private.  The EAA has well-defined rules, which this method returns, but ultimately SAWS decides the stage level for its customers.  This method is useful for identifying when the EAA and SAWS stage levels are different from one another.
 */
+ (SAWStageLevel *)stageLevelForWaterLevel:(SAWWaterLevel *)waterLevel;

@end
