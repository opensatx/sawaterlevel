//
//  SAWNotificationInterfaceController.m
//  SAWaterLevel
//
//  Created by Wayne Hartman on 6/17/15.
//  Copyright (c) 2015 Wayne Hartman. All rights reserved.
//

#import "SAWNotificationInterfaceController.h"

@interface SAWNotificationInterfaceController ()
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *displayLabel;

@end

@implementation SAWNotificationInterfaceController

- (void)didReceiveRemoteNotification:(NSDictionary *)remoteNotification withCompletion:(void(^)(WKUserNotificationInterfaceType interface)) completionHandler {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = NSLocalizedString(@"LOCAL_NOTIFICATION_ALERT", nil);

    [self didReceiveLocalNotification:notification withCompletion:completionHandler];
}

- (void)didReceiveLocalNotification:(UILocalNotification *)localNotification withCompletion:(void(^)(WKUserNotificationInterfaceType interface)) completionHandler {

    self.displayLabel.text = localNotification.alertBody;

    completionHandler(WKUserNotificationInterfaceTypeCustom);
}

@end
