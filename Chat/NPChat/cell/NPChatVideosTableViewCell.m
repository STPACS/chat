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
    
    
    [self.messageContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(@160);
    }];
    
    [self.thumbnailImageView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.edges.equalTo(self.messageContentView);
        make.height.lessThanOrEqualTo(@160);
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

     if ([item.attach isKindOfClass:[NSString class]])
       {
           NSDictionary *dic = [NSDictionary dictionaryWithJsonString:item.attach];

           [self.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"thumImage"]]];
       }
    
       else
       {
           NSLog(@"未知的视频类型");
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
    
    CGSize imageSize = CGSizeMake(160, 160);

     UIImage *image = self.messageContentBackgroundImageView.image;
     
     UIImageView *imageViewMask = [[UIImageView alloc] initWithImage:image];
     imageViewMask.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
     self.thumbnailImageView.layer.mask = imageViewMask.layer;
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
        _boardcastImageView.image = [UIImage imageNamed:@"action01"];
    }
    return _boardcastImageView;
}

@end
