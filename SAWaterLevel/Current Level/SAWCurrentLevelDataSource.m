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

#import "SAWCurrentLevelDataSource.h"
#import "SAWWaterLevel.h"
#import "SAWLevelModel.h"
#import "SAWHeaderView.h"
#import "SAWStageLevel.h"
#import "SAWStageLevel+UI.h"

@interface SAWCurrentLevelDataSource ()

@property (nonatomic, strong) NSArray *dataLevels;
@property (nonatomic, strong) NSArray *stageLevels;

@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) NSIndexPath *averageIndexPath;

@end

@implementation SAWCurrentLevelDataSource

#pragma mark - Other Instance Methods

- (void)setWaterLevel:(SAWWaterLevel *)waterLevel {
    _waterLevel = waterLevel;

    if (waterLevel) {
        self.currentIndexPath = [self indexPathForLevel:[waterLevel.level floatValue]];
        self.averageIndexPath = [self indexPathForLevel:[waterLevel.average floatValue]];

        [self.tableView reloadData];

        NSIndexPath *lowestIndexPath = nil;

        if (self.currentIndexPath.section == self.averageIndexPath.section) {
            lowestIndexPath = [NSIndexPath indexPathForRow:MIN(self.currentIndexPath.row, self.averageIndexPath.row)
                                                 inSection:self.currentIndexPath.section];
        } else if (self.currentIndexPath.section > self.averageIndexPath.section) {
            lowestIndexPath = self.averageIndexPath;
        } else {
            lowestIndexPath = self.currentIndexPath;
        }

        [self.tableView scrollToRowAtIndexPath:lowestIndexPath
                              atScrollPosition:UITableViewScrollPositionMiddle
                                      animated:YES];
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

            CGFloat sectionFootLevel = [SAWStageLevel footStartingLevelForStageLevel:i] + 0.5f;
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

- (NSArray *)stageLevels {
    if (!_stageLevels) {
        NSArray *levels = @[@(SAWStageLevelNormal), @(SAWStageLevel1), @(SAWStageLevel2), @(SAWStageLevel3), @(SAWStageLevel4), @(SAWStageLevel5)];
        NSMutableArray *stageLevels = [NSMutableArray arrayWithCapacity:levels.count];

        for (NSNumber *level in levels) {
            SAWStageLevel *stagelevel = [[SAWStageLevel alloc] initWithStageLevel:[level integerValue]];
            [stageLevels addObject:stagelevel];
        }

        _stageLevels = [stageLevels copy];
    }

    return _stageLevels;
}

- (NSIndexPath *)indexPathForLevel:(CGFloat)waterLevel {
    if (!self.waterLevel) {
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

    SAWLevelModel *model = nil;

    for (int i = 0; i < allRows.count; i++) {
        SAWLevelModel *currentModel = allRows[i];
        if (i + 1 < allRows.count) {
            SAWLevelModel *nextModel = allRows[i + 1];
            
            if ((waterLevel < currentModel.level && waterLevel >= nextModel.level)) {
                model = nextModel;
            }
        }
    }
    
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

#pragma mark - UITableViewDataSource

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

    SAWStageLevel *stageLevel = self.stageLevels[indexPath.section];

    UITableViewCell *cell = nil;
    
    if ([indexPath isEqual:self.currentIndexPath]) {
        cell = [tableView dequeueReusableCellWithIdentifier:currentCellID forIndexPath:indexPath];
        cell.backgroundColor = [UIColor blackColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.text = [NSString stringWithFormat:@"%.2f %@ ← %@", [self.waterLevel.level floatValue], NSLocalizedString(@"CURRENT_LEVEL_FEET", nil), NSLocalizedString(@"CURRENT_WATER_LEVEL_CELL", nil)];
    } else if ([indexPath isEqual:self.averageIndexPath]) {
        cell = [tableView dequeueReusableCellWithIdentifier:currentCellID forIndexPath:indexPath];
        cell.backgroundColor = [UIColor blackColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.text = [NSString stringWithFormat:@"%.2f %@ ← %@", [self.waterLevel.average floatValue], NSLocalizedString(@"CURRENT_LEVEL_FEET", nil), NSLocalizedString(@"CURRENT_AVERAGE_WATER_LEVEL", nil)];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
        cell.backgroundColor = stageLevel.backgroundColor;
        cell.textLabel.textColor = stageLevel.foregroundColor;

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

    SAWStageLevel *stageLevel = self.stageLevels[indexPath.section];

    headerView.backgroundView.backgroundColor = [stageLevel.backgroundColor colorWithAlphaComponent:0.75f];
    headerView.textLabel.textColor = stageLevel.foregroundColor;
    headerView.textLabel.text = stageLevel.localizedTitle;
    headerView.indexPath = indexPath;
    headerView.infoHandler = ^(NSIndexPath *idxPath) {
        if (self.stageRestrictionInfoHandler) {
            self.stageRestrictionInfoHandler(stageLevel);
        }
    };

    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 32.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentIndexPath && [self.currentIndexPath isEqual:indexPath]) {
        return 44.0f;
    } else if (self.averageIndexPath && [self.averageIndexPath isEqual:indexPath]){
        return 44.0f;
    } else {
        return 12.0f;
    }
}

@end
