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

#import "SAWCurrentLevelViewController.h"
#import "SAWNetworkController.h"
#import "SAWLevelModel.h"
#import "SAWHeaderView.h"
#import "SAWStageDetailsViewController.h"
#import "SAWDataController.h"
#import "SAWStageLevel+UI.h"
#import "SAWCurrentLevelDataSource.h"
#import "SAWConstants.h"
#import "SAWStageLevelDescrepencyEducationView.h"

#import "TRModalTransition.h"
#import "UIStoryboardSegue+TargetDestination.h"

#define SEGUE_STAGE_DETAILS @"SEGUE_STAGE_DETAILS"
#define SEGUE_REMINDERS     @"SEGUE_REMINDERS"
#define USER_DEFAULT_KEY    @"HOUSE_NUMBER"

@interface SAWCurrentLevelViewController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) IBOutlet UIButton *stageLevelInfoButton;

@property (nonatomic, strong, readonly) IBOutlet UIBarButtonItem *activityButton;
@property (nonatomic, strong) IBOutlet SAWCurrentLevelDataSource *dataSource;

@property (strong, nonatomic) IBOutlet UIButton *currentStageButton;

@end

@implementation SAWCurrentLevelViewController

#pragma mark - View Lifecycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(waterLevelDidUpdateFromBackground:)
                                                     name:SAWWaterLevelDidUpdateFromBackgroundNotification
                                                   object:nil];
    }

    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.navigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"levelsSelected"];
}

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
            NSLog(@"error fetching level: %@", error);
        } else {
            weakSelf.dataSource.waterLevel = waterLevel;
            [weakSelf updateStageLevelDisplay:waterLevel.stageLevel animated:YES];
            [weakSelf displayEducationView];
        }

        [weakSelf.navigationItem setLeftBarButtonItem:weakSelf.refreshButton animated:YES];
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

#pragma mark - Education

- (void)displayEducationView {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    //  Check to see if they've been shown this before
    if ([defaults boolForKey:SAWUserInfoKeyHasBeenShownStageDescrepency]) {
        return;
    }

    UIView *titleView = self.stageLevelInfoButton;

    if (titleView) {
        static NSTimeInterval animationDuration = 0.33;

        SAWStageLevelDescrepencyEducationView *educationView = [[SAWStageLevelDescrepencyEducationView alloc] initWithFrame:self.tabBarController.view.bounds currentStageRestrictionView:titleView];
        educationView.autoresizingMask = ~UIViewAutoresizingNone;
        educationView.translatesAutoresizingMaskIntoConstraints = YES;
        educationView.alpha = 0.0f;
        educationView.actualStageLevel = self.dataSource.waterLevel.stageLevel.level;
        educationView.waterStageLevel = [SAWStageLevel stageLevelForWaterLevel:self.dataSource.waterLevel].level;

        __weak typeof(educationView) weakEductionView = educationView;

        educationView.completionHandler = ^{
            [UIView animateWithDuration:animationDuration
                             animations:^{
                                 weakEductionView.alpha = 0.0f;
                             }
                             completion:^(BOOL finished) {
                                 [weakEductionView removeFromSuperview];
                             }];
        };

        [self.view.window addSubview:educationView];

        [UIView animateWithDuration:animationDuration
                         animations:^{
                             weakEductionView.alpha = 1.0f;
                         } completion:^(BOOL finished) {
                             [defaults setBool:YES forKey:SAWUserInfoKeyHasBeenShownStageDescrepency];
                             [defaults synchronize];
                         }];
    }
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

#pragma mark - Notifications

- (void)waterLevelDidUpdateFromBackground:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    SAWWaterLevel *waterLevel = userInfo[SAWNotificationKeyWaterLevel];

    if (waterLevel) {
        self.dataSource.waterLevel = waterLevel;
        [self updateStageLevelDisplay:waterLevel.stageLevel animated:YES];
    }
}

#pragma mark - Memory

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
