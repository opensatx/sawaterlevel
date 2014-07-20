//
//  SAWNetworkController.m
//  SAWaterLevel
//
//  Created by Wayne Hartman on 5/31/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import "SAWNetworkController.h"
#import "AFNetworking.h"
#import "SAWDataController.h"
#import "SAWStageLevel.h"

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

- (void)fetchCurrentWaterLevelWithCompletion:(SAWCurrentWaterLevelCompletionHandler)completionHandler {
    NSString *requestPath = [NSString stringWithFormat:@"%@%@", SERVICE_HOST, SERVICE_URL_CURRENT_WATER_LEVEL];
    NSURL *url = [NSURL URLWithString:requestPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    __weak typeof(self) weakSelf = self;

    void (^failureHandler)(AFHTTPRequestOperation*,NSError*) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completionHandler) {
            completionHandler(nil, error);
        }
    };

    void (^successHandler)(AFHTTPRequestOperation*,id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completionHandler) {
            NSDictionary *levelData = responseObject[@"level"];

            if (levelData == nil) {
                NSError *error = [weakSelf errorWithCode:SAWNetworkErrorMissingData errorMessage:NSLocalizedString(@"SERVICE_ERROR_MISSING_DATA", nil)];
                failureHandler(nil, error);
            } else {
                SAWWaterLevel *level = [[SAWWaterLevel alloc] init];
                level.timestamp = [waterLevelDateFormatter dateFromString:levelData[@"lastUpdated"]];
                level.level = levelData[@"recent"];
                level.average = levelData[@"average"];

                SAWStageLevelType stageLevelType = [responseObject[@"stageLevel"] integerValue];
                level.stageLevel = [[SAWStageLevel alloc] initWithStageLevel:stageLevelType];

                SAWDataController *dataController = [[SAWDataController alloc] init];
                [dataController cacheWaterLevel:level];

                completionHandler(level, nil);
            }
        }
    };

    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:successHandler
                                            failure:failureHandler];
    [requestOperation start];
}

- (NSError *)errorWithCode:(NSInteger)code errorMessage:(NSString *)message {
    if (message == nil) {   // Sanity check
        message = @"";
    }

    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : message };
    return [NSError errorWithDomain:SERVICE_ERROR_DOMAIN code:code userInfo:userInfo];
}

@end
