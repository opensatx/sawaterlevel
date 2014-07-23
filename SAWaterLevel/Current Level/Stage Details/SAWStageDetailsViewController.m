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

#import "SAWStageDetailsViewController.h"
#import "SAWStageLevel.h"
#import "SAWStageLevel+UI.h"

@interface SAWStageDetailsViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SAWStageDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIColor *titleColor = self.stageLevel.foregroundColor ?: [UIColor whiteColor];

    self.navigationController.navigationBar.barTintColor = self.stageLevel.backgroundColor;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSForegroundColorAttributeName : titleColor
                                                                    };
    self.navigationController.navigationBar.tintColor = self.stageLevel.foregroundColor;
    self.webView.tintColor = self.navigationController.navigationBar.barTintColor;
    self.title = self.stageLevel.localizedTitle;

    [self.webView loadRequest:[NSURLRequest requestWithURL:self.stageLevel.localizedContentURL]];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([request.URL.scheme isEqualToString:@"http"]) {
        [[UIApplication sharedApplication] openURL:request.URL];

        return NO;
    }
    
    return YES;
}
@end
