//
//  HomeRoomsVC.m
//  HomeKitty
//
//  Created by Joseph W. Dixon on 12/9/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "HomeRoomsVC.h"
#import "HomeDataSource.h"
#import "BNRFancyTableView.h"
#import "NSLayoutConstraint+BNRQuickConstraints.h"

@interface HomeRoomsVC ()

@property (nonatomic, weak) BNRFancyTableView *homeList;
@property (nonatomic, weak) BNRFancyTableView *roomList;
@property (nonatomic) HomeDataSource *homeDataSource;

@end

@implementation HomeRoomsVC

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
    
    BNRFancyTableView *homeList = [[BNRFancyTableView alloc] initWithFrame:CGRectZero];
    [view addSubview:homeList];
    self.homeList = homeList;
    
    BNRFancyTableView *roomList = [[BNRFancyTableView alloc] initWithFrame:CGRectZero];
    [view addSubview:roomList];
    self.roomList = roomList;
    
    [self setView:view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.homeDataSource = [[HomeDataSource alloc] init];
    
    BNRFancyTableView *homeList = self.homeList;
    homeList.dataSource = self.homeDataSource;
    homeList.translatesAutoresizingMaskIntoConstraints = NO;
    
    BNRFancyTableView *roomList = self.roomList;
    roomList.translatesAutoresizingMaskIntoConstraints = NO;
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    NSNumber *hPad = @12;
    NSNumber *vPad = @12;
    NSNumber *navPad = @(navBar.frame.origin.y + navBar.frame.size.height + [vPad floatValue]);
    
    NSString *format = [NSString stringWithFormat:@"H:|-%@-[homeList]-%@-|,H:|-%@-[roomList]-%@-|,V:|-%@-[homeList]-%@-[roomList(==homeList)]-%@-|", hPad, hPad, hPad, hPad, navPad, vPad, vPad];
    NSDictionary *views = NSDictionaryOfVariableBindings(homeList, roomList);
    [self.view addConstraints:[NSLayoutConstraint bnr_constraintsWithCommaDelimitedFormat:format views:views]];
}

@end
