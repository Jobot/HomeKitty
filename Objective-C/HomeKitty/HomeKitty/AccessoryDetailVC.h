//
//  AccessoryDetailVC.h
//  HomeKitty
//
//  Created by Joseph W. Dixon on 12/16/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMAccessory;

@interface AccessoryDetailVC : UIViewController

- (instancetype)initWithAccessory:(HMAccessory *)accessory;

@end
