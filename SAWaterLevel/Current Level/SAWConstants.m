//
//  SAWConstants.m
//  SAWaterLevel
//
//  Created by Wayne Hartman on 5/31/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import "SAWConstants.h"

@implementation SAWConstants

+ (UIColor *)colorForStageLevel:(SAWStageLevel)stageLevel {
    switch (stageLevel) {
        case SAWStageLevelNormal:
            return [UIColor blueColor];
        case SAWStageLevel1:
            return [UIColor colorWithRed:163.0f/255.0f green:212.0f/255.0f blue:113.0f/255.0f alpha:1.0f];
        case SAWStageLevel2:
            return [UIColor colorWithRed:255.0f/255.0f green:212.0f/255.0f blue:99.0f/255.0f alpha:1.0f];
        case SAWStageLevel3:
            return [UIColor colorWithRed:255.0f/255.0f green:170.0f/255.0f blue:87.0f/255.0f alpha:1.0f];
        case SAWStageLevel4:
            return [UIColor colorWithRed:255.0f/255.0f green:97.0f/255.0f blue:67.0f/255.0f alpha:1.0f];
        case SAWStageLevel5:
            return [UIColor colorWithRed:105.0f/255.0f green:68.0f/255.0f blue:108.0f/255.0f alpha:1.0f];
    }
    
    return nil;
}

+ (UIColor *)textColorForStageLevel:(SAWStageLevel)stageLevel {
    switch (stageLevel) {
        case SAWStageLevelNormal:
        case SAWStageLevel5:
            return [UIColor whiteColor];
        default:
            return [UIColor blackColor];
    }
}

@end
