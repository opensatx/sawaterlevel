//
//  SAWLevelModel.h
//  SAWaterLevel
//
//  Created by Wayne Hartman on 5/31/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  Class for building the table view.
 */
@interface SAWLevelModel : NSObject

/*!
 *  String display level to present
 */
@property (nonatomic, strong) NSString *displayLevel;

/*!
 *  Actual numeric value of the level
 */
@property (nonatomic, assign) float level;

@end
