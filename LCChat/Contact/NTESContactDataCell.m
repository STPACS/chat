//
//  NTESContactDataCell.m
//  NIM
//
//  Created by chris on 2017/4/7.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESContactDataCell.h"
#import "NTESSessionUtil.h"
@implementation NTESContactDataCell

- (void)refreshUser:(id<NIMGroupMemberProtocol>)member
{
    [super refreshUser:member];
    
    self.textLabel.text = [NSString stringWithFormat:@"%@",member.showName];
}


@end
