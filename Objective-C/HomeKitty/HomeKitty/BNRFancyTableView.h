//
//  BNRFancyTableView.h
//  HomeKitty
//
//  Created by Joseph W. Dixon on 12/9/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNRFancyTableView : UIView

@property (nonatomic, weak) id<UITableViewDataSource> dataSource;
@property (nonatomic, weak) id<UITableViewDelegate> delegate;

#pragma mark - Initializers
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

@end
