//
//  NPChatVideosTableViewCell.m
//  Chat
//
//  Created by mac on 2020/4/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NPChatVideosTableViewCell.h"
#import <Masonry.h>
#import "NPChat.h"

@interface NPChatVideosTableViewCell ()

@property (nonatomic, strong) UIImageView *thumbnailImageView;

/**
 *  用来显示视频播放的UIImageView
 */
@property (nonatomic, strong) UIImageView *boardcastImageView;

@end

@implementation NPChatVideosTableViewCell

#pragma mark - 重写基类方法

- (void)updateConstraints
{
    [super updateConstraints];
    [self.thumbnailImageView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.edges.equalTo(self.messageContentView);
        make.height.lessThanOrEqualTo(@200);
    }];
    
    [self.boardcastImageView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerX.equalTo(self.thumbnailImageView.mas_centerX).with.offset(0);
         make.centerY.equalTo(self.thumbnailImageView.mas_centerY).with.offset(0);
         make.height.mas_equalTo(@40);
         make.width.mas_equalTo(@40);
     }];
}

#pragma mark - 公有方法

- (void)setup
{
    [self.messageContentView addSubview:self.thumbnailImageView];
    [self.messageContentView addSubview:self.boardcastImageView];
    [super setup];
}

- (void)configureCellWithData:(id)data
{
    [super configureCellWithData:data];
    
    NPMessageItem *item = data;

     if ([item.image isKindOfClass:[NSString class]])
       {
           self.thumbnailImageView.image = [UIImage imageNamed:item.image];
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

- (UIImageView *)thumbnailImageView
{
    if (!_thumbnailImageView)
    {
        _thumbnailImageView = [[UIImageView alloc] init];
        _thumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _thumbnailImageView;
    
}

- (UIImageView *)boardcastImageView
{
    if (!_boardcastImageView)
    {
        _boardcastImageView = [[UIImageView alloc] init];
        _boardcastImageView.contentMode = UIViewContentModeScaleAspectFill;
        _boardcastImageView.image = [UIImage imageNamed:@""];
    }
    return _boardcastImageView;
    
}

@end
