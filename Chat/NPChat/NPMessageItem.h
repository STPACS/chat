//
//  NPMessageItem.h
//  Chat
//
//  Created by mac on 2020/4/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NPDBModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NPMessageItem : NPDBModel

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, assign) NSInteger durtion;

@property (nonatomic, copy) NSString *kid;

@property (nonatomic, assign) NSUInteger messageType;

@property (nonatomic, assign) NSUInteger owner;

@property (nonatomic, copy) NSString *redstatus;

@property (nonatomic, copy) NSString *sendstatus;




@end

NS_ASSUME_NONNULL_END
