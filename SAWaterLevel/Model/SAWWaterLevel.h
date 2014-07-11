//
//  SAWWaterLevel.h
//  SAWaterLevel
//
//  Created by Wayne Hartman on 5/31/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAWWaterLevel : NSObject

@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, strong) NSNumber *level;
@property (nonatomic, strong) NSNumber *average;

@end
