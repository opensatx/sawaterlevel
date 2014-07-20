//
//  SAWDataController.h
//  SAWaterLevel
//
//  Created by Wayne Hartman on 7/11/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SAWWaterLevel;

@interface SAWDataController : NSObject

- (void)cacheWaterLevel:(SAWWaterLevel *)waterLevel;
- (SAWWaterLevel *)fetchCachedWaterLevel;

- (void)cacheHouseNumber:(NSString *)houseNumber;
- (NSString *)fetchCachedHouseNumber;

@end
