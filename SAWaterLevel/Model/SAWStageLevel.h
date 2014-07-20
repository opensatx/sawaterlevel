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

@interface SAWStageLevel : NSObject <NSCoding>

@property (nonatomic, assign) SAWStageLevelType level;
@property (nonatomic, strong, readonly) NSString *localizedTitle;
@property (nonatomic, strong, readonly) NSURL *localizedContentURL;

- (instancetype)initWithStageLevel:(SAWStageLevelType)stageLevel;

+ (CGFloat)footStartingLevelForStageLevel:(SAWStageLevelType)level;
+ (SAWStageLevel *)stageLevelForWaterLevel:(SAWWaterLevel *)waterLevel;

@end
