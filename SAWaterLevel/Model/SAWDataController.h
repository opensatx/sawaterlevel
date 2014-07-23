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
