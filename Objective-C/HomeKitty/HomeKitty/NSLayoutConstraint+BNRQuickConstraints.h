//
//  NSLayoutConstraint+BNRQuickConstraints.h
//  HomeKitty
//
//  Created by Joseph W. Dixon on 12/9/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (BNRQuickConstraints)

+ (NSArray *)bnr_constraintsWithCommaDelimitedFormat:(NSString *)format views:(NSDictionary *)views;

@end
