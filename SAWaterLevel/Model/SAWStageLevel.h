//
//  SAWStageLevel.h
//  SAWaterLevel
//
//  Created by Wayne Hartman on 7/12/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

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
