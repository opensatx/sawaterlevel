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
@property (strong, nonatomic) IBOutlet WKInterfaceButton *restrictionButton;
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

@property (nonatomic, strong) SAWDataController *dataController;

@end

@implementation SAWGlanceInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    self.dataController = [[SAWDataController alloc] init];

    [self.restrictionDescLabel setText:NSLocalizedString(@"CURRENT_RESTRICTIONS_TITLE", nil)];
    [self.currentLevelDescLabel setText:NSLocalizedString(@"CURRENT_LEVEL_TITLE", nil)];
    [self.averageLevelDescLabel setText:NSLocalizedString(@"CURRENT_AVERAGE_WATER_LEVEL", nil)];

    NSString *unitText = NSLocalizedString(@"CURRENT_LEVEL_FEET", nil);

    [self.currentLevelUnitLabel setText:unitText];
    [self.averageLevelUnitLabel setText:unitText];
}

- (void)willActivate {
    [super willActivate];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateUI];
    });
}

- (void)didDeactivate {
    [super didDeactivate];
}

- (void)updateUI {
    SAWWaterLevel *waterLevel = [self.dataController fetchCachedWaterLevel];

    if (waterLevel) {
        if (self.restrictionLabel) {
            [self.restrictionGroup setBackgroundColor:waterLevel.stageLevel.backgroundColor];
            [self.restrictionLabel setTextColor:waterLevel.stageLevel.foregroundColor];
            [self.restrictionLabel setText:waterLevel.stageLevel.localizedTitle];
        } else {
            NSString *titleStr = waterLevel.stageLevel.localizedTitle;
            
            NSDictionary *attributes = @{
                                         NSForegroundColorAttributeName : waterLevel.stageLevel.foregroundColor,
                                         NSFontAttributeName : [UIFont boldSystemFontOfSize:17.0f]
                                         };
            
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:titleStr attributes:attributes];
            //set color

            [self.restrictionButton setBackgroundColor:waterLevel.stageLevel.backgroundColor];
            [self.restrictionButton setAttributedTitle:attString];
        }
        
        

        SAWStageLevel *currentLevelStage = [SAWStageLevel stageLevelForLevelValue:[waterLevel.level floatValue]];
        SAWStageLevel *averageLevelStage = [SAWStageLevel stageLevelForLevelValue:[waterLevel.level floatValue]];

        [self.currentLevelIndicator setBackgroundColor:currentLevelStage.backgroundColor];
        [self.averageLevelIndicator setBackgroundColor:averageLevelStage.backgroundColor];

        NSString *levelFormat = @"%0.2f";

        [self.currentLevelLabel setText:[NSString stringWithFormat:levelFormat, [waterLevel.level floatValue]]];
        [self.averageLevelLabel setText:[NSString stringWithFormat:levelFormat, [waterLevel.average floatValue]]];

        [self.lastUpdatedLabel setText:[waterLevel.lastUpdated timeAgo]];
    }
}

@end



