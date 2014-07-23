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
