//
//  NPViewController.m
//  LCChat
//
//  Created by mac on 2020/5/26.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NPViewController.h"
#import "AppDelegate.h"
#import "NPHomeViewController.h"
#import "NPSecondViewController.h"
#import "NPThirdViewController.h"
#import "NPFourthViewController.h"

@interface NPViewController ()

@end

@implementation NPViewController

+ (instancetype)instance{
    AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *vc = delegete.window.rootViewController;
    if ([vc isKindOfClass:[NPViewController class]]) {
        return (NPViewController *)vc;
    }else{
        return nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *titleArray = @[@"首页",@"联系人",@"工作台",@"我的"];
    NSArray *imageArray = @[@"首页",@"联系人",@"工作台",@"我的"];
    NSArray *vc = @[@"NPHomeViewController",@"NPSecondViewController",@"NPThirdViewController",@"NPFourthViewController"];
    
    NSMutableArray *vcArray = [[NSMutableArray alloc] init];
    
    [titleArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
     
        Class clazz = NSClassFromString(vc[idx]);
        UIViewController *vc = [[clazz alloc] initWithNibName:nil bundle:nil];
        vc.hidesBottomBarWhenPushed = NO;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:titleArray[idx]
                                                       image:[UIImage imageNamed:imageArray[idx]]
                                               selectedImage:[UIImage imageNamed:imageArray[idx]]];
        nav.tabBarItem.tag = idx;
   
        [vcArray addObject:nav];
    }];
    self.viewControllers = [NSArray arrayWithArray:vcArray];
    
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
