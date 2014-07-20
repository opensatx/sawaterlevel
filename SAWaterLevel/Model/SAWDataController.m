//
//  SAWDataController.m
//  SAWaterLevel
//
//  Created by Wayne Hartman on 7/11/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import "SAWDataController.h"

#define USER_DEFAULT_KEY_CACHED_WATER @"SAWCachedWaterLevel"
#define USER_DEFAULT_KEY_CACHED_HOUSE_NUMBER @"SAWCachedHouseNumber"

@implementation SAWDataController

#pragma mark - Public Methods

- (void)cacheWaterLevel:(SAWWaterLevel *)waterLevel {
    NSURL *cacheURL = [self cachedWaterLevelURL];

    if (waterLevel) {
        NSError *writeError = nil;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:waterLevel];
        BOOL success = [data writeToURL:cacheURL options:NSDataWritingAtomic error:&writeError];

        if (!success) {
            NSLog(@"Unable to write water level: %@", writeError.description);
        }
    } else {
        NSFileManager *fm = [NSFileManager defaultManager];

        if ([fm fileExistsAtPath:cacheURL.path]) {
            NSError *error = nil;
            BOOL success = [fm removeItemAtURL:cacheURL error:&error];

            if (!success) {
                NSLog(@"Unable to remove water level archive! %@", error.description);
            }
        }
    }
}

- (SAWWaterLevel *)fetchCachedWaterLevel {
    NSURL *cacheURL = [self cachedWaterLevelURL];

    NSFileManager *fm = [NSFileManager defaultManager];

    if ([fm fileExistsAtPath:cacheURL.path]) {
        NSError *readError = nil;
        NSData *data = [NSData dataWithContentsOfURL:cacheURL 
                                             options:0
                                               error:&readError];

        if (!data) {
            NSLog(@"Error reading data: %@", readError.description);
            return nil;
        }

        SAWWaterLevel *waterLevel = [NSKeyedUnarchiver unarchiveObjectWithData:data];

        return waterLevel;
    } else {
        return nil;
    }
}

- (void)cacheHouseNumber:(NSString *)houseNumber {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (houseNumber) {
        [defaults setObject:houseNumber forKey:USER_DEFAULT_KEY_CACHED_HOUSE_NUMBER];
    } else {
        [defaults removeObjectForKey:USER_DEFAULT_KEY_CACHED_HOUSE_NUMBER];
    }

    [defaults synchronize];
}

- (NSString *)fetchCachedHouseNumber {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:USER_DEFAULT_KEY_CACHED_HOUSE_NUMBER];
}

#pragma mark - Internal Methods

- (NSURL *)cachedWaterLevelURL {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths firstObject];
    NSString *levelPath = [NSString stringWithFormat:@"%@/waterLevel.archive", libraryDirectory];

    return [NSURL fileURLWithPath:levelPath];
}

@end
