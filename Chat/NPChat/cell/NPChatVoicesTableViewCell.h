//
//  NPChatVoicesTableViewCell.h
//  Chat
//
//  Created by mac on 2020/4/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NPChatMessageTableViewCell.h"
#import "NPChat.h"

NS_ASSUME_NONNULL_BEGIN

@interface NPChatVoicesTableViewCell : NPChatMessageTableViewCell
@property (nonatomic, assign) NPVoiceMessageState voiceMessageState;

@end

NS_ASSUME_NONNULL_END
