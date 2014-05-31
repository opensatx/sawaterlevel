//
//  SAWStageDetailsViewController.m
//  SAWaterLevel
//
//  Created by Wayne Hartman on 5/31/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import "SAWStageDetailsViewController.h"
#import "SAWRestrictionModel.h"

@interface SAWStageDetailsViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SAWStageDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.barTintColor = [SAWConstants colorForStageLevel:self.stageLevel];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSForegroundColorAttributeName : [SAWConstants textColorForStageLevel:self.stageLevel]
                                                                    };
    self.navigationController.navigationBar.tintColor = [SAWConstants textColorForStageLevel:self.stageLevel];

    NSDictionary *contentDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Restrictions" ofType:@"plist"]];
    NSString *fileName = contentDict[[NSString stringWithFormat:@"%li", (long)self.stageLevel]];

    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@""];
    NSURL *url = [NSURL fileURLWithPath:path];

    self.webView.tintColor = self.navigationController.navigationBar.barTintColor;
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
