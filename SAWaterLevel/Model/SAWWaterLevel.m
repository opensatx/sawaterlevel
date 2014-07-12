//
//  SAWWaterLevel.m
//  SAWaterLevel
//
//  Created by Wayne Hartman on 5/31/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import "SAWWaterLevel.h"

@implementation SAWWaterLevel

#pragma mark - Debug

- (NSString *)debugDescription {
    NSDictionary *values = @{
                             @"timestamp" : self.timestamp ?: [NSNull null],
                             @"level" : self.level ?: [NSNull null],
                             @"average" : self.average ?: [NSNull null]
                             };
    NSString *description = [NSString stringWithFormat:@"%@ %@", [super debugDescription], [values debugDescription]];

    return description;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.timestamp forKey:@"timestamp"];
    [encoder encodeObject:self.level forKey:@"level"];
    [encoder encodeObject:self.average forKey:@"average"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.timestamp = [decoder decodeObjectForKey:@"timestamp"];
        self.level = [decoder decodeObjectForKey:@"level"];
        self.average = [decoder decodeObjectForKey:@"average"];
    }

    return self;
}

@end
