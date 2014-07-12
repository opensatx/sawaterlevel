//
//  SAWCurrentLevelDataSource.h
//  SAWaterLevel
//
//  Created by Wayne Hartman on 7/12/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SAWWaterLevel;
@class SAWStageLevel;

typedef void(^SAWStageRestrictionInfoHandler)(SAWStageLevel *stageLevel);

@interface SAWCurrentLevelDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SAWWaterLevel *waterLevel;
@property (nonatomic, copy) SAWStageRestrictionInfoHandler stageRestrictionInfoHandler;

@end
