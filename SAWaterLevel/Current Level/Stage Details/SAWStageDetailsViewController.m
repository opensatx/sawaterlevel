//
//  SAWStageDetailsViewController.m
//  SAWaterLevel
//
//  Created by Wayne Hartman on 5/31/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import "SAWStageDetailsViewController.h"
#import "SAWRestrictionModel.h"
#import "SAWStageLevel.h"
#import "SAWStageLevel+UI.h"

@interface SAWStageDetailsViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SAWStageDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.barTintColor = self.stageLevel.backgroundColor;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSForegroundColorAttributeName : self.stageLevel.foregroundColor
                                                                    };
    self.navigationController.navigationBar.tintColor = self.stageLevel.foregroundColor;
    self.webView.tintColor = self.navigationController.navigationBar.barTintColor;
    self.title = self.stageLevel.localizedTitle;

    [self.webView loadRequest:[NSURLRequest requestWithURL:self.stageLevel.contentURL]];
}

@end
