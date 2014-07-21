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

/*!
 *  Data source for displaying information on the current water level
 */
@interface SAWCurrentLevelDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

/*!
 *  The table view used display the data
 */
@property (nonatomic, weak) IBOutlet UITableView *tableView;

/*!
 *  The water level information to display by the data source
 */
@property (nonatomic, strong) SAWWaterLevel *waterLevel;

/*!
 *  Handler called whenever detailed information is requested for a particular stage of restrictions
 */
@property (nonatomic, copy) SAWStageRestrictionInfoHandler stageRestrictionInfoHandler;

@end
