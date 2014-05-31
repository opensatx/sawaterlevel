//
//  SAWNetworkController.m
//  SAWaterLevel
//
//  Created by Wayne Hartman on 5/31/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import "SAWNetworkController.h"
#import "AFNetworking.h"

@interface SAWNetworkController ()

@end

#define SERVICE_URL_CURRENT_WATER_LEVEL @"http://10.10.1.38:5000/level"

@implementation SAWNetworkController

static SAWNetworkController *singleton;
static NSDateFormatter *waterLevelDateFormatter;

+ (instancetype)sharedNetworkController {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[SAWNetworkController alloc] init];
        waterLevelDateFormatter = [[NSDateFormatter alloc] init];
        [waterLevelDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    });

    return singleton;
}



- (void)fetchCurrentWaterLevelWithCompletion:(SAWCurrentWaterLevelCompletionHandler)completionHandler {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SERVICE_URL_CURRENT_WATER_LEVEL]];

    void (^failureHandler)(AFHTTPRequestOperation*,NSError*) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completionHandler) {
            completionHandler(nil, error);
        }
    };

    void (^successHandler)(AFHTTPRequestOperation*,id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completionHandler) {
            NSDictionary *data = responseObject[@"level"];

            SAWWaterLevel *level = [[SAWWaterLevel alloc] init];
            level.timestamp = [waterLevelDateFormatter dateFromString:data[@"timestamp"]];
            level.level = data[@"level"];
            level.average = data[@"average"];

            completionHandler(level, nil);
        }
    };

    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:successHandler
                                            failure:failureHandler];
    [requestOperation start];
}

@end
