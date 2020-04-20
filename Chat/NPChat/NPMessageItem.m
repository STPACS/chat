//
//  NPMessageItem.m
//  Chat
//
//  Created by mac on 2020/4/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NPMessageItem.h"
//#import "NPUserManager.h"
#import "NPChat.h"

@implementation NPMessageItem

- (NSUInteger)owner {
    
    NPMessageOwner type;
    
#warning NPUserManager.shared.userId  这里取当前登录人的userID进行对比，如果一样，则是自己发出的
    
    if ([self.fromAccount isEqualToString:[NSString stringWithFormat:@"%@",@""]]) {
        type = MessageOwnerSelf;
    }else {
        type = MessageOwnerOther;
    }
    
    return type;
}

- (NSUInteger)messageType {
    
    NPMessageType type;
    
    if ([self.msgType isEqualToString:@"TEXT"]) {
        type = MessageTypeText;
    }
    else if ([self.msgType isEqualToString:@"PICTURE"]) {
        type = MessageTypeImage;
    }
    else if ([self.msgType isEqualToString:@"VIDEO"]) {
        type = MessageTypeVideo;
    }
    else if ([self.msgType isEqualToString:@"AUDIO"]) {
        type = MessageTypeVoice;
    }
    else {
        type = MessageTypeText;
    }
    return type;
}

@end
