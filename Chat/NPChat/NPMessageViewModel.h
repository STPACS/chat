//
//  NPMessageViewModel.h
//  Chat
//
//  Created by mac on 2020/4/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NPMessageItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface NPMessageViewModel : NSObject
////测试获取历史数据
//+ (NSMutableArray *)loadDetailMessages;
//
//+ (NSMutableArray *)loadMoreMessages;

//获取服务器数据
+ (RACSignal*)getSearchRecommendNewsPage:(NSInteger)page pageSize:(NSInteger)pageSize kid:(NSString*) kid needOrderId:(NSString *)needOrderId;

//发消息
+ (RACSignal*)healthNeedOrderRecordMsgsDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
