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

/*!
 *  Class for hiding all the details around network operation and remote data retrieval
 */
@interface SAWNetworkController : NSObject

/*!
 *  Network operation for fetching current water and restriction stage levels
 *  @param completionHandler current water level completion handler that returns a WaterLevel object and applicable error information.
 */
- (void)fetchCurrentWaterLevelWithCompletion:(SAWCurrentWaterLevelCompletionHandler)completionHandler;

/*!
 *  Network operation for fetching current water and restriction stage levels, with additional handling appropriate for background fetching
 *  @param completionHandler current water level completion handler that returns a WaterLevel object and applicable error information.
 */
- (void)performBackgroundWaterLevelFetchWithCompletion:(SAWCurrentWaterLevelCompletionHandler)completionHandler;

/*!
 *  Class method for returning a singleton for network operations.
 *  @discussion because the internals of the class may keep track of long-running data exchange and other things, consumers should always use this shared instance, instead of creating new instances.
 */
+ (instancetype)sharedNetworkController;

@end
