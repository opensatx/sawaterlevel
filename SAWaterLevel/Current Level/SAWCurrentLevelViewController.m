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
#import "SAWConstants.h"
#import "SAWStageDetailsViewController.h"
#import "TRModalTransition.h"

#define SEGUE_STAGE_DETAILS @"SCENE_STAGE_DETAILS"
#define SEGUE_REMINDERS     @"SEGUE_REMINDERS"
#define USER_DEFAULT_KEY    @"HOUSE_NUMBER"

@interface SAWCurrentLevelViewController () <UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SAWWaterLevel *currentWaterLevel;
@property (nonatomic, strong) NSArray *dataLevels;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *refreshButton;
@property (nonatomic, strong, readonly) IBOutlet UIBarButtonItem *activityButton;

- (NSIndexPath *)indexPathForCurrentLevel:(CGFloat)waterLevel;

@end

@implementation SAWCurrentLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"CURRENT_LEVEL_TITLE", nil);
    self.tabBarItem.title = NSLocalizedString(@"TAB_BAR_ITEM_CURRENT_LEVEL", nil);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (!self.currentWaterLevel) {
        [self fetchCurrentWaterLevel];
    }
}

- (UIBarButtonItem *)activityButton {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    
    return [[UIBarButtonItem alloc] initWithCustomView:spinner];
}

- (void)fetchCurrentWaterLevel {
    SAWWaterLevel *level = [[SAWWaterLevel alloc] init];
    level.level = @(640.5f);
    level.average = @(640.5);
    level.timestamp = [NSDate date];

    self.currentWaterLevel = level;
    self.currentIndexPath = [self indexPathForCurrentLevel:[level.level floatValue]];
    [self.tableView reloadRowsAtIndexPaths:@[self.currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView scrollToRowAtIndexPath:self.currentIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];

//    [self.navigationItem setRightBarButtonItem:self.activityButton animated:YES];
//
//    __weak typeof(self) weakSelf = self;
//    [[SAWNetworkController sharedNetworkController] fetchCurrentWaterLevelWithCompletion:^(SAWWaterLevel *waterLevel, NSError *error) {
//        
//        
//        if (error) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ALERT_CURRENT_LEVEL_FAIL_TITLE", nil)
//                                                            message:NSLocalizedString(@"ALERT_CURRENT_LEVEL_FAIL_MESSAGE", nil)
//                                                           delegate:nil
//                                                  cancelButtonTitle:NSLocalizedString(@"ALERT_CURRENT_LEVEL_FAIL_CANCEL_TITLE", nil)
//                                                  otherButtonTitles:nil];
//            [alert show];
//        } else {
//            weakSelf.currentWaterLevel = waterLevel;
//            weakSelf.currentIndexPath = [weakSelf indexPathForCurrentLevel:[waterLevel.level floatValue]];
//            [weakSelf.tableView reloadRowsAtIndexPaths:@[weakSelf.currentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
//            [weakSelf.tableView scrollToRowAtIndexPath:weakSelf.currentIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//        }
//        
//        [weakSelf.navigationItem setRightBarButtonItem:weakSelf.refreshButton animated:YES];
//    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SEGUE_REMINDERS]) {
        UIViewController *vc = segue.destinationViewController;
        vc.transitioningDelegate = self;
        
        if ([vc isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navController = segue.destinationViewController;
            UIViewController *topVC = navController.topViewController;
            topVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissViewController:)];
        }
    }
}

- (NSArray *)dataLevels {
    if (!_dataLevels) {
        NSMutableArray *sections = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < 6; i++) {
            NSInteger rowCount = 21;

            NSMutableArray *rows = [[NSMutableArray alloc] init];
            if (i == SAWStageLevel4) {
                rowCount = 11;
            }

            CGFloat sectionFootLevel = [self footStartingLevelForStageLevel:i] + 0.5f;
            for (int j = 0; j < rowCount; j++) {
                NSString *stringValue = @"";
                CGFloat level = sectionFootLevel - (1.0f * j * 0.5f);

                if (j % 2 != 0) {
                    stringValue = [NSString stringWithFormat:@"%g", level];
                }

                SAWLevelModel *model = [[SAWLevelModel alloc] init];
                model.displayLevel = stringValue;
                model.level = level;

                [rows addObject:model];
            }

            [sections addObject:rows];
        }

        _dataLevels = sections;
    }

    return _dataLevels;
}

