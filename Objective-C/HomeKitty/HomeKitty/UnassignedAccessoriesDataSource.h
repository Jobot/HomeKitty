//
//  UnassignedAccessoriesDataSource.h
//  HomeKitty
//
//  Created by Joseph W. Dixon on 12/10/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMAccessoryBrowser;

@interface UnassignedAccessoriesDataSource : NSObject <UITableViewDataSource>

- (instancetype)initWithAccessoryBrowser:(HMAccessoryBrowser *)accessoryBrowser;

@end
