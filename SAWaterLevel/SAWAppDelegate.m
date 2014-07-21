//
//  SAWAppDelegate.m
//  SAWaterLevel
//
//  Created by Wayne Hartman on 5/31/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import "SAWAppDelegate.h"
#import "SAWNetworkController.h"

@implementation SAWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];

    return YES;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    SAWNetworkController *networkController = [SAWNetworkController sharedNetworkController];
    [networkController performBackgroundWaterLevelFetchWithCompletion:^(SAWWaterLevel *waterLevel, NSError *error) {
        if (error) {
            completionHandler(UIBackgroundFetchResultFailed);
        } else {
            completionHandler(UIBackgroundFetchResultNewData);
        }
    }];
}

@end
