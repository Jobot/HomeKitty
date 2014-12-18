//
//  AccessoriesInRoomDataSource.m
//  HomeKitty
//
//  Created by Joseph W. Dixon on 12/10/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "AccessoriesInRoomDataSource.h"
@import HomeKit;

@interface AccessoriesInRoomDataSource()

@property (nonatomic) HMHome *home;
@property (nonatomic) HMRoom *room;

@end

@implementation AccessoriesInRoomDataSource

#pragma mark - Manage Room

- (void)setRoom:(HMRoom *)room inHome:(HMHome *)home {
    self.room = room;
    self.home = home;
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.room.accessories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccessoryCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AccessoryCell"];
    }
    
    HMAccessory *accessory = self.room.accessories[indexPath.row];
    cell.textLabel.text = accessory.name;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}

- (HMAccessory *)accessoryForRow:(NSInteger)row {
    return self.room.accessories[row];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        HMAccessory *accessory = self.room.accessories[indexPath.row];
        [self.home removeAccessory:accessory completionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            } else {
                [tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
    }
}

@end
