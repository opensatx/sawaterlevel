//
//  TodayViewController.m
//  SAWaterTodayWidget
//
//  Created by Wayne Hartman on 5/31/15.
//  Copyright (c) 2015 Wayne Hartman. All rights reserved.
//

#import "TodayViewController.h"

@import NotificationCenter;
@import SAWaterLevelCommon;

@interface TodayViewController () <NCWidgetProviding>

@property (strong, nonatomic) IBOutlet UIView *infoPanel;
@property (strong, nonatomic) IBOutlet UILabel *currentLevelAmount;
@property (strong, nonatomic) IBOutlet UILabel *currentLevelDesc;
@property (strong, nonatomic) IBOutlet UILabel *averageAmount;
@property (strong, nonatomic) IBOutlet UILabel *averageDesc;
@property (strong, nonatomic) IBOutlet UILabel *lastUpdatedLabel;
@property (strong, nonatomic) IBOutlet UIView *stageLevelContainer;
@property (strong, nonatomic) IBOutlet UILabel *stageLevelLabel;

@property (strong, nonatomic) SAWWaterLevel *waterLevel;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self updateUI];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateFromNetworkWithUpdateHandler:NULL];
    });
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    [self updateFromNetworkWithUpdateHandler:completionHandler];
}

- (CGSize)preferredContentSize {
    return CGSizeMake(320.0f, 100.0f);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsZero;
}

#pragma mark - Instance Methods

- (void)updateFromNetworkWithUpdateHandler:(void (^)(NCUpdateResult))completionHandler {
    __weak typeof(self) weakSelf = self;

    [[SAWNetworkController sharedNetworkController] fetchCurrentWaterLevelWithCompletion:^(SAWWaterLevel *waterLevel, NSError *error) {
        if (waterLevel) {
            weakSelf.waterLevel = waterLevel;
            [self updateUI];

            if (completionHandler) {
                completionHandler(NCUpdateResultNewData);
            }
            
            [self updateUI];
        } else {
            if (completionHandler) {
                completionHandler(NCUpdateResultNoData);
            }
        }
    }];
}

- (void)updateUI {
    static NSDateFormatter *dateFormatter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
    });

    if (self.waterLevel) {
        SAWStageLevel *currentLevelStageLevel = [SAWStageLevel stageLevelForWaterLevel:self.waterLevel];

        self.stageLevelContainer.layer.borderWidth = 3.0f;
        self.stageLevelContainer.layer.borderColor = currentLevelStageLevel.backgroundColor.CGColor;

        self.infoPanel.hidden = NO;
        self.currentLevelAmount.text = [NSString stringWithFormat:@"%.2f %@", [self.waterLevel.level floatValue], NSLocalizedString(@"CURRENT_LEVEL_FEET", nil)];
        self.averageAmount.text = [NSString stringWithFormat:@"%.2f %@", [self.waterLevel.average floatValue], NSLocalizedString(@"CURRENT_LEVEL_FEET", nil)];
        self.currentLevelDesc.text = NSLocalizedString(@"CURRENT_LEVEL_TITLE", nil);
        self.averageDesc.text = NSLocalizedString(@"CURRENT_AVERAGE_WATER_LEVEL", nil);
        
        self.stageLevelContainer.layer.cornerRadius = self.stageLevelContainer.frame.size.height * 0.5f;
        self.stageLevelContainer.backgroundColor = self.waterLevel.stageLevel.backgroundColor;
        
        self.stageLevelLabel.textColor = self.waterLevel.stageLevel.foregroundColor;
        self.stageLevelLabel.text = [NSString stringWithFormat:@"%li", (long)self.waterLevel.stageLevel.level];
        
        self.lastUpdatedLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"CURRENT_LEVEL_LAST_UPDATED", nil), [dateFormatter stringFromDate:self.waterLevel.lastUpdated]];
    } else {
        self.infoPanel.hidden = YES;
    }
}

- (SAWWaterLevel *)waterLevel {
    if (!_waterLevel) {
        SAWDataController *dataController = [[SAWDataController alloc] init];
        _waterLevel = [dataController fetchCachedWaterLevel];
    }

    return _waterLevel;
}

@end
