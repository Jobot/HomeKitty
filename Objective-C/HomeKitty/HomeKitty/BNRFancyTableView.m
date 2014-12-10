//
//  BNRFancyTableView.m
//  HomeKitty
//
//  Created by Joseph W. Dixon on 12/9/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "BNRFancyTableView.h"
#import "NSLayoutConstraint+BNRQuickConstraints.h"

@interface BNRFancyTableView() <UITableViewDelegate>

@property (nonatomic, weak) UIToolbar *toolbar;
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation BNRFancyTableView

#pragma mark - Initializers
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
        toolbar.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:toolbar];
        self.toolbar = toolbar;
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:style];
        tableView.delegate = self;
        tableView.translatesAutoresizingMaskIntoConstraints = NO;
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

- (void)reloadData {
    [self.tableView reloadData];
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectBlock) {
        self.didSelectBlock(indexPath);
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didDeselectBlock) {
        self.didDeselectBlock(indexPath);
    }
}

@end
