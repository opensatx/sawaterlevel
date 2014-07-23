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

#import "SAWStageLevelDescrepencyEducationView.h"

@interface SAWStageLevelDescrepencyEducationView()

@property (nonatomic, strong) UIView *stageRestrictionView;

@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UILabel *infoLabel;

@end

@implementation SAWStageLevelDescrepencyEducationView

#pragma mark - Super Overrides

- (instancetype) initWithFrame:(CGRect)frame currentStageRestrictionView:(UIView *)stageRestrictionView {
    if (self = [super initWithFrame:frame]) {
        _stageRestrictionView = stageRestrictionView;
    }

    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];

    if (newSuperview) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
        [self setNeedsDisplay];
        [self addSubview:self.infoLabel];
        [self addSubview:self.dismissButton];
    }
}

//  Override draw rect so that we can 'cut out' the rectangles of the views we want to show through this view.
- (void)drawRect:(CGRect)rect {
    [self.backgroundColor setFill];
    UIRectFill(rect);

    void(^clearRectOfView)(UIView *) = ^(UIView *view) {
        CGRect hole = [view.superview convertRect:view.frame toView:nil];
        [[UIColor clearColor] setFill];

        CGFloat radius = view.layer.cornerRadius - 1.0f;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:hole
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:CGSizeMake(radius, radius)];

        CGContextRef context = UIGraphicsGetCurrentContext();
        CGPathRef clippath = path.CGPath;
        CGContextAddPath(context, clippath);
        CGContextClip(context);

        [[UIColor clearColor] setFill];
        UIRectFill(hole);
    };

    clearRectOfView(self.stageRestrictionView);
}

#pragma mark - Lazy Loaders

static CGFloat margin = 20.0f;

- (UIButton *)dismissButton {
    if (!_dismissButton) {
        CGFloat height = 44.0f;
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(margin * 0.5f,
                                                                      self.infoLabel.frame.origin.y + self.infoLabel.frame.size.height + margin,
                                                                      self.frame.size.width - margin,
                                                                      height)];
        [button setTitle:NSLocalizedString(@"EDUCATION_DISMISS_BUTTON_TITLE", nil) forState:UIControlStateNormal];
        button.titleLabel.textColor = [UIColor whiteColor];
        button.layer.cornerRadius = 10.0f;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.borderWidth = 0.5f;
        [button addTarget:self action:@selector(didSelectDismissButton:) forControlEvents:UIControlEventTouchUpInside];

        _dismissButton = button;
    }
    
    return _dismissButton;
}

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        CGRect(^translatedRectOfView)(UIView *) = ^(UIView *view) {
            CGRect rect = [view.superview convertRect:view.frame toView:nil];
            return rect;
        };
        
        NSString*(^stringFromStageLevel)(SAWStageLevelType) = ^(SAWStageLevelType stageLevelType) {
            switch (stageLevelType) {
                case SAWStageLevel1:
                    return NSLocalizedString(@"STAGE_LEVEL_1", nil);
                case SAWStageLevel2:
                    return NSLocalizedString(@"STAGE_LEVEL_2", nil);
                case SAWStageLevel3:
                    return NSLocalizedString(@"STAGE_LEVEL_3", nil);
                case SAWStageLevel4:
                    return NSLocalizedString(@"STAGE_LEVEL_4", nil);
                case SAWStageLevel5:
                    return NSLocalizedString(@"STAGE_LEVEL_5", nil);
                case SAWStageLevelNormal:
                    return NSLocalizedString(@"STAGE_LEVEL_NO_RESTRICTION", nil);
            }
        };
        
        NSString *localizedText = NSLocalizedString(@"EDUCATION_EXPLANATION_TEXT", nil);
        NSString *waterStageLevelText = stringFromStageLevel(self.waterStageLevel);
        NSString *actualStageLevelText = stringFromStageLevel(self.actualStageLevel);

        NSString *displayMessage = [NSString stringWithFormat:localizedText, actualStageLevelText, waterStageLevelText];

        CGRect restrictionRect = translatedRectOfView(self.stageRestrictionView);
        UIFont *font = [UIFont boldSystemFontOfSize:20.0f];
        CGFloat y = restrictionRect.origin.y + restrictionRect.size.height + margin;
        CGFloat width = self.frame.size.width - margin;
        CGRect boundingRect = [displayMessage boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName : font}
                                                           context:nil];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(margin * 0.5f,
                                                                   y,
                                                                   width,
                                                                   boundingRect.size.height)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = font;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.text = displayMessage;

        _infoLabel = label;
    }

    return _infoLabel;
}

#pragma mark - Actions

- (IBAction)didSelectDismissButton:(id)sender {
    if (self.completionHandler) {
        self.completionHandler();
    }
}

@end
