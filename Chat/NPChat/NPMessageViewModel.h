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
//获取历史数据
+ (NSMutableArray *)loadDetailMessages;

+ (NSMutableArray *)loadMoreMessages;

//发送消息

@end

NS_ASSUME_NONNULL_END
