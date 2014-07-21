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

@property (nonatomic, strong) NSString *displayLevel;
@property (nonatomic, assign) float level;

@end
