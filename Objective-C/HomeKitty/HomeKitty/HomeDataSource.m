//
//  HomeDataSource.m
//  HomeKitty
//
//  Created by Joseph W. Dixon on 12/10/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import "HomeDataSource.h"
@import HomeKit;

NSString * const HomeDataSourceDidChangeNotification = @"HomeDataSourceDidChangeNotification";

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
        _homeManager.delegate = self;
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
    
    HMHome *home = [self homeForRow:indexPath.row];
    cell.textLabel.text = home.name;
    
    return cell;
}

- (HMHome *)homeForRow:(NSInteger)row {
    return self.homeManager.homes[row];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        HMHome *home = self.homeManager.homes[indexPath.row];
        [self.homeManager removeHome:home completionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            } else {
                [tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
    }
}

#pragma mark - Home Manager Delegate

- (void)homeManagerDidUpdateHomes:(HMHomeManager *)manager {
    [[NSNotificationCenter defaultCenter] postNotificationName:HomeDataSourceDidChangeNotification object:nil];
}

#pragma mark - Home Management

- (void)addHomeWithName:(NSString *)name {
    [self.homeManager addHomeWithName:name completionHandler:^(HMHome *home, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:HomeDataSourceDidChangeNotification object:nil];
        }
    }];
}

@end
