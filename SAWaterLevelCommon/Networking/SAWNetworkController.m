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

#import "SAWNetworkController.h"
#import "AFNetworking.h"
#import "SAWDataController.h"
#import "SAWStageLevel.h"
#import "SAWConstants.h"

typedef NS_ENUM(NSInteger, SAWNetworkError) {
    SAWNetworkErrorMissingData = -1100
};

@interface SAWNetworkController ()

@end

#define SERVICE_HOST @"http://sawaterlevels-api.herokuapp.com"
#define SERVICE_URL_CURRENT_WATER_LEVEL @"/level"

#define SERVICE_ERROR_DOMAIN @"SAWaterLevelErrorDomain"

@implementation SAWNetworkController

static SAWNetworkController *singleton;
static NSDateFormatter *waterLevelDateFormatter;

+ (instancetype)sharedNetworkController {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[SAWNetworkController alloc] init];
        waterLevelDateFormatter = [[NSDateFormatter alloc] init];
        [waterLevelDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    });

    return singleton;
}

- (void)performBackgroundWaterLevelFetchWithCompletion:(SAWCurrentWaterLevelCompletionHandler)completionHandler {
    SAWWaterLevel *currentLevel = [[[SAWDataController alloc] init] fetchCachedWaterLevel];

    [self fetchCurrentWaterLevelWithCompletion:^(SAWWaterLevel *newWaterLevel, NSError *error) {
        NSDictionary *userInfo = nil;

        if (newWaterLevel) {
            userInfo = @{ SAWNotificationKeyWaterLevel: newWaterLevel };
            
            if (currentLevel) {
                SAWStageLevelType currentType = currentLevel.stageLevel.level;
                SAWStageLevelType newType = currentLevel.stageLevel.level;

                SAWDataController *dataController = [[SAWDataController alloc] init];
                BOOL shouldNotifyOfStageChange = [dataController fetchNotifyOnStageLevelChange];

                if (currentType != newType && shouldNotifyOfStageChange) {   //  If they don't match, then alert the user to the change in stage level
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSString*(^stringFromStageLevel)(SAWStageLevelType) = ^(SAWStageLevelType stageLevelType) {
                            switch (stageLevelType) {
                                case SAWStageLevel1:
                                    return NSLocalizedString(@"STAGE_LEVEL_1", nil);
                                case SAWStageLevel2:
                                    return NSLocalizedString(@"STAGE_LEVEL_2", nil);
                                case SAWStageLevel3:
                                    return NSLocalizedString(@"STAGE_LEVEL_3", nil);
                                case SAWStageLevel4:
                                    return NSLocalizedString(@"STAGE_LEVEL_4", nil);
                                case SAWStageLevel5:
                                    return NSLocalizedString(@"STAGE_LEVEL_5", nil);
                                case SAWStageLevelNormal:
                                    return NSLocalizedString(@"STAGE_LEVEL_NO_RESTRICTION", nil);
                            }
                        };

                        NSString *localizedMessage = NSLocalizedString(@"NOTIFICATION_STAGE_LEVEL_CHANGE_ALERT_BODY", nil);
                        NSString *fromStageLevel = stringFromStageLevel(currentType);
                        NSString *toStageLevel = stringFromStageLevel(newType);
                        NSString *message = [NSString stringWithFormat:localizedMessage, fromStageLevel, toStageLevel];

                        UILocalNotification *notification = [[UILocalNotification alloc] init];
                        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
                        notification.alertBody = message;

//                        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                    });
                }
            }
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:SAWWaterLevelDidUpdateFromBackgroundNotification
                                                            object:nil
                                                          userInfo:userInfo];

        if (completionHandler) {
            completionHandler(newWaterLevel, error);
        }
    }];
}

- (void)fetchCurrentWaterLevelWithCompletion:(SAWCurrentWaterLevelCompletionHandler)completionHandler {
    __weak typeof(self) weakSelf = self;

    void (^failureHandler)(NSURLSessionDataTask*, NSError*) = ^(NSURLSessionDataTask *task, NSError *error) {
        if (completionHandler) {
            completionHandler(nil, error);
        }
    };

    void (^successHandler)(NSURLSessionDataTask*, id) = ^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *levelData = responseObject[@"level"];
        NSNumber *irrigationAllowed = responseObject[@"irrigationAllowed"];

        if (levelData == nil) {
            NSError *error = [weakSelf errorWithCode:SAWNetworkErrorMissingData errorMessage:NSLocalizedString(@"SERVICE_ERROR_MISSING_DATA", nil)];
            failureHandler(nil, error);
        } else {
            NSDate *localDate = [waterLevelDateFormatter dateFromString:levelData[@"lastUpdated"]];
            NSTimeInterval timeZoneOffset = [[NSTimeZone defaultTimeZone] secondsFromGMT]; // You could also use the systemTimeZone method
            NSTimeInterval gmtTimeInterval = [localDate timeIntervalSinceReferenceDate] - timeZoneOffset;
            NSDate *gmtDate = [NSDate dateWithTimeIntervalSinceReferenceDate:gmtTimeInterval];
            
            
            SAWWaterLevel *level = [[SAWWaterLevel alloc] init];
            level.lastUpdated = gmtDate;
            level.level = levelData[@"recent"];
            level.average = levelData[@"average"];

            SAWStageLevelType stageLevelType = [responseObject[@"stageLevel"] integerValue];
            level.stageLevel = [[SAWStageLevel alloc] initWithStageLevel:stageLevelType];
            level.irrigationAllowed = irrigationAllowed != nil ? [irrigationAllowed boolValue] : YES; // Defaults to YES if there isn't a value; put in here because the API doesn't yet support this attribute in the response

            SAWDataController *dataController = [[SAWDataController alloc] init];
            [dataController cacheWaterLevel:level];

            [[NSNotificationCenter defaultCenter] postNotificationName:SAWWaterLevelDidUpdateNotification object:nil];

            if (completionHandler) {
                completionHandler(level, nil);
            }
        }
    };

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:SERVICE_HOST]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:SERVICE_URL_CURRENT_WATER_LEVEL
      parameters:nil
         success:successHandler
         failure:failureHandler];
}

- (NSError *)errorWithCode:(NSInteger)code errorMessage:(NSString *)message {
    if (message == nil) {   // Sanity check
        message = @"";
    }

    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : message };
    return [NSError errorWithDomain:SERVICE_ERROR_DOMAIN code:code userInfo:userInfo];
}

@end
