//
//  SAWRemindersViewController.m
//  SAWaterLevel
//
//  Created by Wayne Hartman on 5/31/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import "SAWRemindersViewController.h"
#import "SAWDataController.h"
#import "SAWLocalNotificationManager.h"
#import "SAWWaterLevel.h"

@interface SAWRemindersViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UISwitch *wateringDaySwitch;
@property (strong, nonatomic) NSDate *nextIrrigationDate;
@property (strong, nonatomic) IBOutlet UILabel *nextIrrigationDayDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *myWateringDayLabel;

@end

@implementation SAWRemindersViewController

static NSDateFormatter *irrigationDateFormatter;

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActiveNotification:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    SAWDataController *dataController = [[SAWDataController alloc] init];

    NSString *houseNumber = [dataController fetchCachedHouseNumber];

    self.wateringDaySwitch.on = houseNumber != nil;
    
    SAWLocalNotificationManager *notificationManager = [SAWLocalNotificationManager localNotificationManager];
    UILocalNotification *nextNotification = [notificationManager nextNotification];
    self.nextIrrigationDate = nextNotification.fireDate;
    
    [self updateNextIrrigationDate];
    
    self.myWateringDayLabel.text = NSLocalizedString(@"MY_WATERING_DAY", nil);
}

- (NSDateFormatter *)dateFormatter {
    if (!irrigationDateFormatter) {
        irrigationDateFormatter = [[NSDateFormatter alloc] init];
        irrigationDateFormatter.dateStyle = NSDateFormatterLongStyle;
        irrigationDateFormatter.timeStyle = NSDateFormatterShortStyle;
    }
    
    return irrigationDateFormatter;
}

- (void)updateNextIrrigationDate {
    if (self.nextIrrigationDate) {
        NSString *formattedDate = [self.dateFormatter stringFromDate:self.nextIrrigationDate];
        self.nextIrrigationDayDateLabel.text = formattedDate;
    } else {
        self.nextIrrigationDayDateLabel.text = @"-";
    }
}

#pragma mark - Actions

- (IBAction)didToggleWateringDay:(id)sender {
    SAWDataController *dataController = [[SAWDataController alloc] init];

    if (self.wateringDaySwitch.on) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Watering Day Reminder" message:@"Enter your house number" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;

        UITextField *textField = [alert textFieldAtIndex:0];
        textField.keyboardAppearance = UIKeyboardAppearanceAlert;
        textField.keyboardType = UIKeyboardTypeNumberPad;

        [alert show];

        NSString *houseNumber = [dataController fetchCachedHouseNumber];
        
        if (houseNumber) {
            textField.text = houseNumber;
        }
    } else {
        [dataController cacheHouseNumber:nil];
        SAWLocalNotificationManager *notificationManager = [SAWLocalNotificationManager localNotificationManager];
        [notificationManager removeAllNotifications];

        self.nextIrrigationDate = nil;
        [self updateNextIrrigationDate];
    }
}

#pragma mark - Notifications

- (void)applicationDidBecomeActiveNotification:(NSNotification *)notification {
    [self updateNextIrrigationDate];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSString *houseNumber = nil;
    
    if (buttonIndex == 0) {
        [self.wateringDaySwitch setOn:NO animated:YES];
    } else {
        houseNumber = [[alertView textFieldAtIndex:0] text];
    }
    
    SAWDataController *dataController = [[SAWDataController alloc] init];
    [dataController cacheHouseNumber:houseNumber];
    
    SAWWaterLevel *waterLevel = [dataController fetchCachedWaterLevel];
    
    __weak typeof(self) weakSelf = self;

    if (houseNumber && waterLevel && waterLevel.stageLevel) {
        SAWLocalNotificationManager *notificationManager = [SAWLocalNotificationManager localNotificationManager];
        [notificationManager scheduleNotificationsForStageLevel:waterLevel.stageLevel streetNumber:houseNumber completion:^(NSArray *notifications) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UILocalNotification *notification = [notifications firstObject];
                weakSelf.nextIrrigationDate = notification.fireDate;
                [weakSelf updateNextIrrigationDate];
            });
        }];
    }
}

@end
