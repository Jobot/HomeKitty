//
//  HomeRoomsVC.m
//  HomeKitty
//
//  Created by Joseph W. Dixon on 12/9/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "HomeRoomsVC.h"
#import "HomeDataSource.h"
#import "RoomDataSource.h"
#import "AccessoriesVC.h"
#import "BNRFancyTableView.h"
#import "NSLayoutConstraint+BNRQuickConstraints.h"
#import "UIColor+BNRAppColors.h"
@import HomeKit;

static NSInteger const HomeRoomsAddHomeTextFieldTag = -100;
static NSInteger const HomeRoomsAddRoomTextFieldTag = -101;

@interface HomeRoomsVC () <UITextFieldDelegate>

@property (nonatomic, weak) BNRFancyTableView *homeList;
@property (nonatomic, weak) BNRFancyTableView *roomList;
@property (nonatomic) HomeDataSource *homeDataSource;
@property (nonatomic) RoomDataSource *roomDataSource;
@property (nonatomic) id<NSObject> homeChangeObserver;
@property (nonatomic) id<NSObject> roomChangeObserver;
@property (nonatomic, weak) UIBarButtonItem *addHomeButton;
@property (nonatomic, weak) UIBarButtonItem *addRoomButton;
@property (nonatomic) NSString *addedHomeText;
@property (nonatomic) NSString *addedRoomText;

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
    
    BNRFancyTableView *homeList = [[BNRFancyTableView alloc] initWithFrame:CGRectZero style:BNRFancyTableStyleRounded];
    [view addSubview:homeList];
    self.homeList = homeList;
    
    BNRFancyTableView *roomList = [[BNRFancyTableView alloc] initWithFrame:CGRectZero style:BNRFancyTableStyleRounded];
    [view addSubview:roomList];
    self.roomList = roomList;
    
    [self setView:view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Homes";
    
    // configure data sources
    self.homeDataSource = [[HomeDataSource alloc] init];
    self.roomDataSource = [[RoomDataSource alloc] init];
    
    // configure home list
    BNRFancyTableView *homeList = self.homeList;
    homeList.dataSource = self.homeDataSource;
    homeList.translatesAutoresizingMaskIntoConstraints = NO;
    [homeList setTitle:@"Homes" withTextAttributes:nil];
    UIBarButtonItem *addHomeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                   target:self
                                                                                   action:@selector(didPressAddHomeButton:)];
    [homeList addToolbarItem:addHomeButton];
    self.addHomeButton = addHomeButton;
    
    // configure room list
    BNRFancyTableView *roomList = self.roomList;
    roomList.dataSource = self.roomDataSource;
    roomList.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *attributes = @{ NSForegroundColorAttributeName : [UIColor grayColor] };
    [roomList setTitle:@"Please select a home" withTextAttributes:attributes];
    UIBarButtonItem *addRoomButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                   target:self
                                                                                   action:@selector(didPressAddRoomButton:)];
    addRoomButton.enabled = NO;
    [roomList addToolbarItem:addRoomButton];
    self.addRoomButton = addRoomButton;
    
    // add constraints
    UINavigationBar *navBar = self.navigationController.navigationBar;
    NSNumber *hPad = @12;
    NSNumber *vPad = @12;
    NSNumber *navPad = @(navBar.frame.origin.y + navBar.frame.size.height + [vPad floatValue]);
    
    NSString *format = [NSString stringWithFormat:@"H:|-%@-[homeList]-%@-|,H:|-%@-[roomList]-%@-|,V:|-%@-[homeList]-%@-[roomList(==homeList)]-%@-|", hPad, hPad, hPad, hPad, navPad, vPad, vPad];
    NSDictionary *views = NSDictionaryOfVariableBindings(homeList, roomList);
    [self.view addConstraints:[NSLayoutConstraint bnr_constraintsWithCommaDelimitedFormat:format views:views]];
    
    self.view.backgroundColor = [UIColor bnr_backgroundColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    __weak __typeof(self) weakSelf = self;
    
    self.homeChangeObserver = [[NSNotificationCenter defaultCenter] addObserverForName:HomeDataSourceDidChangeNotification
                                                                                object:nil
                                                                                 queue:[NSOperationQueue mainQueue]
                                                                            usingBlock:^(NSNotification *note) {
                                                                                
                                                                                [weakSelf.homeList reloadData];
                                                                                
                                                                            }];
    
    self.roomChangeObserver = [[NSNotificationCenter defaultCenter] addObserverForName:RoomDataSourceDidChangeNotification
                                                                                object:nil
                                                                                 queue:[NSOperationQueue mainQueue]
                                                                            usingBlock:^(NSNotification *note) {
                                                                                
                                                                                [weakSelf.roomList reloadData];
                                                                                
                                                                            }];
    
    self.homeList.didSelectBlock = ^(NSIndexPath *indexPath) {
        weakSelf.roomDataSource.home = [weakSelf.homeDataSource homeForRow:indexPath.row];
        weakSelf.addRoomButton.enabled = YES;
        NSString *title = [NSString stringWithFormat:@"Rooms for Home: %@", weakSelf.roomDataSource.home.name];
        [weakSelf.roomList setTitle:title withTextAttributes:nil];
    };
    
    self.homeList.didDeselectBlock = ^(NSIndexPath *indexPath) {
        weakSelf.addRoomButton.enabled = NO;
    };
    
    self.roomList.didSelectBlock = ^(NSIndexPath *indexPath) {
        HMHome *home = weakSelf.roomDataSource.home;
        HMRoom *room = [weakSelf.roomDataSource roomForRow:indexPath.row];
        AccessoriesVC *accessoriesVC = [[AccessoriesVC alloc] init];
        [accessoriesVC setRoom:room inHome:home];
        [self showViewController:accessoriesVC sender:self];
    };
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.homeChangeObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.homeChangeObserver];
        self.homeChangeObserver = nil;
    }
    
    if (self.roomChangeObserver) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.roomChangeObserver];
        self.roomChangeObserver = nil;
    }
}

#pragma mark - Actions

- (void)didPressAddHomeButton:(id)sender {
    __weak __typeof(self) weakSelf = self;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Name your Home"
                                                                   message:@"Each home must have a unique name. Please give your home a name."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.delegate = self;
        textField.placeholder = @"Home Sweet Home";
        textField.tag = HomeRoomsAddHomeTextFieldTag;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Add"
                                             style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action) {
                                               [weakSelf.homeDataSource addHomeWithName:weakSelf.addedHomeText];
                                           }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *action) {
                                                weakSelf.addedHomeText = nil;
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didPressAddRoomButton:(id)sender {
    __weak __typeof(self) weakSelf = self;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Name your Room"
                                                                   message:@"Rooms within a home must be uniquely named. Please name yours."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.delegate = self;
        textField.placeholder = @"My Room";
        textField.tag = HomeRoomsAddRoomTextFieldTag;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Add"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                [weakSelf.roomDataSource addRoomWithname:weakSelf.addedRoomText];
                                            }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *action) {
                                                weakSelf.addedRoomText = nil;
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == HomeRoomsAddHomeTextFieldTag) {
        self.addedHomeText = textField.text;
    } else if (textField.tag == HomeRoomsAddRoomTextFieldTag) {
        self.addedRoomText = textField.text;
    }
}

@end
