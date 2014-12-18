//
//  AccessoriesInRoomDataSource.h
//  HomeKitty
//
//  Created by Joseph W. Dixon on 12/10/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMHome;
@class HMRoom;
@class HMAccessory;

@interface AccessoriesInRoomDataSource : NSObject <UITableViewDataSource>

- (void)setRoom:(HMRoom *)room inHome:(HMHome *)home;
- (HMAccessory *)accessoryForRow:(NSInteger)row;

@end
