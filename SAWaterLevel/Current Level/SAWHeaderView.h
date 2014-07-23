//
//  SAWHeaderView.h
//  SAWaterLevel
//
//  Created by Wayne Hartman on 5/31/14.
//  Copyright (c) 2014 Wayne Hartman. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SAWHeaderViewInfoHandler)(NSIndexPath *indexPath);

/*!
 *  Used for the table view in the Current Level
 */
@interface SAWHeaderView : UITableViewHeaderFooterView

/*!
 *  Index path of the section in which the header is being used.  Used for implementers of the infoHandler know which info button was pressed
 */
@property (nonatomic, strong) NSIndexPath *indexPath;

/*!
 *  Block handler for executing logic for when the information button of the header is pressed.
 */
@property (nonatomic, copy) SAWHeaderViewInfoHandler infoHandler;

@end
