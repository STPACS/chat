//
//  NPChatMessageTableViewCell.h
//  Chat
//
//  Created by mac on 2020/4/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NPContentView.h"
#import "NPSendImageView.h"
#import "NPChat.h"
#import "NPMessageItem.h"



NS_ASSUME_NONNULL_BEGIN

@class NPChatMessageTableViewCell;
@protocol ChatMessageCellDelegate <NSObject>

@optional;
/**
 *  单点聊天记录的空白处，可以有来关闭键盘
 */
- (void)messageCellTappedBlank:(NPChatMessageTableViewCell *)messageCell;

/**
 *  单点聊天记录的HEAD处，暂时未用上
 */
- (void)messageCellTappedHead:(NPChatMessageTableViewCell *)messageCell;

/**
 *  单点聊天记录，可以用来浏览图片，播放视频、打开位置信息、播放语音聊天
 */
- (void)messageCellTappedMessage:(NPChatMessageTableViewCell *)messageCell;

/**
 *  单点用户头像，用来查看用户详情
 */
- (void)messageCellTappedHeadImage:(NPChatMessageTableViewCell *)messageCell;

/**
 *  响应快捷菜单
 */
- (void)messageCell:(NPChatMessageTableViewCell *)messageCell withActionType:(NPChatMessageCellMenuActionType)actionType;

/**
 *  消息发送失败时，重发消息
 */
- (void)messageCellResend:(NPChatMessageTableViewCell *)messageCell;

/**
 *  正在上传或下载文件时，取消操作
 */
- (void)messageCellCancel:(NPChatMessageTableViewCell *)messageCell;

@end


@interface NPChatMessageTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImageView;

//消息内容
@property (nonatomic, strong) UIView *messageContentView;


@property (nonatomic, strong) UIButton *messageCancelButton;

@property (nonatomic, strong) UIProgressView *messageProgressView;

@property (nonatomic, strong) NPSendImageView *messageSendStateImageView;

/**
 *  messageContentView的背景层
 */
@property (nonatomic, strong) UIImageView *messageContentBackgroundImageView;

/**
 *  如果是Gif图片，不显示背影图片，动图显示不需要带气泡的背景图片
 */
@property (nonatomic, assign) BOOL isGifImage;

@property (nonatomic, weak) id<ChatMessageCellDelegate> delegate;

/**
 *  消息的类型,只读类型,会根据自己的具体实例类型进行判断
 */
@property (nonatomic, assign, readonly) NPMessageType messageType;

/**
 *  消息的所有者,只读类型,会根据自己的reuseIdentifier进行判断
 */
@property (nonatomic, assign, readonly) NPMessageOwner messageOwner;

@property (nonatomic, assign) NPMessageItem *item;

/**
 *
 *  消息发送状态,当状态为MessageSendFail或MessageSendStateSending时,messageSendStateImageView显示
 */
@property (nonatomic, assign) NPMessageSendState messageSendState;

#pragma mark - 公有方法

- (void)setup;
- (void)configureCellWithData:(id)data;

@end

NS_ASSUME_NONNULL_END
