

//
//  NPChatVoicesTableViewCell.m
//  Chat
//
//  Created by mac on 2020/4/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NPChatVoicesTableViewCell.h"
#import <Masonry.h>
#import "NPVoicePointAnimationView.h"
#import "SZAdapter.h"
#import "NSDictionary+NP.h"

@interface NPChatVoicesTableViewCell ()

@property (nonatomic, strong) NPVoicePointAnimationView *messageVoiceStatusIV;
@property (nonatomic, strong) UILabel *messageVoiceSecondsL;
@property (nonatomic, strong) UIActivityIndicatorView *messageIndicatorV;

@end

@implementation NPChatVoicesTableViewCell

#pragma mark - 重写基类方法


- (void)prepareForReuse
{
    [super prepareForReuse];
    [self setVoiceMessageState:VoiceMessageStateNormal];
}

- (void)updateConstraints
{
    [super updateConstraints];

    if (self.messageOwner == MessageOwnerSelf)
    {
        [self.messageVoiceStatusIV mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.right.equalTo(self.messageContentView.mas_right).with.offset(-12);
            make.centerY.equalTo(self.messageContentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(real(20), real(20)));
        }];
        [self.messageVoiceSecondsL mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.right.equalTo(self.messageVoiceStatusIV.mas_left).with.offset(-8);
            make.centerY.equalTo(self.messageContentView.mas_centerY);
        }];
        [self.messageIndicatorV mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.center.equalTo(self.messageContentView);
            make.width.equalTo(@10);
            make.height.equalTo(@10);
        }];
    }
    else if (self.messageOwner == MessageOwnerOther)
    {
        [self.messageVoiceStatusIV mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.left.equalTo(self.messageContentView.mas_left).with.offset(12);
            make.centerY.equalTo(self.messageContentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(real(20), real(20)));

        }];
        
        [self.messageVoiceSecondsL mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.left.equalTo(self.messageVoiceStatusIV.mas_right).with.offset(8);
            make.centerY.equalTo(self.messageContentView.mas_centerY);
        }];
        [self.messageIndicatorV mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.center.equalTo(self.messageContentView);
            make.width.equalTo(@10);
            make.height.equalTo(@10);
        }];
    }
}

#pragma mark - 公有方法

- (void)setup
{
    [self.messageContentView addSubview:self.messageVoiceSecondsL];
    [self.messageContentView addSubview:self.messageVoiceStatusIV];
    self.messageVoiceStatusIV.userInteractionEnabled = NO;
    [self.messageContentView addSubview:self.messageIndicatorV];
    [super setup];
    self.voiceMessageState = VoiceMessageStateNormal;
}

- (void)configureCellWithData:(id)data
{
    [super configureCellWithData:data];
    
    NPMessageItem *item = data;
    
    NSDictionary *dic = [NSDictionary dictionaryWithJsonString:item.attach];
    
    [self.messageContentView mas_updateConstraints:^(MASConstraintMaker *make)
    {
        make.width.equalTo(@(60 + MIN(20, [[dic objectForKey:@"dur"] floatValue]  *3)));
    }];
    
    self.messageVoiceSecondsL.text = [NSString stringWithFormat:@"%ld''",[[dic objectForKey:@"dur"] integerValue]];
    self.messageVoiceSecondsL.textColor = self.messageOwner == MessageOwnerSelf ?[UIColor colorWithHexString:@"FFFFFF"]:[UIColor colorWithHexString:@"000000"];
}

#pragma mark - Getters方法

- (NPVoicePointAnimationView *)messageVoiceStatusIV
{
    if (!_messageVoiceStatusIV)
    {
        _messageVoiceStatusIV = [[NPVoicePointAnimationView alloc] init];
        _messageVoiceStatusIV.message_self = self.messageOwner == MessageOwnerSelf ;

    }
    return _messageVoiceStatusIV;
}

- (UILabel *)messageVoiceSecondsL
{
    if (!_messageVoiceSecondsL)
    {
        _messageVoiceSecondsL = [[UILabel alloc] init];
        _messageVoiceSecondsL.font = [UIFont systemFontOfSize:14.0f];
        _messageVoiceSecondsL.text = @"0''";
    }
    return _messageVoiceSecondsL;
}

- (UIActivityIndicatorView *)messageIndicatorV
{
    if (!_messageIndicatorV)
    {
        _messageIndicatorV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _messageIndicatorV;
}

#pragma mark - Setters方法

- (void)setVoiceMessageState:(NPVoiceMessageState)voiceMessageState
{
    if (_voiceMessageState != voiceMessageState)
    {
        _voiceMessageState = voiceMessageState;
    }
    
    self.messageVoiceSecondsL.hidden = NO;
    self.messageVoiceStatusIV.hidden = NO;
    self.messageIndicatorV.hidden = YES;
    [self.messageIndicatorV stopAnimating];
    
    
    if (_voiceMessageState == VoiceMessageStatePlaying)
    {
          self.messageVoiceStatusIV.show_animation = YES;

    }
    else if (_voiceMessageState == VoiceMessageStateDownloading)
    {
        self.messageVoiceSecondsL.hidden = YES;
        self.messageVoiceStatusIV.hidden = YES;
        self.messageIndicatorV.hidden = NO;
        [self.messageIndicatorV startAnimating];
    }
    else
    {
        self.messageVoiceStatusIV.stop = YES;
    }
}

@end
