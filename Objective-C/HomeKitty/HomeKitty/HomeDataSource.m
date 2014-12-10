//
//  HomeDataSource.m
//  HomeKitty
//
//  Created by Joseph W. Dixon on 12/10/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "HomeDataSource.h"
@import HomeKit;

@interface HomeDataSource() <HMHomeManagerDelegate>

@property (nonatomic) HMHomeManager *homeManager;

@end

@implementation HomeDataSource

#pragma mark - Initializers

- (instancetype)init {
    HMHomeManager *homeManager = [[HMHomeManager alloc] init];
    return [self initWithHomeManager:homeManager];
}

- (instancetype)initWithHomeManager:(HMHomeManager *)homeManager {
    self = [super init];
    if (self) {
        _homeManager = homeManager;
    }
    return self;
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.homeManager.homes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeCell"];
    }
    
    HMHome *home = self.homeManager.homes[indexPath.row];
    cell.textLabel.text = home.name;
    
    return cell;
}

#pragma mark - Home Manager Delegate

- (void)homeManagerDidUpdateHomes:(HMHomeManager *)manager {
    // Reload Table View
}

@end
