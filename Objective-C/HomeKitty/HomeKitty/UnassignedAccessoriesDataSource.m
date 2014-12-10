//
//  UnassignedAccessoriesDataSource.m
//  HomeKitty
//
//  Created by Joseph W. Dixon on 12/10/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "UnassignedAccessoriesDataSource.h"
@import HomeKit;

NSString * const UnassignedAccessoriesDataSourceDidChangeNotification = @"UnassignedAccessoriesDataSourceDidChangeNotification";

@interface UnassignedAccessoriesDataSource() <HMAccessoryBrowserDelegate>

@property (nonatomic) HMAccessoryBrowser *accessoryBrowser;

@end

@implementation UnassignedAccessoriesDataSource

#pragma mark - Initializers

- (instancetype)init {
    HMAccessoryBrowser *accessoryBrowser = [[HMAccessoryBrowser alloc] init];
    return [self initWithAccessoryBrowser:accessoryBrowser];
}

- (instancetype)initWithAccessoryBrowser:(HMAccessoryBrowser *)accessoryBrowser {
    self = [super init];
    if (self) {
        _accessoryBrowser = accessoryBrowser;
        _accessoryBrowser.delegate = self;
        [_accessoryBrowser startSearchingForNewAccessories];
    }
    return self;
}

- (void)dealloc {
    [_accessoryBrowser stopSearchingForNewAccessories];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.accessoryBrowser.discoveredAccessories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccessoryCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AccessoryCell"];
    }
    
    HMAccessory *accessory = self.accessoryBrowser.discoveredAccessories[indexPath.row];
    cell.textLabel.text = accessory.name;
    
    return cell;
}

#pragma mark - Accessory Browser Delegate

- (void)accessoryBrowser:(HMAccessoryBrowser *)browser didFindNewAccessory:(HMAccessory *)accessory {
    [[NSNotificationCenter defaultCenter] postNotificationName:UnassignedAccessoriesDataSourceDidChangeNotification object:nil];
}

- (void)accessoryBrowser:(HMAccessoryBrowser *)browser didRemoveNewAccessory:(HMAccessory *)accessory {
    [[NSNotificationCenter defaultCenter] postNotificationName:UnassignedAccessoriesDataSourceDidChangeNotification object:nil];
}

@end
