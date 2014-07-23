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
#import "SAWStageLevel.h"

typedef void(^SAWLocalNotificationScheduleCompletionHandler)(NSArray *notifications);

/*!
 *  Class that encapsulates the details of scheduling notifications
 */
@interface SAWLocalNotificationManager : NSObject

/*!
 *  Convenience method for creating an instance of this class
 */
+ (instancetype)localNotificationManager;

/*!
 *  Removes all scheduled local notifications
 */
- (void)removeAllNotifications;

/*!
 *  Creates irrigation schedule notifications based on the stage level and street number of the customer
 *  @param stageLevel the stageLevel that should be used to create the notifications
 *  @param streetNumber the street number of the customer
 *  @param completionHandler Block handler for when the creation of the notifications is complete
 */
- (void)scheduleNotificationsForStageLevel:(SAWStageLevel *)stageLevel streetNumber:(NSString *)streetNumber completion:(SAWLocalNotificationScheduleCompletionHandler)completionHandler;

@end
