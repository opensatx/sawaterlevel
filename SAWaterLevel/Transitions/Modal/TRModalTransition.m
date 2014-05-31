//
//  TRModalTransition.m
//  Receipts
//
//  Created by Wayne Hartman on 5/18/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import "TRModalTransition.h"

@implementation TRModalTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.7;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    // Grab the from and to view controllers from the context
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    BOOL isPresenting = self.modalTransitionType == TRModalTransitionTypePresenting;

    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.90f, 0.90f);
    CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(0.0f, isPresenting ? toViewController.view.frame.size.height : fromViewController.view.frame.size.height);

    UIView *shadowView = [[UIView alloc] initWithFrame:fromViewController.view.bounds];
    shadowView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];

    NSTimeInterval animationDuration = [self transitionDuration:transitionContext];
    NSTimeInterval animationDelay = 0.0;
    float springDamping = 0.8f;
    float springVelocity = 10.0f;
    UIViewAnimationOptions options = UIViewAnimationOptionCurveLinear;

    if (isPresenting) {
        shadowView.alpha = 0.0f;
        [fromViewController.view addSubview:shadowView];

        fromViewController.view.userInteractionEnabled = NO;

        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];

        toViewController.view.transform = translateTransform;

        [UIView animateWithDuration:animationDuration
                              delay:animationDelay
             usingSpringWithDamping:springDamping
              initialSpringVelocity:springVelocity
                            options:options
                         animations:^{
                             shadowView.alpha = 1.0f;
                             fromViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
                             fromViewController.view.transform = scaleTransform;
                             toViewController.view.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                             [shadowView removeFromSuperview];
                         }];
    } else {
        shadowView.alpha = 1.0f;
        animationDuration = 0.5;

        toViewController.view.userInteractionEnabled = YES;
        toViewController.view.transform = scaleTransform;
        [toViewController.view addSubview:shadowView];

        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];

        [UIView animateWithDuration:animationDuration
                              delay:animationDelay
             usingSpringWithDamping:springDamping
              initialSpringVelocity:springVelocity
                            options:options
                         animations:^{
                             toViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
                             toViewController.view.transform = CGAffineTransformIdentity;
                             fromViewController.view.transform = translateTransform;
                             shadowView.alpha = 0.0f;
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                             [shadowView removeFromSuperview];
                         }];
    }
}

@end
