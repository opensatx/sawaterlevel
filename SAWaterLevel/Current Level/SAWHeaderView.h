//
//  SAWHeaderView.h
//  SAWaterLevel
//
//  Created by Wayne Hartman on 5/31/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SAWHeaderViewInfoHandler)(NSIndexPath *indexPath);

@interface SAWHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) SAWHeaderViewInfoHandler infoHandler;

@end
