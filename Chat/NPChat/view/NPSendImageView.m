
//
//  NPSendImageView.m
//  Chat
//
//  Created by mac on 2020/4/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NPSendImageView.h"

@interface NPSendImageView ()

@property (nonatomic, weak) UIActivityIndicatorView *indicatorView;

@end

@implementation NPSendImageView

- (instancetype)init
{
    if ([super init])
    {
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicatorView.hidden = YES;
        [self addSubview:self.indicatorView = indicatorView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.indicatorView.frame = self.bounds;
}

#pragma mark - Setters方法

- (void)setMessageSendState:(NPMessageSendState)messageSendState
{
    _messageSendState = messageSendState;
    if (_messageSendState == MessageSendStateSending)
    {
        [self.indicatorView startAnimating];
        self.indicatorView.hidden = NO;
    }
    else
    {
        [self.indicatorView stopAnimating];
        self.indicatorView.hidden = YES;
    }

    switch (_messageSendState)
    {
        case MessageSendStateSending:
        case MessageSendFail:
            self.hidden = NO;
            break;
        default:
            self.hidden = YES;
            break;
    }
}

@end

