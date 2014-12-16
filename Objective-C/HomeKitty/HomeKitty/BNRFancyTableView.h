//
//  BNRFancyTableView.h
//  HomeKitty
//
//  Created by Joseph W. Dixon on 12/9/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BNRFancyTableSelectionBlock)(NSIndexPath *indexPath);

typedef NS_ENUM(NSUInteger, BNRFancyTableStyle) {
    BNRFancyTableStylePlain = 0,
    BNRFancyTableStyleRounded = 1
};

@interface BNRFancyTableView : UIView

@property (nonatomic, weak) id<UITableViewDataSource> dataSource;
@property (nonatomic, weak) id<UITableViewDelegate> delegate;
@property (nonatomic, strong) BNRFancyTableSelectionBlock didSelectBlock;
@property (nonatomic, strong) BNRFancyTableSelectionBlock didDeselectBlock;
@property (nonatomic, strong) BNRFancyTableSelectionBlock didTapAccessoryBlock;

#pragma mark - Initializers
- (instancetype)initWithFrame:(CGRect)frame style:(BNRFancyTableStyle)style;

#pragma mark - Toolbar
- (void)addToolbarItem:(UIBarButtonItem *)item;

#pragma mark - Table View
- (void)reloadData;
- (NSIndexPath *)indexPathForSelectedRow;

#pragma mark - Title
- (void)setTitle:(NSString *)title withTextAttributes:(NSDictionary *)attributes;

@end
