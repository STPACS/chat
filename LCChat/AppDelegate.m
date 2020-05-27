//
//  AppDelegate.m
//  LCChat
//
//  Created by mac on 2020/5/25.
//  Copyright © 2020 mac. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "NPViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    self.window.backgroundColor = UIColor.whiteColor;
    
    NPViewController *tabbaVC = [[NPViewController alloc]init];
    
    self.window.rootViewController = tabbaVC;
    
    // Override point for customization after application launch.
    return YES;
}



@end
