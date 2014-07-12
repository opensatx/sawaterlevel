//
//  SAWHeaderView.m
//  SAWaterLevel
//
//  Created by Wayne Hartman on 5/31/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import "SAWHeaderView.h"

@interface SAWHeaderView ()

@property (nonatomic, strong) UIButton *infoButton;

@end

@implementation SAWHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithReuseIdentifier:reuseIdentifier])) {
        self.infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
        [self.infoButton addTarget:self action:@selector(didSelectInfoButton:) forControlEvents:UIControlEventTouchUpInside];
        self.infoButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.infoButton.superview == nil) {
        self.infoButton.center = CGPointMake(self.frame.size.width - (self.infoButton.frame.size.width * 0.5f) - 10.0f,
                                             (self.frame.size.height * 0.5f));
        self.infoButton.tintColor = [UIColor whiteColor];
        [self addSubview:self.infoButton];
    }
}

- (void)didSelectInfoButton:(id)sender {
    if (self.infoHandler) {
        self.infoHandler(self.indexPath);
    }
}

@end
