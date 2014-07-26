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

#import "SAWAppDelegate.h"
#import "SAWNetworkController.h"
#import "SAWDataController.h"
#import "SAWStageLevel.h"
#import "SAWLocalNotificationManager.h"

@implementation SAWAppDelegate

#pragma mark - Instance Methods

- (void)setupAppearance {
    UIColor *tabBarSelectedImageTint = [UIColor colorWithRed:63.0f/255.0f  //  Gray-Blue
                                                       green:124.0f/255.0f
                                                        blue:162.0f/255.0f
                                                       alpha:1.0f];
    [[UITabBar appearance] setSelectedImageTintColor:tabBarSelectedImageTint];
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    [SAWDataController registerDefaults];

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
