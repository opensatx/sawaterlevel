//
//  SAWDataController.h
//  SAWaterLevel
//
//  Created by Wayne Hartman on 7/11/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SAWWaterLevel;

/*!
 *  Class for hiding all the details of local data persistence
 */
@interface SAWDataController : NSObject

/*!
 *  Persist details of water levels
 *  @param waterLevel The SAWWaterLevel object to cache
 */
- (void)cacheWaterLevel:(SAWWaterLevel *)waterLevel;

/*!
 *  Fetch cached details of the last persisted water level
 *  @return cached SAWWaterLevel object.  If none exists, returns nil
 */
- (SAWWaterLevel *)fetchCachedWaterLevel;

/*!
 *  Persist details of a house number.  Used to determine if a user wants to receive notifications of when to irrigate
 */
- (void)cacheHouseNumber:(NSString *)houseNumber;

/*!
 *  Fetch cached details of the last persisted house number
 *  @return cached house number.  If none exists, returns nil
 */
- (NSString *)fetchCachedHouseNumber;

@end
