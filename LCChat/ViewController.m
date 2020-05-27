//
//  ViewController.m
//  LCChat
//
//  Created by mac on 2020/5/25.
//  Copyright © 2020 mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(90, 90, 90, 90);
    button.backgroundColor = UIColor.orangeColor;
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Do any additional setup after loading the view.
}

- (void)buttonAction:(UIButton *)btn {
    
}

@end
