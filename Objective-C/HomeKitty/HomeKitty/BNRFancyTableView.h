//
//  BNRFancyTableView.h
//  HomeKitty
//
//  Created by Joseph W. Dixon on 12/9/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BNRFancyTableSelectionBlock)(NSIndexPath *indexPath);

@interface BNRFancyTableView : UIView

@property (nonatomic, weak) id<UITableViewDataSource> dataSource;
@property (nonatomic, weak) id<UITableViewDelegate> delegate;
@property (nonatomic, strong) BNRFancyTableSelectionBlock didSelectBlock;
@property (nonatomic, strong) BNRFancyTableSelectionBlock didDeselectBlock;

#pragma mark - Initializers
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

#pragma mark - Toolbar
- (void)addToolbarItem:(UIBarButtonItem *)item;

#pragma mark - Table View
- (void)reloadData;

@end
