//
//  HomeDataSource.h
//  HomeKitty
//
//  Created by Joseph W. Dixon on 12/10/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMHomeManager;

extern NSString * const HomeDataSourceDidChangeNotification;

@interface HomeDataSource : NSObject <UITableViewDataSource>

- (instancetype)initWithHomeManager:(HMHomeManager *)homeManager;

@end
