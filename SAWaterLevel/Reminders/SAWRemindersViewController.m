//
//  SAWRemindersViewController.m
//  SAWaterLevel
//
//  Created by Wayne Hartman on 5/31/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import "SAWRemindersViewController.h"

@interface SAWRemindersViewController () <UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UISwitch *wateringDaySwitch;
@property (strong, nonatomic) NSString *houseNumber;

@end

@implementation SAWRemindersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Actions


- (IBAction)didToggleWateringDay:(id)sender {
    if (self.wateringDaySwitch.on) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Watering Day Reminder" message:@"Enter your house number" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        UITextField *textField = [alert textFieldAtIndex:0];
        textField.keyboardAppearance = UIKeyboardAppearanceAlert;
        textField.keyboardType = UIKeyboardTypeNumberPad;

        [alert show];

        if (self.houseNumber) {
            textField.text = self.houseNumber;
        }
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.wateringDaySwitch setOn:NO animated:YES];
    } else {
        self.houseNumber = [[alertView textFieldAtIndex:0] text];
    }
}

@end
