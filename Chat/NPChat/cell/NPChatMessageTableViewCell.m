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
    if ((self.messageOwner == MessageOwnerSystem) ||
        (self.messageOwner == MessageOwnerUnknown))
    {
        return;
    }
    
    if (self.messageOwner == MessageOwnerSelf)
    {
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.right.equalTo(self.contentView.mas_right).with.offset(-16);
            make.top.equalTo(self.contentView.mas_top).with.offset(16);
            make.width.equalTo(@50);
            make.height.equalTo(@50);
        }];
        
        
        [self.messageContentView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.right.equalTo(self.headImageView.mas_left).with.offset(-6);
            make.top.equalTo(self.contentView.mas_top).with.offset(14);
            make.width.lessThanOrEqualTo(@(SCREEN_WIDTH/5*3)).priorityHigh();
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-16).priorityLow();
        }];
        
        [self.messageResendButton mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.right.equalTo(self.messageContentView.mas_left).with.offset(-6);
             make.centerY.equalTo(self.messageContentView.mas_centerY).with.offset(0);
             make.height.mas_equalTo(@(25));
             make.width.mas_equalTo(@(25));
         }];
        
        [self.messageSendStateImageView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.right.equalTo(self.messageContentView.mas_left).with.offset(-8);
            make.centerY.equalTo(self.messageContentView.mas_centerY);
            make.width.equalTo(@50);
            make.height.equalTo(@50);
        }];
        
        [self.messageReadStateImageView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.right.equalTo(self.messageContentView.mas_left).with.offset(-8);
            make.centerY.equalTo(self.messageContentView.mas_centerY);
            make.width.equalTo(@10);
            make.height.equalTo(@10);
        }];
    }
    else if (self.messageOwner == MessageOwnerOther)
    {
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.left.equalTo(self.contentView.mas_left).with.offset(16);
            make.top.equalTo(self.contentView.mas_top).with.offset(16);
            make.width.equalTo(@50);
            make.height.equalTo(@50);
        }];
  
        
        [self.messageContentView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.left.equalTo(self.headImageView.mas_right).with.offset(16);
            make.top.equalTo(self.contentView.mas_top).with.offset(16);
            make.width.lessThanOrEqualTo(@(SCREEN_WIDTH/5*3)).priorityHigh();
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-16).priorityLow();
        }];
        
        [self.messageSendStateImageView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.left.equalTo(self.messageContentView.mas_right).with.offset(8);
            make.centerY.equalTo(self.messageContentView.mas_centerY);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
        }];
        
        [self.messageReadStateImageView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.left.equalTo(self.messageContentView.mas_right).with.offset(8);
            make.centerY.equalTo(self.messageContentView.mas_centerY);
            make.width.equalTo(@10);
            make.height.equalTo(@10);
        }];
    }
    
    [self.messageProgressView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.messageContentView.mas_left).with.offset(4);
         make.right.equalTo(self.messageContentView.mas_right).with.offset(-40);
         make.top.equalTo(self.messageContentView.mas_bottom).with.offset(10);
         make.height.mas_equalTo(@(5));
     }];
    
    [self.messageCancelButton mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.messageProgressView.mas_right).with.offset(4);
         make.top.equalTo(self.messageContentView.mas_bottom).with.offset(1);
         make.height.mas_equalTo(@(20));
         make.width.mas_equalTo(@(20));
     }];
    
    [self.messageContentBackgroundImageView mas_makeConstraints:^(MASConstraintMaker *make)
    {
         make.edges.equalTo(self.messageContentView);
    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    CGPoint touchPoint = [[touches anyObject] locationInView:self.contentView];
    if (CGRectContainsPoint(self.messageContentView.frame, touchPoint))
    {
        self.messageContentBackgroundImageView.highlighted = YES;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    self.messageContentBackgroundImageView.highlighted = NO;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    self.messageContentBackgroundImageView.highlighted = NO;
}


#pragma mark - 私有方法

- (void)setup
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.messageContentView];
    [self.contentView addSubview:self.messageResendButton];
    [self.contentView addSubview:self.messageProgressView];
    [self.contentView addSubview:self.messageCancelButton];
    [self.contentView addSubview:self.messageReadStateImageView];
    [self.contentView addSubview:self.messageSendStateImageView];
    
    self.messageSendStateImageView.hidden = YES;
    self.messageReadStateImageView.hidden = YES;
    self.messageResendButton.hidden       = YES;
    
    if ((MessageTypeImage != [self messageType]) &&
        (MessageTypeVideo != [self messageType]))
    {
        self.messageCancelButton.hidden = YES;
        self.messageProgressView.hidden = YES;
    }
    
    if (self.messageOwner == MessageOwnerSelf)
    {
        [self.messageContentBackgroundImageView setImage:[[UIImage imageNamed:@"message_sender_background_normal"]
                                                          resizableImageWithCapInsets:UIEdgeInsetsMake(30, 16, 16, 24)
                                                          resizingMode:UIImageResizingModeStretch]];
        
        [self.messageContentBackgroundImageView setHighlightedImage:[[UIImage imageNamed:@"message_sender_background_highlight"]
                                                              resizableImageWithCapInsets:UIEdgeInsetsMake(30, 16, 16, 24)
                                                              resizingMode:UIImageResizingModeStretch]];
    }
    else if (self.messageOwner == MessageOwnerOther)
    {
        [self.messageContentBackgroundImageView setImage:[[UIImage imageNamed:@"message_receiver_background_normal"]
                                                   resizableImageWithCapInsets:UIEdgeInsetsMake(30, 16, 16, 24)
                                                   resizingMode:UIImageResizingModeStretch]];
        
        [self.messageContentBackgroundImageView setHighlightedImage:[[UIImage imageNamed:@"message_receiver_background_highlight"]
                                                              resizableImageWithCapInsets:UIEdgeInsetsMake(30, 16, 16, 24)
                                                              resizingMode:UIImageResizingModeStretch]];
    }
    
    self.messageContentView.layer.mask.contents = (__bridge id _Nullable)(self.messageContentBackgroundImageView.image.CGImage);
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

- (void)resendButtonPressed:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCellResend:)])
    {
        [self.delegate messageCellResend:self];
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
    
    [self.headImageView setImage:[UIImage imageNamed:@"avatar.png"]];
    
    if (item.redstatus)
    {
        self.messageReadState = [item.redstatus integerValue];
    }
    
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
    }
    
    if (MessageSendFail == messageSendState)
    {
        self.messageResendButton.hidden = NO;
    }
    else if (MessageSendSuccess == messageSendState)
    {
        self.messageResendButton.hidden = YES;
    }
    
    self.messageSendStateImageView.messageSendState = messageSendState;
}

