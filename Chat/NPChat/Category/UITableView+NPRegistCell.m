//
//  UITableView+NPRegistCell.m
//  Chat
//
//  Created by mac on 2020/4/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import "UITableView+NPRegistCell.h"

#import "NPChatTextsTableViewCell.h"
#import "NPChatImagesTableViewCell.h"
#import "NPChatVideosTableViewCell.h"
#import "NPChatVoicesTableViewCell.h"
#import "NPDateTimeTableViewCell.h"

@implementation UITableView (NPRegistCell)

- (void)registerChatMessageCellClass
{
    [self registerClass:[NPChatImagesTableViewCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerSelf_ImageMessage_SingleCell"];
    [self registerClass:[NPChatImagesTableViewCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerOther_ImageMessage_SingleCell"];
    
    [self registerClass:[NPChatVideosTableViewCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerSelf_VideoMessage_SingleCell"];
    [self registerClass:[NPChatVideosTableViewCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerOther_VideoMessage_SingleCell"];

    [self registerClass:[NPChatVoicesTableViewCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerSelf_VoiceMessage_SingleCell"];
    [self registerClass:[NPChatVoicesTableViewCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerOther_VoiceMessage_SingleCell"];
    
    [self registerClass:[NPChatTextsTableViewCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerSelf_TextMessage_SingleCell"];
    [self registerClass:[NPChatTextsTableViewCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerOther_TextMessage_SingleCell"];

    [self registerClass:[NPDateTimeTableViewCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerSystem_DateTimeMessage_SingleCell"];
    [self registerClass:[NPDateTimeTableViewCell class] forCellReuseIdentifier:@"ChatMessageCell_OwnerOther_DateTimeMessage_SingleCell"];
}

@end
