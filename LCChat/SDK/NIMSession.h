//
//  NIMSession.h
//  NIMLib
//
//  Created by Netease.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  会话类型
 */
typedef NS_ENUM(NSInteger, NIMSessionType){
    /**
     *  点对点
     */
    NIMSessionTypeP2P  = 0,
    /**
     *  群组
     */
    NIMSessionTypeTeam = 1,
    /**
     *  聊天室
     */
    NIMSessionTypeChatroom = 2,
    /**
     *  超大群
     */
    NIMSessionTypeSuperTeam = 5,
};




/**
 *  会话对象
 */
@interface NIMSession : NSObject

/**
 *  会话ID,如果当前session为team,则sessionId为teamId,如果是P2P则为对方帐号
 */
@property (nonatomic,copy)         NSString *sessionId;

//对方的昵称
@property (nonatomic,copy)         NSString *nickName;

//对方的头像
@property (nonatomic,copy)         NSString *avatarURL;


/**
 *  会话类型,当前仅支持P2P,Team和Chatroom
 */
@property (nonatomic,assign)       NIMSessionType sessionType;


/**
 *  通过id和type构造会话对象
 *
 *  @param sessionId   会话ID
 *  @param sessionType 会话类型
 *
 *  @return 会话对象实例
 */
+ (instancetype)session:(NSString *)sessionId
                   type:(NIMSessionType)sessionType;
+ (instancetype)sessionFromString:(NSString *)sessionString;
@end

NS_ASSUME_NONNULL_END
