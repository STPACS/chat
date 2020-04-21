//
//  NPChatMessageTableViewCell.m
//  Chat
//
//  Created by mac on 2020/4/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NPChatMessageTableViewCell.h"
#import "NPChatTextsTableViewCell.h"
#import "NPChatImagesTableViewCell.h"
#import "NPChatVideosTableViewCell.h"
#import "NPChatVoicesTableViewCell.h"
#import "NPDateTimeTableViewCell.h"
#import "Masonry.h"
#import "NPMessageItem.h"

@implementation NPChatMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setup];
    }
    return self;
}

#pragma mark - 初始化方法

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        [self setup];
    }
    return self;
}

#pragma mark - 重写基类方法

- (void)updateConstraints
{
    [super updateConstraints];

    if (self.messageOwner == MessageOwnerSelf)
    {
        [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make)
        {
            make.right.equalTo(self.contentView.mas_right).with.offset(-16);
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
            make.width.equalTo(@50);
            make.height.equalTo(@50);
        }];


        [self.messageContentView mas_remakeConstraints:^(MASConstraintMaker *make)
        {
            make.right.equalTo(self.headImageView.mas_left).with.offset(-6);
            make.top.equalTo(self.contentView.mas_top).with.offset(14);
            make.width.lessThanOrEqualTo(@(SCREEN_WIDTH/5*3)).priorityHigh();
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-16).priorityLow();
        }];

        [self.messageSendStateImageView mas_remakeConstraints:^(MASConstraintMaker *make)
        {
            make.right.equalTo(self.messageContentView.mas_left).with.offset(-8);
            make.centerY.equalTo(self.messageContentView.mas_centerY);
            make.width.equalTo(@50);
            make.height.equalTo(@50);
        }];

    }
    else if (self.messageOwner == MessageOwnerOther)
    {
        [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make)
        {
            make.left.equalTo(self.contentView.mas_left).with.offset(16);
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
            make.width.equalTo(@50);
            make.height.equalTo(@50);
        }];

        [self.messageContentView mas_remakeConstraints:^(MASConstraintMaker *make)
        {
            make.left.equalTo(self.headImageView.mas_right).with.offset(6);
            make.top.equalTo(self.contentView.mas_top).with.offset(16);
            make.width.lessThanOrEqualTo(@(SCREEN_WIDTH/5*3)).priorityHigh();
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-16).priorityLow();
        }];

        [self.messageSendStateImageView mas_remakeConstraints:^(MASConstraintMaker *make)
        {
            make.left.equalTo(self.messageContentView.mas_right).with.offset(8);
            make.centerY.equalTo(self.messageContentView.mas_centerY);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
        }];
    }

    [self.messageProgressView mas_remakeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.messageContentView.mas_left).with.offset(4);
         make.right.equalTo(self.messageContentView.mas_right).with.offset(-40);
         make.top.equalTo(self.messageContentView.mas_bottom).with.offset(10);
         make.height.mas_equalTo(@(5));
     }];

    [self.messageCancelButton mas_remakeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.messageProgressView.mas_right).with.offset(4);
         make.top.equalTo(self.messageContentView.mas_bottom).with.offset(1);
         make.height.mas_equalTo(@(20));
         make.width.mas_equalTo(@(20));
     }];

    [self.messageContentBackgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make)
    {
         make.edges.equalTo(self.messageContentView);
    }];
}

#pragma mark - 私有方法

- (void)setup
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.messageContentView];
    [self.contentView addSubview:self.messageProgressView];
    [self.contentView addSubview:self.messageCancelButton];
    [self.contentView addSubview:self.messageSendStateImageView];
    
    self.messageSendStateImageView.hidden = YES;

    if ((MessageTypeImage != [self messageType]) &&
        (MessageTypeVideo != [self messageType]))
    {
        self.messageCancelButton.hidden = YES;
        self.messageProgressView.hidden = YES;
    }

    if (self.messageOwner == MessageOwnerSelf)
    {
        [self.messageContentBackgroundImageView setImage:[[UIImage imageNamed:@"message_sender_background_highlight"]
                                                          resizableImageWithCapInsets:UIEdgeInsetsMake(35, 16, 16, 24)
                                                          resizingMode:UIImageResizingModeStretch]];
    }
    else if (self.messageOwner == MessageOwnerOther)
    {
        [self.messageContentBackgroundImageView setImage:[[UIImage imageNamed:@"message_receiver_background_highlight"]
                                                   resizableImageWithCapInsets:UIEdgeInsetsMake(35, 16, 16, 24)
                                                   resizingMode:UIImageResizingModeStretch]];

    }

    [self.contentView insertSubview:self.messageContentBackgroundImageView belowSubview:self.messageContentView];

    [self updateConstraintsIfNeeded];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.contentView addGestureRecognizer:tap];

}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded)
    {
        CGPoint tapPoint = [tap locationInView:self.contentView];
        if (CGRectContainsPoint(self.messageContentView.frame, tapPoint))
        {
            if ([self.delegate respondsToSelector:@selector(messageCellTappedMessage:)]) {
                [self.delegate messageCellTappedMessage:self];
            }
        }
        else if (CGRectContainsPoint(self.headImageView.frame, tapPoint))
        {
            if ([self.delegate respondsToSelector:@selector(messageCellTappedHead:)]) {
                [self.delegate messageCellTappedHead:self];
            }
        }
        else if (CGRectContainsPoint(self.messageSendStateImageView.frame, tapPoint))
        {
            //点击后，发送中
            self.messageSendStateImageView.messageSendState = MessageSendStateSending;
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageCellResend:)])
            {
               [self.delegate messageCellResend:self];
            }
        }
        
        else
        {
            if ([self.delegate respondsToSelector:@selector(messageCellTappedBlank:)]) {
                [self.delegate messageCellTappedBlank:self];
            }
        }
    }
}

