//
//  SAWAppDelegate.m
//  SAWaterLevel
//
//  Created by Wayne Hartman on 5/31/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import "SAWAppDelegate.h"
#import "SAWNetworkController.h"
#import "SAWDataController.h"
#import "SAWStageLevel.h"
#import "SAWLocalNotificationManager.h"

@implementation SAWAppDelegate

#pragma mark - Instance Methods

- (void)setupAppearance {
    UIColor *tabBarSelectedImageTint = [UIColor colorWithRed:63.0f/255.0f  //  Light Blue
                                                       green:124.0f/255.0f
                                                        blue:162.0f/255.0f
                                                       alpha:1.0f];
    [[UITabBar appearance] setSelectedImageTintColor:tabBarSelectedImageTint];
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    [self setupAppearance];

    return YES;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    SAWDataController *dataController = [[SAWDataController alloc] init];

    NSString *houseNumber = [dataController fetchCachedHouseNumber];
    SAWWaterLevel *existingWaterLevel = [dataController fetchCachedWaterLevel];

    SAWNetworkController *networkController = [SAWNetworkController sharedNetworkController];
    [networkController performBackgroundWaterLevelFetchWithCompletion:^(SAWWaterLevel *waterLevel, NSError *error) {
        if (error) {
            completionHandler(UIBackgroundFetchResultFailed);
        } else {
            //  We may need to slightly delay executing the background fetch completion in cases where we
            //  need to update notifications
            void(^executeCompletion)(void) = ^{
                completionHandler(UIBackgroundFetchResultNewData);
            };
            
            //  Update irrigation notifications if there is change in stage level
            if (existingWaterLevel &&   //  got to have a previous water level
                houseNumber &&          //  need to have the house number of the user
                existingWaterLevel.stageLevel.level != waterLevel.stageLevel.level) //  and there needs to be a change in the stage level
            {
                SAWLocalNotificationManager *notificationManager = [SAWLocalNotificationManager localNotificationManager];
                [notificationManager scheduleNotificationsForStageLevel:waterLevel.stageLevel streetNumber:houseNumber completion:^(NSArray *notifications) {
                    executeCompletion();
                }];
            } else {    //  Nothing changed, so we're done
                executeCompletion();
            }
        }
    }];
}

@end
