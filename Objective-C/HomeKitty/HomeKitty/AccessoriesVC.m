//
//  AccessoriesVC.m
//  HomeKitty
//
//  Created by Joseph W. Dixon on 12/10/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "AccessoriesVC.h"
#import "AccessoriesInRoomDataSource.h"
#import "UnassignedAccessoriesDataSource.h"
#import "BNRFancyTableView.h"
#import "NSLayoutConstraint+BNRQuickConstraints.h"
@import HomeKit;

@interface AccessoriesVC ()

@property (nonatomic) HMHome *home;
@property (nonatomic) HMRoom *room;
@property (nonatomic, weak) BNRFancyTableView *assignedList;
@property (nonatomic, weak) BNRFancyTableView *unassignedList;
@property (nonatomic) AccessoriesInRoomDataSource *assignedDataSource;
@property (nonatomic) UnassignedAccessoriesDataSource *unassignedDataSource;
@property (nonatomic) id<NSObject> unassignedAccessoriesChangeObserver;
@property (nonatomic, weak) UIBarButtonItem *assignToRoomButton;
@end

@implementation AccessoriesVC

#pragma mark - Initializers

- (instancetype)init {
    return [super initWithNibName:nil bundle:nil];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    NSAssert(NO, @"Use the no argument -init method instead");
    return nil;
}

#pragma mark - View Lifecycle

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    
    BNRFancyTableView *assignedList = [[BNRFancyTableView alloc] initWithFrame:CGRectZero];
    [view addSubview:assignedList];
    self.assignedList = assignedList;
    
    BNRFancyTableView *unassignedList = [[BNRFancyTableView alloc] initWithFrame:CGRectZero];
    [view addSubview:unassignedList];
    self.unassignedList = unassignedList;
    
    [self setView:view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Accessories";
    
    // configure data sources
    self.assignedDataSource = [[AccessoriesInRoomDataSource alloc] init];
    [self.assignedDataSource setRoom:self.room inHome:self.home];
    self.unassignedDataSource = [[UnassignedAccessoriesDataSource alloc] init];
    
    // configure assigned list
    BNRFancyTableView *assignedList = self.assignedList;
    assignedList.dataSource = self.assignedDataSource;
    assignedList.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *title = @"Please select a room";
    UIColor *color = [UIColor grayColor];
    if (self.room.name) {
        title = [NSString stringWithFormat:@"Assigned to %@", self.room.name];
        color = [UIColor blackColor];
    }
    NSDictionary *attributes = @{ NSForegroundColorAttributeName : color };
    [assignedList setTitle:title withTextAttributes:attributes];
    
    // configure unassigned list
    BNRFancyTableView *unassignedList = self.unassignedList;
    unassignedList.dataSource = self.unassignedDataSource;
    unassignedList.translatesAutoresizingMaskIntoConstraints = NO;
    [unassignedList setTitle:@"Unassigned" withTextAttributes:nil];
    UIBarButtonItem *assignButton = [[UIBarButtonItem alloc] initWithTitle:@"Assign to Room"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(didPressAssignButton:)];
    assignButton.enabled = NO;
    [unassignedList addToolbarItem:assignButton];
    self.assignToRoomButton = assignButton;
    
    // add constraints
    UINavigationBar *navBar = self.navigationController.navigationBar;
    NSNumber *hPad = @12;
    NSNumber *vPad = @12;
    NSNumber *navPad = @(navBar.frame.origin.y + navBar.frame.size.height + [vPad floatValue]);
    
    NSString *format = [NSString stringWithFormat:@"H:|-%@-[assignedList]-%@-|,H:|-%@-[unassignedList]-%@-|,V:|-%@-[assignedList]-%@-[unassignedList(==assignedList)]-%@-|", hPad, hPad, hPad, hPad, navPad, vPad, vPad];
    NSDictionary *views = NSDictionaryOfVariableBindings(assignedList, unassignedList);
    [self.view addConstraints:[NSLayoutConstraint bnr_constraintsWithCommaDelimitedFormat:format views:views]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    __weak __typeof(self) weakSelf = self;
    
    NSNotificationCenter *notary = [NSNotificationCenter defaultCenter];
    self.unassignedAccessoriesChangeObserver = [notary addObserverForName:UnassignedAccessoriesDataSourceDidChangeNotification
                                                                   object:nil
                                                                    queue:[NSOperationQueue mainQueue]
                                                               usingBlock:^(NSNotification *note) {
                                                                   [weakSelf.unassignedList reloadData];
                                                               }];
    self.unassignedList.didSelectBlock = ^(NSIndexPath *indexPath) {
        self.assignToRoomButton.enabled = YES;
    };
    
    self.unassignedList.didDeselectBlock = ^(NSIndexPath *indexPath) {
        self.assignToRoomButton.enabled = NO;
    };
    
    [self.unassignedList reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.unassignedAccessoriesChangeObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.unassignedAccessoriesChangeObserver];
    }
}

#pragma mark - Room Management

- (void)setRoom:(HMRoom *)room inHome:(HMHome *)home {
    self.room = room;
    self.home = home;
}

#pragma mark - Actions

- (void)didPressAssignButton:(id)sender {
    __weak __typeof(self) weakSelf = self;
    
    NSIndexPath *indexPath = self.unassignedList.indexPathForSelectedRow;
    HMAccessory *accessory = [self.unassignedDataSource accessoryForRow:indexPath.row];
    [self.home addAccessory:accessory completionHandler:^(NSError *error) {
        if (!error) {
            [weakSelf.home assignAccessory:accessory toRoom:weakSelf.room completionHandler:^(NSError *error) {
                [weakSelf.assignedList reloadData];
                [weakSelf.unassignedList reloadData];
            }];
        }
    }];
}

@end
