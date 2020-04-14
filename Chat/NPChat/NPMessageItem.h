//
//  NPMessageItem.h
//  Chat
//
//  Created by mac on 2020/4/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NPDBModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NPMessageItem : NPDBModel

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, assign) NSInteger durtion;


@property (nonatomic, assign) NSUInteger messageType;

@property (nonatomic, assign) NSUInteger owner;

@property (nonatomic, copy) NSString *redstatus;

@property (nonatomic, copy) NSString *sendstatus;



//以上为demo测试

@property (nonatomic, copy) NSString *createDate;//创建时间
@property (nonatomic, copy) NSString *delFlag;//删除标识 0正常1删除
@property (nonatomic, copy) NSString *eventType;//事件类型 1点对点消息
@property (nonatomic, copy) NSString *fromClientIp;//消息发送方的客户端IP地址
@property (nonatomic, copy) NSString *fromClientPort;//消息发送方的客户端端口号
@property (nonatomic, copy) NSString *fromClientType;//发送客户端类型： AOS、IOS、PC、WINPHONE、WEB、REST
@property (nonatomic, copy) NSString *fromDeviceId;//发送设备id
@property (nonatomic, copy) NSString *lastUpdateDate;//最后修改时间
@property (nonatomic, copy) NSString *lastUpdateUserId;//最后修改人ID
@property (nonatomic, copy) NSString *msgidClient;//客户端消息Id
@property (nonatomic, copy) NSString *needOrderId;//需求工单ID


@property (nonatomic, copy) NSString *msgTimestamp;//消息发送时间
@property (nonatomic, copy) NSString *msgType;//TEXT ：文本消息 PICTURE ：图片消息 AUDIO ：语音消息 VIDEO ：视频消息 LOCATION ：地理位置 NOTIFICATION ：通知 FILE ：文件消息 TIPS ：提示类型消息 CUSTOM ：自定义消息
@property (nonatomic, copy) NSString *toAccount;//消息接收者的用户账号
@property (nonatomic, copy) NSString *fromNick;//发送方昵称
@property (nonatomic, copy) NSString *fromAccount;//消息发送者的用户账号
@property (nonatomic, copy) NSString *ext;//消息扩展字段
@property (nonatomic, copy) NSString *createUserId;//创建人ID
@property (nonatomic, copy) NSString *body;//消息内容
@property (nonatomic, copy) NSString *attach;//消息附件
@property (nonatomic, copy) NSString *kid;


@end

NS_ASSUME_NONNULL_END
