//
//  NPHomeViewController.h
//  LCChat
//
//  Created by mac on 2020/5/26.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMSessionListViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NPHomeViewController :  NIMSessionListViewController

@property (nonatomic,strong) UILabel *emptyTipLabel;

@property (nonatomic,strong) UILabel *titleLabel;

- (void)setUpNavItem;

@end

NS_ASSUME_NONNULL_END
