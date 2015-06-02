//
//  SAWGlanceInterfaceController.m
//  SAWaterLevel
//
//  Created by Wayne Hartman on 6/1/15.
//  Copyright (c) 2015 Wayne Hartman. All rights reserved.
//

#import "SAWGlanceInterfaceController.h"
@import SAWaterLevelCommon;

@interface SAWGlanceInterfaceController ()

@property (strong, nonatomic) IBOutlet WKInterfaceGroup *restrictionGroup;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *restrictionLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *restrictionDescLabel;

@property (strong, nonatomic) IBOutlet WKInterfaceGroup *currentLevelIndicator;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *currentLevelLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *currentLevelUnitLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *currentLevelDescLabel;

@property (strong, nonatomic) IBOutlet WKInterfaceGroup *averageLevelIndicator;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *averageLevelLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *averageLevelUnitLabel;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *averageLevelDescLabel;

@property (strong, nonatomic) IBOutlet WKInterfaceLabel *lastUpdatedLabel;

@property (nonatomic, strong) SAWWaterLevel *waterLevel;

@end

@implementation SAWGlanceInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    [self updateUI];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)updateUI {
    if (self.waterLevel) {
        [self.restrictionGroup setBackgroundColor:self.waterLevel.stageLevel.backgroundColor];
        [self.restrictionLabel setTextColor:self.waterLevel.stageLevel.foregroundColor];
        [self.restrictionLabel setText:self.waterLevel.stageLevel.localizedTitle];
        [self.restrictionDescLabel setText:NSLocalizedString(@"CURRENT_RESTRICTIONS_TITLE", nil)];

        SAWStageLevel *currentLevelStage = [SAWStageLevel stageLevelForLevelValue:[self.waterLevel.level floatValue]];
        SAWStageLevel *averageLevelStage = [SAWStageLevel stageLevelForLevelValue:[self.waterLevel.level floatValue]];

        [self.currentLevelIndicator setBackgroundColor:currentLevelStage.backgroundColor];
        [self.averageLevelIndicator setBackgroundColor:averageLevelStage.backgroundColor];

        NSString *levelFormat = @"%0.2f";

        [self.currentLevelLabel setText:[NSString stringWithFormat:levelFormat, [self.waterLevel.level floatValue]]];
        [self.averageLevelLabel setText:[NSString stringWithFormat:levelFormat, [self.waterLevel.average floatValue]]];

        NSString *unitText = NSLocalizedString(@"CURRENT_LEVEL_FEET", nil);

        [self.currentLevelUnitLabel setText:unitText];
        [self.averageLevelUnitLabel setText:unitText];

        [self.currentLevelDescLabel setText:NSLocalizedString(@"CURRENT_LEVEL_TITLE", nil)];
        [self.averageLevelDescLabel setText:NSLocalizedString(@"CURRENT_AVERAGE_WATER_LEVEL", nil)];

        static NSDateFormatter *dateFormatter = nil;

        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateStyle = NSDateFormatterShortStyle;
            dateFormatter.timeStyle = NSDateFormatterShortStyle;
        });

        [self.lastUpdatedLabel setText:[dateFormatter stringFromDate:self.waterLevel.lastUpdated]];
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



