//
//  SAWLocalNotificationManager.h
//  SAWaterLevel
//
//  Created by Wayne Hartman on 7/12/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

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
