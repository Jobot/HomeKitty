//
//  AccessoryDetailVC.m
//  HomeKitty
//
//  Created by Joseph W. Dixon on 12/16/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "AccessoryDetailVC.h"
#import "BNRFancyTableView.h"
#import "NSLayoutConstraint+BNRQuickConstraints.h"
#import "UIColor+BNRAppColors.h"
@import HomeKit;

@interface AccessoryDetailVC ()

@property (nonatomic) HMAccessory *accessory;
@property (nonatomic, weak) UILabel *labelForName;
@property (nonatomic, weak) UILabel *labelForIdentifier;
@property (nonatomic, weak) UILabel *labelForBlocked;
@property (nonatomic, weak) UILabel *labelForBridged;
@property (nonatomic, weak) UILabel *labelForReachable;
@property (nonatomic, weak) BNRFancyTableView *tableForServices;

@end

@implementation AccessoryDetailVC

#pragma mark - Initializers

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    NSAssert(NO, @"Use -initWithAccessory: instead");
    return nil;
}

- (instancetype)initWithAccessory:(HMAccessory *)accessory {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _accessory = accessory;
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    
    UILabel *labelForName = [[UILabel alloc] initWithFrame:CGRectZero];
    [view addSubview:labelForName];
    self.labelForName = labelForName;
    
    UILabel *labelForIdentifier = [[UILabel alloc] initWithFrame:CGRectZero];
    [view addSubview:labelForIdentifier];
    self.labelForIdentifier = labelForIdentifier;
    
    UILabel *labelForBlocked = [[UILabel alloc] initWithFrame:CGRectZero];
    [view addSubview:labelForBlocked];
    self.labelForBlocked = labelForBlocked;
    
    UILabel *labelForBridged = [[UILabel alloc] initWithFrame:CGRectZero];
    [view addSubview:labelForBridged];
    self.labelForBridged = labelForBridged;
    
    UILabel *labelForReachable = [[UILabel alloc] initWithFrame:CGRectZero];
    [view addSubview:labelForReachable];
    self.labelForReachable = labelForReachable;
    
    BNRFancyTableView *tableForServices = [[BNRFancyTableView alloc] initWithFrame:CGRectZero style:BNRFancyTableStyleRounded];
    [view addSubview:tableForServices];
    self.tableForServices = tableForServices;
    
    [self setView:view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIFont *labelFont = [UIFont fontWithName:@"HelveticaNeue" size:12];
    
    UILabel *labelForName = self.labelForName;
    labelForName.translatesAutoresizingMaskIntoConstraints = NO;
    labelForName.text = self.accessory.name;
    labelForName.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    
    UILabel *labelForIdentifier = self.labelForIdentifier;
    labelForIdentifier.translatesAutoresizingMaskIntoConstraints = NO;
    labelForIdentifier.text = [NSString stringWithFormat:@"ID: %@", [self.accessory.identifier UUIDString]];
    labelForIdentifier.font = labelFont;
    
    UILabel *labelForBlocked = self.labelForBlocked;
    labelForBlocked.translatesAutoresizingMaskIntoConstraints = NO;
    labelForBlocked.text = [NSString stringWithFormat:@"Blocked: %@", self.accessory.blocked ? @"YES" : @"NO"];
    labelForBlocked.font = labelFont;
    
    UILabel *labelForBridged = self.labelForBridged;
    labelForBridged.translatesAutoresizingMaskIntoConstraints = NO;
    labelForBridged.text = [NSString stringWithFormat:@"Bridged: %@", self.accessory.bridged ? @"YES" : @"NO"];
    labelForBridged.font = labelFont;
    
    UILabel *labelForReachable = self.labelForReachable;
    labelForReachable.translatesAutoresizingMaskIntoConstraints = NO;
    labelForReachable.text = [NSString stringWithFormat:@"Reachable: %@", self.accessory.reachable ? @"YES" : @"NO"];
    labelForReachable.font = labelFont;
    
    BNRFancyTableView *tableForServices = self.tableForServices;
    tableForServices.translatesAutoresizingMaskIntoConstraints = NO;
    [tableForServices setTitle:@"Services" withTextAttributes:nil];
    
    // add constraints
    UINavigationBar *navBar = self.navigationController.navigationBar;
    NSNumber *hPad = @12;
    NSNumber *vPad = @12;
    NSNumber *navPad = @(navBar.frame.origin.y + navBar.frame.size.height + [vPad floatValue]);
    NSString *format = [NSString stringWithFormat:@"H:|-%@-[labelForName]-%@-|,H:|-%@-[labelForIdentifier]-%@-|,H:|-%@-[labelForBlocked]-%@-|,H:|-%@-[labelForBridged]-%@-|,H:|-%@-[labelForReachable]-%@-|,H:|-%@-[tableForServices]-%@-|,V:|-%@-[labelForName(==16)]-%@-[labelForIdentifier(==labelForName)]-%@-[labelForBlocked(==labelForName)]-%@-[labelForBridged(==labelForName)]-%@-[labelForReachable(==labelForName)]-%@-[tableForServices]-%@-|", hPad, hPad, hPad, hPad, hPad, hPad, hPad, hPad, hPad, hPad, hPad, hPad, navPad, vPad, vPad, vPad, vPad, vPad, vPad];
    NSDictionary *views = NSDictionaryOfVariableBindings(labelForName, labelForIdentifier, labelForBlocked, labelForBridged, labelForReachable, tableForServices);
    [self.view addConstraints:[NSLayoutConstraint bnr_constraintsWithCommaDelimitedFormat:format views:views]];
    
    self.view.layer.cornerRadius = 5;
    self.view.layer.masksToBounds = YES;
    
    self.view.backgroundColor = [UIColor bnr_backgroundColor];
}

@end
