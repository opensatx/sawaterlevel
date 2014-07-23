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
