//
//  SAWStageLevel.m
//  SAWaterLevel
//
//  Created by Wayne Hartman on 7/12/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import "SAWStageLevel.h"

@implementation SAWStageLevel

- (instancetype)initWithStageLevel:(SAWStageLevels)stageLevel {
    if (self = [super init]) {
        _level = stageLevel;
    }

    return self;
}

- (NSURL *)contentURL {
    NSString *contentFileName = nil;
    
    switch (self.level) {
        case SAWStageLevelNormal:
            contentFileName = @"NoRestrictions";
            break;
        case SAWStageLevel1:
            contentFileName = @"Stage1";
            break;
        case SAWStageLevel2:
            contentFileName = @"Stage2";
            break;
        case SAWStageLevel3:
            contentFileName = @"Stage3";
            break;
        case SAWStageLevel4:
            contentFileName = @"Stage4";
            break;
        case SAWStageLevel5:
            contentFileName = @"Stage5";
            break;
    }

    NSString *path = [[NSBundle mainBundle] pathForResource:contentFileName ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];

    return url;
}

- (NSString *)localizedTitle {
    switch (self.level) {
        case SAWStageLevelNormal:
            return NSLocalizedString(@"STAGE_LEVEL_NO_RESTRICTION", nil);
        case SAWStageLevel1:
            return NSLocalizedString(@"STAGE_LEVEL_1", nil);
        case SAWStageLevel2:
            return NSLocalizedString(@"STAGE_LEVEL_2", nil);
        case SAWStageLevel3:
            return NSLocalizedString(@"STAGE_LEVEL_3", nil);
        case SAWStageLevel4:
            return NSLocalizedString(@"STAGE_LEVEL_4", nil);
        case SAWStageLevel5:
            return NSLocalizedString(@"STAGE_LEVEL_5", nil);
    }
}

@end
