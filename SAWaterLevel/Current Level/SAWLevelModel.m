//
//  SAWLevelModel.m
//  SAWaterLevel
//
//  Created by Wayne Hartman on 5/31/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import "SAWLevelModel.h"

@implementation SAWLevelModel

#pragma mark - Debug


- (NSString *)debugDescription {
    NSDictionary *values = @{
                             @"displayLevel" : self.displayLevel ?: [NSNull null],
                             @"level" : @(self.level)
                             };
    NSString *description = [NSString stringWithFormat:@"%@ %@", [super debugDescription], [values debugDescription]];

    return description;
}

@end
