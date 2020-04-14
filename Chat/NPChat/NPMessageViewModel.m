

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

#import "NPNetwork.h"
#import "NPCustomTools.h"
#import <ydk-network/YdkNetwork.h>
#import "UIImage+NIMKit.h"
#import "NSString+SZKit.h"
#import "RecommendEntity.h"

@implementation NPMessageViewModel

//+ (NSMutableArray *)loadDetailMessages {
//
//    NSMutableArray *muArray = [NSMutableArray array];
//
//    {
//        NPMessageItem *model = [[NPMessageItem alloc]init];
//        model.messageType = MessageTypeText;
//        model.kid = @"324432432";
//        model.owner = MessageOwnerOther;
//        model.text = @"放得开萨拉房453234萨积分";
//        [muArray addObject:model];
//
//    }
//    {
//
//        NPMessageItem *model = [[NPMessageItem alloc]init];
//        model.messageType = MessageTypeImage;
//        model.kid = @"324432432";
//        model.owner = MessageOwnerSelf;
//        model.image = @"plugins_FriendNotify";
//        [muArray addObject:model];
//
//    }
//
//    //根据两条消息内容时间间隔进行对比，确定是否需要显示时间
//    {
//        NPMessageItem *model = [[NPMessageItem alloc]init];
//        model.messageType = MessageTypeDateTime;
//        model.kid = @"324432412";
//        model.owner = MessageOwnerSystem;
//        model.text = @"2016-05-3 13:21:09";
//        [muArray addObject:model];
//
//    }
//    {
//
//        NPMessageItem *model = [[NPMessageItem alloc]init];
//        model.messageType = MessageTypeVoice;
//        model.kid = @"324432412";
//        model.owner = MessageOwnerOther;
//        model.durtion = random()%60 ;
//        [muArray addObject:model];
//
//    }
//    return muArray;
//}
//
//+ (NSMutableArray *)loadMoreMessages{
//
//    NSMutableArray *muArray = [NSMutableArray array];
//
//    {
//        NPMessageItem *model = [[NPMessageItem alloc]init];
//        model.messageType = MessageTypeText;
//        model.kid = @"32423432";
//        model.owner = MessageOwnerOther;
//        model.text = @"放得开23423拉卡萨积分";
//        [muArray addObject:model];
//
//    }
//    {
//
//        NPMessageItem *model = [[NPMessageItem alloc]init];
//        model.messageType = MessageTypeImage;
//        model.kid = @"325342432";
//        model.owner = MessageOwnerSelf;
//        model.image = @"plugins_FriendNotify";
//        [muArray addObject:model];
//
//    }
//
//    //根据两条消息内容时间间隔进行对比，确定是否需要显示时间
//    {
//        NPMessageItem *model = [[NPMessageItem alloc]init];
//        model.messageType = MessageTypeDateTime;
//        model.kid = @"326542412";
//        model.owner = MessageOwnerSystem;
//        model.text = @"2016-05-3 13:21:09";
//        [muArray addObject:model];
//
//
//    }
//    {
//
//        NPMessageItem *model = [[NPMessageItem alloc]init];
//        model.messageType = MessageTypeVoice;
//        model.kid = @"3264512";
//        model.owner = MessageOwnerOther;
//        model.durtion = random()%60 ;
//        [muArray addObject:model];
//
//    }
//    return muArray;
//}

+ (RACSignal*)getSearchRecommendNewsPage:(NSInteger)page pageSize:(NSInteger)pageSize kid:(NSString*) kid needOrderId:(nonnull NSString *)needOrderId{

    return [[YdkNetwork request:GET service:@"evaluate" URLString:@"/pt/health-need-order-record-msgs/action/list-page" parameters:@{@"pageNo": @(page), @"pageSize": @(pageSize),@"kid":needOrderId,@"versionKid":[NSString stringWithFormat:@"%@",kid]}]map:^id _Nullable(id  _Nullable value) {
        
        NSLog(@"value:  %@",value);
        
        NSArray *dataList = [NSArray yy_modelArrayWithClass:RecommendEntity.class json:[value objectForKey:@"entities"]];
    
        return dataList;
    }];
}

+ (RACSignal*)healthNeedOrderRecordMsgsDic:(NSDictionary *)dic {
    
    return [[YdkNetwork POST:@"evaluate" URLString:@"/pt/health-need-order-record-msgs/action/create" parameters:dic]map:^id _Nullable(id  _Nullable value) {

        return value;

    }];
}

@end
