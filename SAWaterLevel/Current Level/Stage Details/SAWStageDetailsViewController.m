//
//  SAWStageDetailsViewController.m
//  SAWaterLevel
//
//  Created by Wayne Hartman on 5/31/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

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
