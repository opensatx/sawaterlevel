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

@property (nonatomic, copy) SAWStageLevelDescrepencyEducationViewCompletionHandler completionHandler;

- (instancetype) initWithFrame:(CGRect)frame currentStageRestrictionView:(UIView *)stageRestrictionView;

@property (nonatomic, assign) SAWStageLevelType waterStageLevel;
@property (nonatomic, assign) SAWStageLevelType actualStageLevel;

@end
