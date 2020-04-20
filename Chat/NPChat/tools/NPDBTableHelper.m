//
//  NPDBTableHelper.m
//  NutritionPlan
//
//  Created by mac on 2020/4/15.
//  Copyright © 2020 laj. All rights reserved.
//

#import "NPDBTableHelper.h"

@implementation NPDBTableHelper

static NPDBTableHelper *_instance = nil;

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
    
    return _instance;
}

@end
