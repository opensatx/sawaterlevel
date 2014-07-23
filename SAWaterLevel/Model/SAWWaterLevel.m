/*
 *
 *  Copyright (c) 2014 Wayne Hartman
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy of
 *  this software and associated documentation files (the "Software"), to deal in the
 *  Software without restriction, including without limitation the rights to use,
 *  copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
 *  Software, and to permit persons to whom the Software is furnished to do so, subject
 *  to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all copies
 *  or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 *  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 *  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 *  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 *  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 *  THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 */

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
