//
//  RoomDataSource.h
//  HomeKitty
//
//  Created by Joseph W. Dixon on 12/10/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMHome;

extern NSString * const RoomDataSourceDidChangeNotification;

@interface RoomDataSource : NSObject <UITableViewDataSource>

@property (nonatomic) HMHome *home;

- (void)addRoomWithname:(NSString *)name;

@end
