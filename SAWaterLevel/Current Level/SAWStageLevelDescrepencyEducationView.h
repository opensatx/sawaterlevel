//
//  SAWStageLevelDescrepencyEducationView.h
//  SAWaterLevel
//
//  Created by Wayne Hartman on 7/20/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAWStageLevel.h"

typedef void(^SAWStageLevelDescrepencyEducationViewCompletionHandler)(void);

/*!
 *  View for educating users on why there might be differences between the SAWS stage level and the actual Edwards Aquifer level
 */
@interface SAWStageLevelDescrepencyEducationView : UIView

/*!
 *  Block handler called when the user indicates that they are finished with viewing the content of this view
 */
@property (nonatomic, copy) SAWStageLevelDescrepencyEducationViewCompletionHandler completionHandler;

/*!
 *  Designated initializer of this class
 *  @param frame The size of the instance to create
 *  @param stageRestrictionView The view used to display the current stage restrictions
 *  @return Fully initialized instance of this class
 */
- (instancetype) initWithFrame:(CGRect)frame currentStageRestrictionView:(UIView *)stageRestrictionView;

/*!
 *  The stage level as calculated by the average water level
 */
@property (nonatomic, assign) SAWStageLevelType waterStageLevel;

/*!
 *  The stage level declared by SAWS
 */
@property (nonatomic, assign) SAWStageLevelType actualStageLevel;

@end
