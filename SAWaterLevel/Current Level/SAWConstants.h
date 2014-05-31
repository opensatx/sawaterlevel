//
//  SAWConstants.h
//  SAWaterLevel
//
//  Created by Wayne Hartman on 5/31/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SAWStageLevel) {
    SAWStageLevelNormal = 0,
    SAWStageLevel1,
    SAWStageLevel2,
    SAWStageLevel3,
    SAWStageLevel4,
    SAWStageLevel5
};

@interface SAWConstants : NSObject

+ (UIColor *)colorForStageLevel:(SAWStageLevel)stageLevel;
+ (UIColor *)textColorForStageLevel:(SAWStageLevel)stageLevel;

@end
