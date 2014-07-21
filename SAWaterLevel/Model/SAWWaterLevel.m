//
//  SAWWaterLevel.m
//  SAWaterLevel
//
//  Created by Wayne Hartman on 5/31/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import "SAWWaterLevel.h"
#import "SAWStageLevel.h"

@implementation SAWWaterLevel

#pragma mark - Debug

- (NSString *)debugDescription {
    NSDictionary *values = @{
                             @"timestamp" : self.lastUpdated ?: [NSNull null],
                             @"level" : self.level ?: [NSNull null],
                             @"average" : self.average ?: [NSNull null],
                             @"irrigationAllowed" : @(self.irrigationAllowed)
                             };
    NSString *description = [NSString stringWithFormat:@"%@ %@", [super debugDescription], [values debugDescription]];

    return description;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.lastUpdated forKey:@"lastUpdated"];
    [encoder encodeObject:self.level forKey:@"level"];
    [encoder encodeObject:self.average forKey:@"average"];
    [encoder encodeObject:self.stageLevel forKey:@"stageLevel"];
    [encoder encodeBool:self.isIrrigationAllowed forKey:@"irrigationAllowed"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.lastUpdated = [decoder decodeObjectForKey:@"lastUpdated"];
        self.level = [decoder decodeObjectForKey:@"level"];
        self.average = [decoder decodeObjectForKey:@"average"];
        self.stageLevel = [decoder decodeObjectForKey:@"stageLevel"];
        self.irrigationAllowed = [decoder decodeBoolForKey:@"irrigationAllowed"];
    }

    return self;
}

@end
