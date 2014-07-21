//
//  SAWStageDetailsViewController.h
//  SAWaterLevel
//
//  Created by Wayne Hartman on 5/31/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SAWStageLevel;

/*!
 *  Class for displaying details concerning a restriction stage level
 */
@interface SAWStageDetailsViewController : UIViewController

/*!
 *  The stage level for which content should be displayed
 */
@property (nonatomic, strong) SAWStageLevel *stageLevel;

@end
