//
//  TRModalTransition.h
//  Receipts
//
//  Created by Wayne Hartman on 5/18/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TRModalTransitionType)  {
    TRModalTransitionTypePresenting = 0,
    TRModalTransitionTypeDismissing
};

@interface TRModalTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) TRModalTransitionType modalTransitionType;

@end
