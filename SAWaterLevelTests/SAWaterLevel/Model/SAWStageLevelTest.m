//
//  SAWStageLevelTest.m
//  SAWaterLevel
//
//  Created by Wayne Hartman on 7/12/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SAWStageLevel.h"
#import "SAWWaterLevel.h"

@interface SAWStageLevelTest : XCTestCase

@end

@implementation SAWStageLevelTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

#pragma mark - Creation Methods From Water Level

- (void)testCreationFromWaterLevelHappyPath {
    SAWWaterLevel *waterLevel = [[SAWWaterLevel alloc] init];
    waterLevel.level = @(669.0);
    waterLevel.average = @(669.0);

    SAWStageLevel *stageLevel = [SAWStageLevel stageLevelForWaterLevel:waterLevel];
    XCTAssertEqual(stageLevel.level, SAWStageLevelNormal);

    waterLevel.level = @(659.0);
    waterLevel.average = @(659.0);
    stageLevel = [SAWStageLevel stageLevelForWaterLevel:waterLevel];
    XCTAssertEqual(stageLevel.level, SAWStageLevel1);

    waterLevel.level = @(649.0);
    waterLevel.average = @(649.0);
    stageLevel = [SAWStageLevel stageLevelForWaterLevel:waterLevel];
    XCTAssertEqual(stageLevel.level, SAWStageLevel2);

    waterLevel.level = @(639.0);
    waterLevel.average = @(639.0);
    stageLevel = [SAWStageLevel stageLevelForWaterLevel:waterLevel];
    XCTAssertEqual(stageLevel.level, SAWStageLevel3);

    waterLevel.level = @(629.0);
    waterLevel.average = @(629.0);
    stageLevel = [SAWStageLevel stageLevelForWaterLevel:waterLevel];
    XCTAssertEqual(stageLevel.level, SAWStageLevel4);

    waterLevel.level = @(624.0);
    waterLevel.average = @(624.0);
    stageLevel = [SAWStageLevel stageLevelForWaterLevel:waterLevel];
    XCTAssertEqual(stageLevel.level, SAWStageLevel5);
}

- (void)testCreationEdgeCases {
    SAWWaterLevel *waterLevel = [[SAWWaterLevel alloc] init];
    waterLevel.level = @(0.0);
    waterLevel.average = @(0.0);
    
    SAWStageLevel *stageLevel = [SAWStageLevel stageLevelForWaterLevel:waterLevel];
    XCTAssertEqual(stageLevel.level, SAWStageLevel5);
    
    waterLevel.level = @(680.0);
    waterLevel.average = @(680.0);
    stageLevel = [SAWStageLevel stageLevelForWaterLevel:waterLevel];
    XCTAssertEqual(stageLevel.level, SAWStageLevelNormal);
    
    waterLevel.level = @(-1000);
    waterLevel.average = @(-1000);
    stageLevel = [SAWStageLevel stageLevelForWaterLevel:waterLevel];
    XCTAssertEqual(stageLevel.level, SAWStageLevel5);
}

- (void)testCreationUnhappyPath {
    SAWStageLevel *stageLevel = [SAWStageLevel stageLevelForWaterLevel:nil];
    XCTAssertNil(stageLevel);
}

@end
