//
//  NPChatImagesTableViewCell.m
//  Chat
//
//  Created by mac on 2020/4/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NPChatImagesTableViewCell.h"
#import <Masonry.h>
#import "NPChat.h"

@interface NPChatImagesTableViewCell()
@property (nonatomic, strong) UIImageView *messageImageView;


@end

@implementation NPChatImagesTableViewCell

- (void)updateConstraints
{
    [super updateConstraints];
    [self.messageImageView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.edges.equalTo(self.messageContentView);
        make.height.lessThanOrEqualTo(@150);
    }];
    
    [self.messageContentView mas_updateConstraints:^(MASConstraintMaker *make)
     {
        make.width.equalTo(@(150));
     }];
}

#pragma mark - 公有方法

- (void)setup
{
    [self.messageContentView addSubview:self.messageImageView];
    [super setup];
}

- (void)configureCellWithData:(id)data
{
    [super configureCellWithData:data];
    NPMessageItem *item = data;

    if ([item.image isKindOfClass:[NSString class]])
    {
        self.messageImageView.image = [UIImage imageNamed:item.image];
    }
 
    else
    {
        NSLog(@"未知的图片类型");
    }
}


#pragma mark - Setters方法

- (void)setUploadProgress:(CGFloat)uploadProgress
{
    [self setMessageSendState:MessageSendStateSending];
    [self.messageProgressView setProgress:uploadProgress];
}

- (void)setMessageSendState:(NPMessageSendState)messageSendState
{
    [super setMessageSendState:messageSendState];
    if (messageSendState == MessageSendStateSending)
    {
        if (!self.messageProgressView.superview)
        {
            [self.contentView addSubview:self.messageProgressView];
            [self.contentView addSubview:self.messageCancelButton];
        }
    }
    else
    {
        [self.messageProgressView removeFromSuperview];
        [self.messageCancelButton removeFromSuperview];
    }
}

#pragma mark - Getters方法

- (UIImageView *)messageImageView
{
    if (!_messageImageView)
    {
        _messageImageView = [[UIImageView alloc] init];
        _messageImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _messageImageView;
    
}


@end
