//
//  NPMessageStateManager.h
//  Chat
//
//  Created by mac on 2020/4/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NPChat.h"
NS_ASSUME_NONNULL_BEGIN

@interface NPMessageStateManager : NSObject
+ (instancetype)shareManager;


#pragma mark - 公有方法

- (NPMessageSendState)messageSendStateForIndex:(NSUInteger)index;

- (void)setMessageSendState:(NPMessageSendState)messageSendState forIndex:(NSUInteger)index;

- (void)cleanState;
@end

NS_ASSUME_NONNULL_END
