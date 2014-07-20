//
//  SAWCurrentLevelViewController.m
//  SAWaterLevel
//
//  Created by Wayne Hartman on 5/31/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import "SAWCurrentLevelViewController.h"
#import "SAWNetworkController.h"
#import "SAWLevelModel.h"
#import "SAWHeaderView.h"
#import "SAWStageDetailsViewController.h"
#import "SAWDataController.h"
#import "SAWStageLevel+UI.h"
#import "SAWCurrentLevelDataSource.h"

#import "TRModalTransition.h"
#import "UIStoryboardSegue+TargetDestination.h"

#define SEGUE_STAGE_DETAILS @"SEGUE_STAGE_DETAILS"
#define SEGUE_REMINDERS     @"SEGUE_REMINDERS"
#define USER_DEFAULT_KEY    @"HOUSE_NUMBER"

@interface SAWCurrentLevelViewController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *stageLevelInfoButton;

@property (nonatomic, strong, readonly) IBOutlet UIBarButtonItem *activityButton;
@property (nonatomic, strong) IBOutlet SAWCurrentLevelDataSource *dataSource;

@property (strong, nonatomic) IBOutlet UIButton *currentStageButton;

@end

@implementation SAWCurrentLevelViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"CURRENT_LEVEL_TITLE", nil);
    self.tabBarItem.title = NSLocalizedString(@"TAB_BAR_ITEM_CURRENT_LEVEL", nil);

    SAWDataController *dataController = [[SAWDataController alloc] init];

    __weak typeof(self) weakSelf = self;
    self.dataSource.stageRestrictionInfoHandler = ^(SAWStageLevel *stageLevel) {
        [weakSelf performSegueWithIdentifier:SEGUE_STAGE_DETAILS sender:stageLevel];
    };

    SAWWaterLevel *waterLevel = [dataController fetchCachedWaterLevel];

    if (waterLevel) {
        self.navigationItem.prompt = NSLocalizedString(@"CURRENT_RESTRICTIONS_TITLE", nil);
        self.dataSource.waterLevel = waterLevel;
        [self updateStageLevelDisplay:waterLevel.stageLevel animated:NO];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
        self.currentStageButton.hidden = YES;
    }

    [self fetchCurrentWaterLevel];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Other instance methods

- (void)updateStageLevelDisplay:(SAWStageLevel *)stageLevel animated:(BOOL)animated {
    if (!self.navigationItem.rightBarButtonItem) {
        [self.navigationItem setRightBarButtonItem:self.stageLevelInfoButton animated:YES];
    }

    self.currentStageButton.hidden = NO;

    [self.currentStageButton setTitle:stageLevel.localizedTitle forState:UIControlStateNormal];
    self.currentStageButton.tintColor = stageLevel.foregroundColor;
    self.currentStageButton.backgroundColor = stageLevel.backgroundColor;
    self.currentStageButton.layer.cornerRadius = 10.0f;
    self.currentStageButton.layer.borderWidth = 0.5f;
    self.currentStageButton.layer.borderColor = [UIColor colorWithWhite:0.0f alpha:0.5f].CGColor;
}

- (UIBarButtonItem *)activityButton {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    
    return [[UIBarButtonItem alloc] initWithCustomView:spinner];
}

- (void)fetchCurrentWaterLevel {
    [self.navigationItem setLeftBarButtonItem:self.activityButton animated:YES];

    __weak typeof(self) weakSelf = self;
    [[SAWNetworkController sharedNetworkController] fetchCurrentWaterLevelWithCompletion:^(SAWWaterLevel *waterLevel, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ALERT_CURRENT_LEVEL_FAIL_TITLE", nil)
                                                            message:NSLocalizedString(@"ALERT_CURRENT_LEVEL_FAIL_MESSAGE", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"ALERT_CURRENT_LEVEL_FAIL_CANCEL_TITLE", nil)
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            weakSelf.dataSource.waterLevel = waterLevel;
        }

        [weakSelf.navigationItem setLeftBarButtonItem:weakSelf.refreshButton animated:YES];
        [weakSelf updateStageLevelDisplay:waterLevel.stageLevel animated:YES];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *destinationController = segue.destinationViewController;
    destinationController.transitioningDelegate = self;

    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = segue.destinationViewController;
        UIViewController *topVC = navController.topViewController;
        topVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissViewController:)];
    }

    if ([segue.identifier isEqualToString:SEGUE_REMINDERS]) {
        UIViewController *vc = segue.destinationViewController;
        vc.transitioningDelegate = self;
    } else if ([segue.identifier isEqualToString:SEGUE_STAGE_DETAILS]) {
        SAWStageDetailsViewController *vc = segue.targetDestinationController;
        vc.stageLevel = sender;
    }
}

- (void)dismissViewController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Actions

- (IBAction)didSelectRemindersButton:(id)sender {
    [self performSegueWithIdentifier:SEGUE_REMINDERS sender:nil];
}
- (IBAction)didSelectRefresh:(id)sender {
    [self fetchCurrentWaterLevel];
}

- (IBAction)didSelectCurrentStageLevelInfoButton:(id)sender {
    [self performSegueWithIdentifier:SEGUE_STAGE_DETAILS sender:self.dataSource.waterLevel.stageLevel];
}

#pragma - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    TRModalTransition *animator = [[TRModalTransition alloc] init];
    animator.modalTransitionType = TRModalTransitionTypePresenting;
    
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    TRModalTransition *animator = [[TRModalTransition alloc] init];
    animator.modalTransitionType = TRModalTransitionTypeDismissing;
    
    return animator;
}

@end
