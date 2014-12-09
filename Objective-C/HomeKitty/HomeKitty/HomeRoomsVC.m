//
//  HomeRoomsVC.m
//  HomeKitty
//
//  Created by Joseph W. Dixon on 12/9/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "HomeRoomsVC.h"
#import "BNRFancyTableView.h"
#import "NSLayoutConstraint+BNRQuickConstraints.h"

@interface HomeRoomsVC ()

@property (nonatomic, weak) BNRFancyTableView *homeList;
@property (nonatomic, weak) BNRFancyTableView *roomList;

@end

@implementation HomeRoomsVC

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    
    BNRFancyTableView *homeList = [[BNRFancyTableView alloc] initWithFrame:CGRectZero];
    [view addSubview:homeList];
    
    BNRFancyTableView *roomList = [[BNRFancyTableView alloc] initWithFrame:CGRectZero];
    [view addSubview:roomList];

    NSString *hPad = @"12";
    NSString *vPad = @"12";
    NSString *format = [NSString stringWithFormat:@"H:|-%@-[homeList]-%@-|,H:|-%@-[roomList]-%@-|,V:|-%@-[homeList]-%@-[roomList]-%@-|", hPad, hPad, hPad, hPad, vPad, vPad, vPad];
    NSDictionary *views = NSDictionaryOfVariableBindings(homeList, roomList);
    [view addConstraints:[NSLayoutConstraint bnr_constraintsWithCommaDelimitedFormat:format views:views]];
    
    [self setView:view];
}

@end