- (NSIndexPath *)indexPathForCurrentLevel:(CGFloat)waterLevel {
    if (!self.currentWaterLevel) {
        return nil;
    }

    NSMutableArray *allRows = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.dataLevels.count; i++) {
        NSArray *rows = self.dataLevels[i];
        
        for (int j = 0; j < rows.count; j++) {
            [allRows addObject:rows[j]];
        }
    }

    NSIndexPath *indexPath = nil;

    CGFloat currentLevel = [self.currentWaterLevel.average floatValue];

    __block SAWLevelModel *model = nil;

    for (int i = 0; i < allRows.count; i++) {
        SAWLevelModel *currentModel = allRows[i];
        if (i + 1 < allRows.count) {
            SAWLevelModel *nextModel = allRows[i + 1];

            if (currentLevel < currentModel.level && currentLevel >= nextModel.level) {
                model = nextModel;
            }
        }
    }
    
    [allRows enumerateObjectsUsingBlock:^(SAWLevelModel *model, NSUInteger idx, BOOL *stop) {
        
    }];
    
    for (int i = 0; i < self.dataLevels.count; i++) {
        NSArray *rows = self.dataLevels[i];
        
        for (int j = 0; j < rows.count; j++) {
            if (rows[j] == model) {
                indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            }
        }
    }
    
    if (indexPath == nil) {
        indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }

    return indexPath;
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

#pragma mark - UITableViewDataSource

- (CGFloat)footStartingLevelForStageLevel:(SAWStageLevel)level {
    switch (level) {
        case SAWStageLevelNormal:
            return 669.0f;
        case SAWStageLevel1:
            return 659.0f;
        case SAWStageLevel2:
            return 649.0f;
        case SAWStageLevel3:
            return 639.0f;
        case SAWStageLevel4:
            return 629.0f;
        case SAWStageLevel5:
            return 624.0f;
    }
}

- (NSString *)sectionTitleForStageLevel:(SAWStageLevel)stageLevel {
    switch (stageLevel) {
        case SAWStageLevelNormal:
            return NSLocalizedString(@"STAGE_LEVEL_NO_RESTRICTION", nil);
        case SAWStageLevel1:
            return NSLocalizedString(@"STAGE_LEVEL_1", nil);
        case SAWStageLevel2:
            return NSLocalizedString(@"STAGE_LEVEL_2", nil);
        case SAWStageLevel3:
            return NSLocalizedString(@"STAGE_LEVEL_3", nil);
        case SAWStageLevel4:
            return NSLocalizedString(@"STAGE_LEVEL_4", nil);
        case SAWStageLevel5:
            return NSLocalizedString(@"STAGE_LEVEL_5", nil);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataLevels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *levelSection = self.dataLevels[section];
    return levelSection.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"LevelCell";
    static NSString *currentCellID = @"CurrentLevelCell";

    UITableViewCell *cell = nil;
    
    if ([indexPath isEqual:self.currentIndexPath]) {
        cell = [tableView dequeueReusableCellWithIdentifier:currentCellID forIndexPath:indexPath];
        cell.backgroundColor = [UIColor blackColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.text = [NSString stringWithFormat:@"%.2f %@ ← %@", [self.currentWaterLevel.average floatValue], NSLocalizedString(@"CURRENT_LEVEL_FEET", nil), NSLocalizedString(@"CURRENT_WATER_LEVEL_CELL", nil)];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        cell.backgroundColor = [SAWConstants colorForStageLevel:indexPath.section];
        cell.textLabel.textColor = [SAWConstants textColorForStageLevel:indexPath.section];
        
        NSArray *section = self.dataLevels[indexPath.section];
        SAWLevelModel *model = section[indexPath.row];

        cell.textLabel.text = model.displayLevel;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *headerID = @"LevelHeader";

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];

    SAWHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];

    if (!headerView) {
        headerView = [[SAWHeaderView alloc] initWithReuseIdentifier:headerID];
        UIView *backgroundView = [[UIView alloc] initWithFrame:headerView.bounds];
        headerView.backgroundView = backgroundView;
    }

    headerView.backgroundView.backgroundColor = [[SAWConstants colorForStageLevel:section] colorWithAlphaComponent:0.75f];
    headerView.textLabel.textColor = [SAWConstants textColorForStageLevel:indexPath.section];

    __weak typeof(self) weakSelf = self;
    __weak typeof(SAWHeaderView *) weakHeader = headerView;
    headerView.indexPath = indexPath;
    headerView.infoHandler = ^(NSIndexPath *idxPath) {
        UIStoryboard *storyboard = weakSelf.storyboard;
        UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:SEGUE_STAGE_DETAILS];
        navController.transitioningDelegate = weakSelf;

        SAWStageDetailsViewController *vc = (SAWStageDetailsViewController *)navController.topViewController;
        vc.title = weakHeader.textLabel.text;
        vc.stageLevel = idxPath.section;
        vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissViewController:)];

        [weakSelf presentViewController:navController animated:YES completion:NULL];
    };

    SAWStageLevel level = section;
    NSString *title = [self sectionTitleForStageLevel:level];
    headerView.textLabel.text = title;

    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 32.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentIndexPath && [self.currentIndexPath isEqual:indexPath]) {
        return 44.0f;
    } else {
        return 12.0f;
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

@end
