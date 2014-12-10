//
//  AccessoriesVC.m
//  HomeKitty
//
//  Created by Joseph W. Dixon on 12/10/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "AccessoriesVC.h"
#import "BNRFancyTableView.h"
#import "NSLayoutConstraint+BNRQuickConstraints.h"

@interface AccessoriesVC ()

@property (nonatomic, weak) BNRFancyTableView *assignedList;
@property (nonatomic, weak) BNRFancyTableView *unassignedList;

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
    
    // configure assigned list
    BNRFancyTableView *assignedList = self.assignedList;
    assignedList.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *attributes = @{ NSForegroundColorAttributeName : [UIColor grayColor] };
    [assignedList setTitle:@"Please select a room" withTextAttributes:attributes];
    
    // configure unassigned list
    BNRFancyTableView *unassignedList = self.unassignedList;
    unassignedList.translatesAutoresizingMaskIntoConstraints = NO;
    [unassignedList setTitle:@"Available Acessories" withTextAttributes:nil];
    
    // add constraints
    UINavigationBar *navBar = self.navigationController.navigationBar;
    NSNumber *hPad = @12;
    NSNumber *vPad = @12;
    NSNumber *navPad = @(navBar.frame.origin.y + navBar.frame.size.height + [vPad floatValue]);
    
    NSString *format = [NSString stringWithFormat:@"H:|-%@-[assignedList]-%@-|,H:|-%@-[unassignedList]-%@-|,V:|-%@-[assignedList]-%@-[unassignedList(==assignedList)-%@-|", hPad, hPad, hPad, hPad, navPad, vPad, vPad];
    NSDictionary *views = NSDictionaryOfVariableBindings(assignedList, unassignedList);
    [self.view addConstraints:[NSLayoutConstraint bnr_constraintsWithCommaDelimitedFormat:format views:views]];
}

@end
