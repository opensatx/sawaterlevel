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
