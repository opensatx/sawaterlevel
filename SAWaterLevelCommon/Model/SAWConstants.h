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

@import Foundation;

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
