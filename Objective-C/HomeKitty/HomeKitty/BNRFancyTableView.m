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

@property (nonatomic, copy) NSString *title;
@property (nonatomic) NSDictionary *titleTextAttributes;
@property (nonatomic, weak) UIToolbar *toolbar;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic) NSMutableArray *toolbarItems;

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
        
        self.toolbarItems = [NSMutableArray array];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(toolbar, tableView);
        NSString *format = @"H:|[toolbar]|,H:|[tableView]|,V:|[toolbar(44)]-0-[tableView]|";
        [self addConstraints:[NSLayoutConstraint bnr_constraintsWithCommaDelimitedFormat:format views:views]];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame style:UITableViewStylePlain];
}

#pragma mark - Toolbar
- (void)addToolbarItem:(UIBarButtonItem *)item {
    [self.toolbarItems addObject:item];
    [self refreshToolbarItems];
}

- (void)refreshToolbarItems {
    NSMutableArray *items = [NSMutableArray array];
    if (self.title) {
        [items addObject:[self toolbarTitleItem]];
    }
    [items addObject:[self toolbarLeftSpaceItem]];
    [items addObjectsFromArray:self.toolbarItems];
    
    self.toolbar.items = items;
}

- (UIBarButtonItem *)toolbarTitleItem {
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithTitle:self.title style:UIBarButtonItemStylePlain target:nil action:nil];
    
    titleItem.enabled = NO;
    
    NSDictionary *textAttributes = self.titleTextAttributes ?: @{ NSForegroundColorAttributeName : [UIColor blackColor] };
    [titleItem setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
    return titleItem;
}

- (UIBarButtonItem *)toolbarLeftSpaceItem {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
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

#pragma mark - Title

- (void)setTitle:(NSString *)title withTextAttributes:(NSDictionary *)attributes {
    _title = [title copy];
    _titleTextAttributes = [attributes copy];
    [self refreshToolbarItems];
}

@end
