//
//  SAWStageLevel+UI.m
//  SAWaterLevel
//
//  Created by Wayne Hartman on 7/12/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import "SAWStageLevel+UI.h"

@implementation SAWStageLevel (UI)

- (UIColor *)backgroundColor {
    switch (self.level) {
        case SAWStageLevelNormal:   //  Light Blue
            return [UIColor colorWithRed:113.0f/255.0f
                                   green:174.0f/255.0f
                                    blue:212.0f/255.0f
                                   alpha:1.0f];
        case SAWStageLevel1:    //  Green
            return [UIColor colorWithRed:163.0f/255.0f
                                   green:212.0f/255.0f
                                    blue:113.0f/255.0f
                                   alpha:1.0f];
        case SAWStageLevel2:    //  Yellow
            return [UIColor colorWithRed:255.0f/255.0f
                                   green:212.0f/255.0f
                                    blue:99.0f/255.0f
                                   alpha:1.0f];
        case SAWStageLevel3:    //  Orange
            return [UIColor colorWithRed:255.0f/255.0f
                                   green:170.0f/255.0f
                                    blue:87.0f/255.0f
                                   alpha:1.0f];
        case SAWStageLevel4:    //  Red
            return [UIColor colorWithRed:255.0f/255.0f
                                   green:97.0f/255.0f
                                    blue:67.0f/255.0f
                                   alpha:1.0f];
        case SAWStageLevel5:    //  Purple
            return [UIColor colorWithRed:105.0f/255.0f
                                   green:68.0f/255.0f
                                    blue:108.0f/255.0f
                                   alpha:1.0f];
    }
    
    return nil;
}

- (UIColor *)foregroundColor {
    switch (self.level) {
        case SAWStageLevel5:
            return [UIColor whiteColor];
        default:
            return [UIColor blackColor];
    }
}

@end
