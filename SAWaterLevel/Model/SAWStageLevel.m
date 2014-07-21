//
//  SAWStageLevel.m
//  SAWaterLevel
//
//  Created by Wayne Hartman on 7/12/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import "SAWStageLevel.h"
#import "SAWWaterLevel.h"

@implementation SAWStageLevel

- (instancetype)initWithStageLevel:(SAWStageLevelType)stageLevel {
    if (self = [super init]) {
        _level = stageLevel;
    }

    return self;
}

+ (SAWStageLevel *)stageLevelForWaterLevel:(SAWWaterLevel *)waterLevel {
    if (waterLevel == nil) {
        return nil;
    }

    SAWStageLevelType level = SAWStageLevelNormal;

    float levelValue = [waterLevel.average floatValue];

    if (levelValue <= [self footStartingLevelForStageLevel:SAWStageLevel5]) {
        level = SAWStageLevel5;
    } else if (levelValue <= [self footStartingLevelForStageLevel:SAWStageLevel4]) {
        level = SAWStageLevel4;
    } else if (levelValue <= [self footStartingLevelForStageLevel:SAWStageLevel3]) {
        level = SAWStageLevel3;
    } else if (levelValue <= [self footStartingLevelForStageLevel:SAWStageLevel2]) {
        level = SAWStageLevel2;
    } else if (levelValue <= [self footStartingLevelForStageLevel:SAWStageLevel1]) {
        level = SAWStageLevel1;
    } else {
        level = SAWStageLevelNormal;
    }

    SAWStageLevel *stageLevel = [[SAWStageLevel alloc] initWithStageLevel:level];
    return stageLevel;
}

#pragma mark - Utility Methods

+ (CGFloat)footStartingLevelForStageLevel:(SAWStageLevelType)level {
    switch (level) {
        case SAWStageLevelNormal:
            return 670.0f;
        case SAWStageLevel1:
            return 660.0f;
        case SAWStageLevel2:
            return 650.0f;
        case SAWStageLevel3:
            return 640.0f;
        case SAWStageLevel4:
            return 630.0f;
        case SAWStageLevel5:
            return 625.0f;
    }
}

#pragma mark - Lazy Getters

- (NSURL *)localizedContentURL {
    NSString *contentFileName = nil;
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    if ([language isEqualToString:@"es"]) {
        switch (self.level) {
            case SAWStageLevelNormal:
                contentFileName = @"WebContent/es/NoRestrictions.html";
                break;
            case SAWStageLevel1:
                contentFileName = @"WebContent/es/Stage1.html";
                break;
            case SAWStageLevel2:
                contentFileName = @"WebContent/es/Stage2.html";
                break;
            case SAWStageLevel3:
                contentFileName = @"WebContent/es/Stage3.html";
                break;
            case SAWStageLevel4:
                contentFileName = @"WebContent/es/Stage4.html";
                break;
            case SAWStageLevel5:
                contentFileName = @"WebContent/es/Stage5.html";
                break;
        }
    } else {
        switch (self.level) {
            case SAWStageLevelNormal:
                contentFileName = @"WebContent/en/NoRestrictions.html";
                break;
            case SAWStageLevel1:
                contentFileName = @"WebContent/en/Stage1.html";
                break;
            case SAWStageLevel2:
                contentFileName = @"WebContent/en/Stage2.html";
                break;
            case SAWStageLevel3:
                contentFileName = @"WebContent/en/Stage3.html";
                break;
            case SAWStageLevel4:
                contentFileName = @"WebContent/en/Stage4.html";
                break;
            case SAWStageLevel5:
                contentFileName = @"WebContent/en/Stage5.html";
                break;
        }
    }

    NSString *path = [[NSBundle mainBundle] pathForResource:contentFileName ofType:@""];
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

#pragma mark - NSCoder

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInteger:self.level forKey:@"level"];
    [encoder encodeBool:self.isIrrigationAllowed forKey:@"irrigationAllowed"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        [self setLevel:[decoder decodeIntegerForKey:@"level"]];
        [self setIrrigationAllowed:[decoder decodeBoolForKey:@"irrigationAllowed"]];
    }
    return self;
}

#pragma mark - Debug

- (NSString *)debugDescription {
    NSDictionary *values = @{
                             @"level" : @(self.level) ?: [NSNull null],
                             @"contentURL" : self.localizedContentURL ?: [NSNull null],
                             @"localizedTitle" : self.localizedTitle ?: [NSNull null]
                             };

    NSString *description = [NSString stringWithFormat:@"%@ %@", [super debugDescription], [values debugDescription]];

    return description;
}

@end
