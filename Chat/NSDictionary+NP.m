//
//  NSDictionary+NP.m
//  NutritionPlan
//
//  Created by STPACS on 2020/3/9.
//  Copyright © 2020 laj. All rights reserved.
//

#import "NSDictionary+NP.h"

@implementation NSDictionary (NP)

+ (NSDictionary *)dictionaryWithJsonString:(NSString*)jsonString {

    if (jsonString ==nil) {

        return nil;
    }

    NSError*error;
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    if (error) {
        NSLog(@"json解析失败:%@",error);
            return nil;
    }
    return dic;
}


@end
