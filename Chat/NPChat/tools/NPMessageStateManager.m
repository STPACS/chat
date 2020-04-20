

//
//  NPMessageStateManager.m
//  Chat
//
//  Created by mac on 2020/4/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NPMessageStateManager.h"

@interface NPMessageStateManager ()

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

- (void)setMessageSendState:(NPMessageSendState)messageSendState forIndex:(NSUInteger)index
{
    _messageSendStateDict[@(index)] = @(messageSendState);
}

- (void)cleanState
{
    [_messageSendStateDict removeAllObjects];
}


@end
