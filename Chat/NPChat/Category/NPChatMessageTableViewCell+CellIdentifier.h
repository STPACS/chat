//
//  NPChatMessageTableViewCell+CellIdentifier.h
//  Chat
//
//  Created by mac on 2020/4/10.
//  Copyright © 2020 mac. All rights reserved.
//


#import "NPChatMessageTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface NPChatMessageTableViewCell (CellIdentifier)

+ (NSString *)cellIdentifierForMessageConfiguration:(NSDictionary *)messageConfiguration;


@end

NS_ASSUME_NONNULL_END
