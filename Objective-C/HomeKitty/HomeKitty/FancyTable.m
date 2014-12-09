//
//  FancyTable.m
//  HomeKitty
//
//  Created by Joseph W. Dixon on 12/9/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "FancyTable.h"
#import "NSLayoutConstraint+BNRQuickConstraints.h"

@interface FancyTable()

@property (nonatomic, weak) UIToolbar *toolbar;
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation FancyTable

#pragma mark - Initializers
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame];
    if (self) {
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
        [self addSubview:toolbar];
        self.toolbar = toolbar;
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:style];
        [self addSubview:tableView];
        self.tableView = tableView;
        
        NSDictionary *views = NSDictionaryOfVariableBindings(toolbar, tableView);
        NSString *format = @"H:|[toolbar]|,H:|[tableView]|,V:|[toolbar(44)]-0-[tableView]|";
        [self addConstraints:[NSLayoutConstraint bnr_constraintsWithCommaDelimitedFormat:format views:views]];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame style:UITableViewStylePlain];
}

#pragma mark - Table View
- (void)setDataSource:(id<UITableViewDataSource>)dataSource {
    [self.tableView setDataSource:dataSource];
}

- (id<UITableViewDataSource>)dataSource {
    return self.tableView.dataSource;
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate {
    [self.tableView setDelegate:delegate];
}

- (id<UITableViewDelegate>)delegate {
    return self.tableView.delegate;
}

@end
