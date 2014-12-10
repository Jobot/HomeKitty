//
//  RoomDataSource.m
//  HomeKitty
//
//  Created by Joseph W. Dixon on 12/10/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "RoomDataSource.h"
@import HomeKit;

NSString * const RoomDataSourceDidChangeNotification = @"RoomDataSourceDidChangeNotification";

@implementation RoomDataSource

#pragma mark - Customer Getters / Setters

- (void)setHome:(HMHome *)home {
    _home = home;
    [[NSNotificationCenter defaultCenter] postNotificationName:RoomDataSourceDidChangeNotification object:nil];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.home.rooms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RoomCell"];
    }
    
    HMRoom *room = self.home.rooms[indexPath.row];
    cell.textLabel.text = room.name;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        HMRoom *room = self.home.rooms[indexPath.row];
        [self.home removeRoom:room completionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            } else {
                [tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
    }
}

@end
