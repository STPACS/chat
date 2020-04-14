

//
//  NPChat.h
//  Chat
//
//  Created by mac on 2020/4/10.
//  Copyright © 2020 mac. All rights reserved.
//

#ifndef NPChat_h
#define NPChat_h



/**
 *  消息拥有者类型
 */
typedef NS_ENUM(NSUInteger, NPMessageOwner)
{
    MessageOwnerUnknown = 0, /**< 未知的消息拥有者 */
    MessageOwnerSystem,      /**< 系统消息 */
    MessageOwnerSelf,        /**< 自己发送的消息 */
    MessageOwnerOther,       /**< 接收到的他人消息 */
};

/**
 *  消息类型
 */
typedef NS_ENUM(NSUInteger, NPMessageType)
{
    MessageTypeUnknow = 0, /**< 未知的消息类型 */
    MessageTypeDateTime ,  /**< 消息发生的日期时间Cell */
    MessageTypeText,       /**< 文本消息 */
    MessageTypeImage,      /**< 图片消息 */
    MessageTypeVideo,      /**< 视频消息 */
    MessageTypeVoice,      /**< 语音消息 */
  
};

/**
 *  消息发送状态,自己发送的消息时有
 */
typedef NS_ENUM(NSUInteger, NPMessageSendState)
{
    MessageSendSuccess = 0,  /**< 消息发送成功 */
    MessageSendStateSending, /**< 消息发送中 */
    MessageSendFail,          /**< 消息发送失败 */
};

/**
 *  消息读取状态,接收的消息时有
 */
typedef NS_ENUM(NSUInteger, NPMessageReadState)
{
    MessageUnRead = 0, /**< 消息未读 */
    MessageReading,   /**< 正在接收 */
    MessageReaded,     /**< 消息已读 */
};

/**
 *  录音消息的状态
 */
typedef NS_ENUM(NSUInteger, NPVoiceMessageState)
{
    VoiceMessageStateNormal,      /**< 未播放状态 */
    VoiceMessageStateDownloading, /**< 正在下载中 */
    VoiceMessageStatePlaying,     /**< 正在播放 */
    VoiceMessageStateCancel,      /**< 播放被取消 */
};


/**
 *  ChatMessageCell menu对应action类型
 */
typedef NS_ENUM(NSUInteger, NPChatMessageCellMenuActionType)
{
    ChatMessageCellMenuActionTypeCopy,   /**< 复制 */
    ChatMessageCellMenuActionTypeRelay,  /**< 转发 */
    ChatMessageCellMenuActionTypeDelete, /**< 删除 */
};


#pragma mark - Message 相关key值定义

/**
 *  消息类型的key
 */
static NSString *const kNPMessageConfigurationTypeKey = @"messageType";
/**
 *  消息拥有者的key
 */
static NSString *const kNPMessageConfigurationOwnerKey = @"owner";

/**
 *  消息昵称类型的key
 */
static NSString *const kNPMessageConfigurationNicknameKey = @"nickname";

/**
 *  消息头像类型的key
 */
static NSString *const kNPMessageConfigurationAvatarKey = @"avatar";

/**
 *  消息阅读状态类型的key
 */
static NSString *const kNPMessageConfigurationReadStateKey = @"redstatus";

/**
 *  消息发送状态类型的key
 */
static NSString *const kNPMessageConfigurationSendStateKey = @"sendstatus";

/**
 *  文本消息内容的key
 */
static NSString *const kNPMessageConfigurationTextKey = @"text";
/**
 *  图片消息内容的key
 */

static NSString *const kNPMessageConfigurationImageKey = @"image";
/**
 *  视频消息内容的key
 */

static NSString *const kNPMessageConfigurationVideoKey = @"video";
/**
 *  语音消息内容的key
 */

static NSString *const kNPMessageConfigurationVoiceKey = @"voice";

/**
 *  语音消息时长key
 */
static NSString *const kNPMessageConfigurationVoiceSecondsKey = @"durtion";



#endif /* NPChat_h */
