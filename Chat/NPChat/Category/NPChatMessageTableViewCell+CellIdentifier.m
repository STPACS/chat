
//
//  NPChatMessageTableViewCell+CellIdentifier.m
//  Chat
//
//  Created by mac on 2020/4/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NPChatMessageTableViewCell+CellIdentifier.h"


@implementation NPChatMessageTableViewCell (CellIdentifier)

+ (NSString *)cellIdentifierForMessageConfiguration:(NSDictionary *)messageConfiguration
{
    NPMessageType messageType   = [messageConfiguration[kNPMessageConfigurationTypeKey] integerValue];
    NPMessageOwner messageOwner = [messageConfiguration[kNPMessageConfigurationOwnerKey] integerValue];
    NSString *strIdentifierKey   = @"ChatMessageCell";
    NSString *strOwnerKey;
    NSString *strTypeKey;
    
    switch (messageOwner)
    {
        case MessageOwnerSystem:
            strOwnerKey = @"OwnerSystem";
            break;
        case MessageOwnerOther:
            strOwnerKey = @"OwnerOther";
            break;
        case MessageOwnerSelf:
            strOwnerKey = @"OwnerSelf";
            break;
        default:
            NSAssert(NO, @"Message Owner Unknow");
            break;
    }
    
    switch (messageType)
    {
        case MessageTypeVoice:
            strTypeKey = @"VoiceMessage";
            break;
        case MessageTypeImage:
       
        case MessageTypeVideo:
            strTypeKey = @"VideoMessage";
            break;
       
        case MessageTypeDateTime:
            strTypeKey = @"DateTimeMessage";
            break;
        case MessageTypeText:
            strTypeKey = @"TextMessage";
            break;
       
        default:
            NSAssert(NO, @"Message Type Unknow");
            break;
    }
    

    
    return [NSString stringWithFormat:@"%@_%@_%@_%@",strIdentifierKey,strOwnerKey,strTypeKey,@"SingleCell"];
}


@end
