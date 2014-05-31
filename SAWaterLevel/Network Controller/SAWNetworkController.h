//
//  SAWNetworkController.h
//  SAWaterLevel
//
//  Created by Wayne Hartman on 5/31/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SAWWaterLevel.h"

typedef void(^SAWCurrentWaterLevelCompletionHandler)(SAWWaterLevel *waterLevel, NSError *error);

@interface SAWNetworkController : NSObject

- (void)fetchCurrentWaterLevelWithCompletion:(SAWCurrentWaterLevelCompletionHandler)completionHandler;

+ (instancetype)sharedNetworkController;

@end
