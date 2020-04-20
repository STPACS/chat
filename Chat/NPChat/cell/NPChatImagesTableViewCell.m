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


@end

@implementation NPChatImagesTableViewCell

- (void)updateConstraints
{
    [super updateConstraints];
    
    [self.messageContentView mas_updateConstraints:^(MASConstraintMaker *make)
    {
       make.width.equalTo(@(150));
    }];
    
    [self.messageImageView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.edges.equalTo(self.messageContentView);
        make.height.lessThanOrEqualTo(@150);
    }];
}

//- (void)layoutSubviews{
//    [super layoutSubviews];
//    CALayer *layer              = self.messageContentBackgroundImageView.layer;
//    layer.frame                 = self.messageImageView.frame;
//    self.messageImageView.layer.mask = layer;
//  
//}

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
    
    if ([item.attach isKindOfClass:[NSString class]])
    {
        
        NSDictionary *dic = [NSDictionary dictionaryWithJsonString:item.attach];
        
        [self.messageImageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"url"]]];
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
//        _messageImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _messageImageView;
    
}


@end
