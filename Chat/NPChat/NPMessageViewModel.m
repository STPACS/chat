

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

@implementation NPMessageViewModel

+ (NSMutableArray *)loadDetailMessages {
   
    NSMutableArray *muArray = [NSMutableArray array];

    {
        NPMessageItem *model = [[NPMessageItem alloc]init];
        model.messageType = MessageTypeText;
        model.kid = @"324432432";
        model.owner = MessageOwnerOther;
        model.text = @"放得开萨拉房453234萨积分";
        [muArray addObject:model];

    }
    {

        NPMessageItem *model = [[NPMessageItem alloc]init];
        model.messageType = MessageTypeImage;
        model.kid = @"324432432";
        model.owner = MessageOwnerSelf;
        model.image = @"plugins_FriendNotify";
        [muArray addObject:model];

    }

    //根据两条消息内容时间间隔进行对比，确定是否需要显示时间
    {
        NPMessageItem *model = [[NPMessageItem alloc]init];
        model.messageType = MessageTypeDateTime;
        model.kid = @"324432412";
        model.owner = MessageOwnerSystem;
        model.text = @"2016-05-3 13:21:09";
        [muArray addObject:model];

    }
    {

        NPMessageItem *model = [[NPMessageItem alloc]init];
        model.messageType = MessageTypeVoice;
        model.kid = @"324432412";
        model.owner = MessageOwnerOther;
        model.durtion = random()%60 ;
        [muArray addObject:model];

    }
    return muArray;
}

+ (NSMutableArray *)loadMoreMessages{
   
    NSMutableArray *muArray = [NSMutableArray array];
   
    {
        NPMessageItem *model = [[NPMessageItem alloc]init];
        model.messageType = MessageTypeText;
        model.kid = @"32423432";
        model.owner = MessageOwnerOther;
        model.text = @"放得开23423拉卡萨积分";
        [muArray addObject:model];

    }
    {

        NPMessageItem *model = [[NPMessageItem alloc]init];
        model.messageType = MessageTypeImage;
        model.kid = @"325342432";
        model.owner = MessageOwnerSelf;
        model.image = @"plugins_FriendNotify";
        [muArray addObject:model];

    }

    //根据两条消息内容时间间隔进行对比，确定是否需要显示时间
    {
        NPMessageItem *model = [[NPMessageItem alloc]init];
        model.messageType = MessageTypeDateTime;
        model.kid = @"326542412";
        model.owner = MessageOwnerSystem;
        model.text = @"2016-05-3 13:21:09";
        [muArray addObject:model];


    }
    {

        NPMessageItem *model = [[NPMessageItem alloc]init];
        model.messageType = MessageTypeVoice;
        model.kid = @"3264512";
        model.owner = MessageOwnerOther;
        model.durtion = random()%60 ;
        [muArray addObject:model];

    }
    return muArray;
}


@end
