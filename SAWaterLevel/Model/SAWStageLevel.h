//
//  SAWStageLevel.h
//  SAWaterLevel
//
//  Created by Wayne Hartman on 7/12/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SAWStageLevels) {
    SAWStageLevelNormal = 0,
    SAWStageLevel1,
    SAWStageLevel2,
    SAWStageLevel3,
    SAWStageLevel4,
    SAWStageLevel5
};

@interface SAWStageLevel : NSObject

- (instancetype)initWithStageLevel:(SAWStageLevels)stageLevel;

@property (nonatomic, assign) SAWStageLevels level;
@property (nonatomic, strong, readonly) NSString *localizedTitle;
@property (nonatomic, strong, readonly) NSURL *localizedContentURL;

@end
