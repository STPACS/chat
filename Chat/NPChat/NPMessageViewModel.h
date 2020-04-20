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
//
////获取服务器数据
//+ (RACSignal*)getSearchRecommendNewsPage:(NSInteger)page pageSize:(NSInteger)pageSize kid:(NSString*) kid needOrderId:(NSString *)needOrderId;
//
////发消息
//+ (RACSignal*)healthNeedOrderRecordMsgsDic:(NSDictionary *)dic;
//
//
////APP端-需求工单聊天记录（查新） pt/health-need-order-record-msgs/action/page-new
//+ (RACSignal*)health_need_order_record_msgs_action_page_new:(NSInteger)page pageSize:(NSInteger)pageSize kid:(NSString*) kid versionKid:(nonnull NSString *)versionKid;
//
////APP端-需求工单聊天记录（查历史） pt/health-need-order-record-msgs/action/page-history
//+ (RACSignal*)health_need_order_record_msgs_action_page_history:(NSInteger)page pageSize:(NSInteger)pageSize kid:(NSString*) kid versionKid:(nonnull NSString *)versionKid;
//
////APP端-服务工单聊天记录（查新）
/////pt/health-service-order-record-msgs/action/page-new
//+ (RACSignal*)health_service_order_record_msgs_action_page_new:(NSInteger)page pageSize:(NSInteger)pageSize kid:(NSString*) kid versionKid:(nonnull NSString *)versionKid;
//
//
/////pt/health-service-order-record-msgs/action/page-history
////APP端-服务工单聊天记录（查历史）
//+ (RACSignal*)health_service_order_record_msgs_action_page_history:(NSInteger)page pageSize:(NSInteger)pageSize kid:(NSString*) kid versionKid:(nonnull NSString *)versionKid;


@end

NS_ASSUME_NONNULL_END
