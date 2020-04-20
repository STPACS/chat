//
//  NPDBTableHelper.h
//  NutritionPlan
//
//  Created by mac on 2020/4/15.
//  Copyright © 2020 laj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NPDBTableHelper : NSObject
+ (NPDBTableHelper *)shareInstance;
@property (nonatomic, copy) NSString *tbName;

@end

NS_ASSUME_NONNULL_END