- (void)setMessageReadState:(NPMessageReadState)messageReadState
{
    _messageReadState = messageReadState;
    if (self.messageOwner == MessageOwnerSelf)
    {
        self.messageSendStateImageView.hidden = YES;
    }
    
    if (MessageUnRead == _messageReadState)
    {
        self.messageReadStateImageView.hidden = NO;
    }
    else
    {
        self.messageReadStateImageView.hidden = YES;
    }
}

#pragma mark - Getters方法
- (UIImageView *)headImageView
{
    if (!_headImageView)
    {
        _headImageView                        = [[UIImageView alloc] init];
        _headImageView.layer.cornerRadius     = 5.0f;
        _headImageView.layer.masksToBounds    = YES;
        _headImageView.backgroundColor        = [UIColor clearColor];
        _headImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapHeadImage:)];
        [_headImageView addGestureRecognizer:tap];
    }
    return _headImageView;
}

- (NPContentView *)messageContentView
{
    if (!_messageContentView)
    {
        _messageContentView = [[NPContentView alloc] init];
    }
    return _messageContentView;
}

- (UIButton *)messageResendButton
{
    if (!_messageResendButton)
    {
        _messageResendButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_messageResendButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_resend_normal"] forState:UIControlStateNormal];
        [_messageResendButton addTarget:self action:@selector(resendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_messageResendButton sizeToFit];
    }
    return _messageResendButton;
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

- (UIImageView *)messageReadStateImageView
{
    if (!_messageReadStateImageView)
    {
        _messageReadStateImageView = [[UIImageView alloc] init];
        _messageReadStateImageView.backgroundColor = [UIColor redColor];
    }
    return _messageReadStateImageView;
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

