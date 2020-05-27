//
//  NTESGroupedContacts.m
//  NIM
//
//  Created by Xuhui on 15/3/2.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESGroupedContacts.h"
#import "NTESContactDataMember.h"

@interface NTESGroupedContacts () 

@end

@implementation NTESGroupedContacts

- (instancetype)init
{
    self = [super init];
    if(self) {
        self.groupTitleComparator = ^NSComparisonResult(NSString *title1, NSString *title2) {
            if ([title1 isEqualToString:@"#"]) {
                return NSOrderedDescending;
            }
            if ([title2 isEqualToString:@"#"]) {
                return NSOrderedAscending;
            }
            return [title1 compare:title2];
        };
        self.groupMemberComparator = ^NSComparisonResult(NSString *key1, NSString *key2) {
            return [key1 compare:key2];
        };
        [self update];
    }
    return self;
}

- (void)update{
    NSMutableArray *contacts = [NSMutableArray array];
    
    {
        NIMKitInfo *info = [[NIMKitInfo alloc]init];
        info.infoId = @"1";
        info.showName = @"张三";
        info.avatarUrlString = @"";
        info.avatarImage = [UIImage imageNamed:@""];
        NTESContactDataMember *contact = [[NTESContactDataMember alloc] init];
        contact.info               = info;
        [contacts addObject:contact];
    }
    
    {
        NIMKitInfo *info = [[NIMKitInfo alloc]init];
        info.infoId = @"2";
        info.showName = @"李四";
        info.avatarUrlString = @"";
        info.avatarImage = [UIImage imageNamed:@""];
        NTESContactDataMember *contact = [[NTESContactDataMember alloc] init];
        contact.info               = info;
        [contacts addObject:contact];
    }
    
    {
        NIMKitInfo *info = [[NIMKitInfo alloc]init];
        info.infoId = @"2";
        info.showName = @"王五";
        info.avatarUrlString = @"";
        info.avatarImage = [UIImage imageNamed:@""];
        NTESContactDataMember *contact = [[NTESContactDataMember alloc] init];
        contact.info               = info;
        [contacts addObject:contact];
    }
    
    [self setMembers:contacts];
}


@end
