//
//  NPSecondViewController.h
//  LCChat
//
//  Created by mac on 2020/5/26.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NPSecondViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
