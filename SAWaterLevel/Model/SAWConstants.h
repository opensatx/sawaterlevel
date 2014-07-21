//
//  SAWConstants.h
//  SAWaterLevel
//
//  Created by Wayne Hartman on 7/20/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  Notification when the network controller has updated the current water level from a UI request
 */
extern NSString *const SAWWaterLevelDidUpdateNotification;

/*!
 *  Notification when the network controller has updated the current water level from a background fetch request
 */
extern NSString *const SAWWaterLevelDidUpdateFromBackgroundNotification;

/*!
 *  Notification key that can be used to get the water level passed by a water level notification
 */
extern NSString *const SAWNotificationKeyWaterLevel;

/*!
 *  User Defaults key used to determine if the user has been shown a screen educating them on the descrepency between the SAWS stage level and the Edwards Aquifer Authority stage level.
 */
extern NSString *const SAWUserInfoKeyHasBeenShownStageDescrepency;

@interface SAWConstants : NSObject

@end
