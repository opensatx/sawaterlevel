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

+ (instancetype)localNotificationManager;
- (void)removeAllNotifications;
- (void)scheduleNotificationsForStageLevel:(SAWStageLevel *)stageLevel streetNumber:(NSString *)streetNumber completion:(SAWLocalNotificationScheduleCompletionHandler)completionHandler;
- (UILocalNotification *)nextNotification;

@end
