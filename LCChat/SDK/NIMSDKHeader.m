//
//  NIMSDKHeader.m
//  LCChat
//
//  Created by mac on 2020/5/26.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NIMSDKHeader.h"

@implementation NIMSDK

+ (instancetype)sharedSDK {
    static NIMSDK *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NIMSDK alloc] init];
    });
    return instance;
}

- (NSString *)sdkVersion {
    return @"1.0.0";
}

- (nullable NSString *)appKey {
    return @"87382980";
}
@end