- (void)handleTapHeadImage:(UITapGestureRecognizer *)tap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCellTappedHeadImage:)])
    {
        [self.delegate messageCellTappedHeadImage:self];
    }
}


- (void)cancelButtonPressed:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCellCancel:)])
    {
        [self.delegate messageCellCancel:self];
    }
}

#pragma mark - 公有方法

- (void)configureCellWithData:(id)data
{
    NPMessageItem *item = data;
    
    self.item = item;
    
    [self.headImageView setImage:[UIImage imageNamed:@"AppIcon.png"]];

    if (item.sendstatus)
    {
        self.messageSendState = [item.sendstatus integerValue];
    }
}

#pragma mark - Setters方法

- (void)setMessageSendState:(NPMessageSendState)messageSendState
{
    _messageSendState = messageSendState;

    if (self.messageOwner == MessageOwnerOther)
    {
        self.messageSendStateImageView.hidden = YES;

    }else {
        self.messageSendStateImageView.hidden = NO;
        self.messageSendStateImageView.messageSendState = messageSendState;
    }
    
    
    self.messageSendStateImageView.backgroundColor = UIColor.orangeColor;
    
}

#pragma mark - Getters方法
- (UIImageView *)headImageView
{
    if (!_headImageView)
    {
        _headImageView                        = [[UIImageView alloc] init];
        _headImageView.layer.cornerRadius     = 25.0f;
        _headImageView.layer.masksToBounds    = YES;
        _headImageView.backgroundColor        = [UIColor clearColor];
        _headImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapHeadImage:)];
        [_headImageView addGestureRecognizer:tap];
    }
    return _headImageView;
}

- (UIView *)messageContentView
{
    if (!_messageContentView)
    {
        _messageContentView = [[UIView alloc] init];
        _messageContentView.clipsToBounds = YES;
    }
    return _messageContentView;
}

- (UIButton *)messageCancelButton
{
    if (!_messageCancelButton)
    {
        _messageCancelButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_messageCancelButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_cancel_normal"] forState:UIControlStateNormal];
        [_messageCancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_messageCancelButton sizeToFit];
    }
    return _messageCancelButton;
}

- (UIView *)messageProgressView
{
    if (!_messageProgressView)
    {
        _messageProgressView = [[UIProgressView alloc] init];
        _messageProgressView.progressViewStyle = UIProgressViewStyleDefault;
        _messageProgressView.progressTintColor = [UIColor greenColor];
    }
    return _messageProgressView;
}


- (NPSendImageView *)messageSendStateImageView
{
    if (!_messageSendStateImageView)
    {
        _messageSendStateImageView = [[NPSendImageView alloc] init];
    }
    return _messageSendStateImageView;
}

- (UIImageView *)messageContentBackgroundImageView
{
    if (!_messageContentBackgroundImageView)
    {
        _messageContentBackgroundImageView = [[UIImageView alloc] init];
    }
    return _messageContentBackgroundImageView;
}

- (NPMessageType)messageType
{
    if ([self isKindOfClass:[NPChatTextsTableViewCell class]])
    {
        return MessageTypeText;
    }
    else if ([self isKindOfClass:[NPChatImagesTableViewCell class]])
    {
        return MessageTypeImage;
    }
    else if ([self isKindOfClass:[NPChatVideosTableViewCell class]])
    {
        return MessageTypeVideo;
    }
    else if ([self isKindOfClass:[NPChatVoicesTableViewCell class]])
    {
        return MessageTypeVoice;
    }

    else if ([self isKindOfClass:[NPDateTimeTableViewCell class]])
    {
        return MessageTypeDateTime;
    }

 
    return MessageTypeUnknow;
}

- (NPMessageOwner)messageOwner
{
    if ([self.reuseIdentifier containsString:@"OwnerSelf"])
    {
        return MessageOwnerSelf;
    }
    else if ([self.reuseIdentifier containsString:@"OwnerOther"])
    {
        return MessageOwnerOther;
    }
    else if ([self.reuseIdentifier containsString:@"OwnerSystem"])
    {
        return MessageOwnerSystem;
    }
    return MessageOwnerUnknown;
}

@end

