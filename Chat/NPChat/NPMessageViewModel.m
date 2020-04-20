

//
//  NPMessageViewModel.m
//  Chat
//
//  Created by mac on 2020/4/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NPMessageViewModel.h"
#import "NPChat.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NPMessageItem.h"
//#import "NPNetwork.h"
//#import <ydk-network/YdkNetwork.h>
//#import "UIImage+NIMKit.h"
//#import "NSString+SZKit.h"

@implementation NPMessageViewModel

//
////APP端-需求工单聊天记录（查历史） pt/health-need-order-record-msgs/action/page-history
//+ (RACSignal*)health_need_order_record_msgs_action_page_history:(NSInteger)page pageSize:(NSInteger)pageSize kid:(NSString*) kid versionKid:(nonnull NSString *)versionKid{
//
//    return [[YdkNetwork request:GET service:@"evaluate" URLString:@"/pt/health-need-order-record-msgs/action/page-history" parameters:@{@"pageNo": @(page), @"pageSize": @(pageSize),@"kid":kid,@"versionKid":[NSString stringWithFormat:@"%@",versionKid]}]map:^id _Nullable(id  _Nullable value) {
//
//        NSArray *dataList = [NSArray yy_modelArrayWithClass:NPMessageItem.class json:[value objectForKey:@"entities"]];
//
//        return dataList;
//    }];
//}
//
//
//+ (RACSignal*)getSearchRecommendNewsPage:(NSInteger)page pageSize:(NSInteger)pageSize kid:(NSString*) kid needOrderId:(nonnull NSString *)needOrderId{
//
//    return [[YdkNetwork request:GET service:@"evaluate" URLString:@"/pt/health-need-order-record-msgs/action/list-page" parameters:@{@"pageNo": @(page), @"pageSize": @(pageSize),@"kid":needOrderId,@"versionKid":[NSString stringWithFormat:@"%@",kid],@"isHistory":@"0"}]map:^id _Nullable(id  _Nullable value) {
//
//        NSArray *dataList = [NSArray yy_modelArrayWithClass:NPMessageItem.class json:[value objectForKey:@"entities"]];
//
//        return dataList;
//    }];
//}
//
////APP端-需求工单聊天记录（查新） pt/health-need-order-record-msgs/action/page-new
//+ (RACSignal*)health_need_order_record_msgs_action_page_new:(NSInteger)page pageSize:(NSInteger)pageSize kid:(NSString*) kid versionKid:(nonnull NSString *)versionKid{
//
//    return [[YdkNetwork request:GET service:@"evaluate" URLString:@"/pt/health-need-order-record-msgs/action/page-new" parameters:@{@"pageNo": @(page), @"pageSize": @(pageSize),@"kid":kid,@"versionKid":[NSString stringWithFormat:@"%@",versionKid]}]map:^id _Nullable(id  _Nullable value) {
//
//        return value;
//    }];
//}
//
//+ (RACSignal*)healthNeedOrderRecordMsgsDic:(NSDictionary *)dic {
//
//    return [[YdkNetwork POST:@"evaluate" URLString:@"/pt/health-need-order-record-msgs/action/create" parameters:dic]map:^id _Nullable(id  _Nullable value) {
//
//        return value;
//
//    }];
//}
//
////APP端-服务工单聊天记录（查新）
/////pt/health-service-order-record-msgs/action/page-new
//+ (RACSignal*)health_service_order_record_msgs_action_page_new:(NSInteger)page pageSize:(NSInteger)pageSize kid:(NSString*) kid versionKid:(nonnull NSString *)versionKid {
//    return [[YdkNetwork request:GET service:@"evaluate" URLString:@"/pt/health-service-order-record-msgs/action/page-new" parameters:@{@"pageNo": @(page), @"pageSize": @(pageSize),@"kid":kid,@"versionKid":[NSString stringWithFormat:@"%@",versionKid]}]map:^id _Nullable(id  _Nullable value) {
//
//        NSArray *dataList = [NSArray yy_modelArrayWithClass:NPMessageItem.class json:[value objectForKey:@"entities"]];
//
//        return dataList;
//        }];
//}
//
//
/////pt/health-service-order-record-msgs/action/page-history
////APP端-服务工单聊天记录（查历史）
//+ (RACSignal*)health_service_order_record_msgs_action_page_history:(NSInteger)page pageSize:(NSInteger)pageSize kid:(NSString*) kid versionKid:(nonnull NSString *)versionKid {
//    return [[YdkNetwork request:GET service:@"evaluate" URLString:@"/pt/health-service-order-record-msgs/action/page-history" parameters:@{@"pageNo": @(page), @"pageSize": @(pageSize),@"kid":kid,@"versionKid":[NSString stringWithFormat:@"%@",versionKid]}]map:^id _Nullable(id  _Nullable value) {
//
//        NSArray *dataList = [NSArray yy_modelArrayWithClass:NPMessageItem.class json:[value objectForKey:@"entities"]];
//
//        return dataList;
//        }];
//}


@end
