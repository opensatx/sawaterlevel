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
