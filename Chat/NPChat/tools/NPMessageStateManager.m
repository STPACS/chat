

//
//  NPMessageStateManager.m
//  Chat
//
//  Created by mac on 2020/4/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NPMessageStateManager.h"

@interface NPMessageStateManager ()

@property (nonatomic, strong) NSMutableDictionary *messageReadStateDict;
@property (nonatomic, strong) NSMutableDictionary *messageSendStateDict;

@end

@implementation NPMessageStateManager

+ (instancetype)shareManager
{
    static id manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    if ([super init])
    {
        _messageReadStateDict = [NSMutableDictionary dictionary];
        _messageSendStateDict = [NSMutableDictionary dictionary];
    }
    return self;
}


#pragma mark - 公有方法

- (NPMessageSendState)messageSendStateForIndex:(NSUInteger)index
{
    if (_messageSendStateDict[@(index)])
    {
        return [_messageSendStateDict[@(index)] integerValue];
    }
    return MessageSendSuccess;
}

- (NPMessageReadState)messageReadStateForIndex:(NSUInteger)index
{
    if (_messageReadStateDict[@(index)])
    {
        return [_messageReadStateDict[@(index)] integerValue];
    }
    return MessageReaded;
}

- (void)setMessageSendState:(NPMessageSendState)messageSendState forIndex:(NSUInteger)index
{
    _messageSendStateDict[@(index)] = @(messageSendState);
}

- (void)setMessageReadState:(NPMessageReadState)messageReadState forIndex:(NSUInteger)index
{
    _messageReadStateDict[@(index)] = @(messageReadState);
}

- (void)cleanState
{
    [_messageSendStateDict removeAllObjects];
    [_messageReadStateDict removeAllObjects];
}


@end
