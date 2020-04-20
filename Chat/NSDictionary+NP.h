//
//  NSDictionary+NP.h
//  NutritionPlan
//
//  Created by STPACS on 2020/3/9.
//  Copyright © 2020 laj. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (NP)

//json转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString*)jsonString;

@end

NS_ASSUME_NONNULL_END
