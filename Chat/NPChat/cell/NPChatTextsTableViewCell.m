

//
//  NPChatTextsTableViewCell.m
//  Chat
//
//  Created by mac on 2020/4/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NPChatTextsTableViewCell.h"
#import "Masonry.h"
#import "NPMessageItem.h"
#import "UIColor+Helper.h"

@interface NPChatTextsTableViewCell ()

@property (nonatomic, strong) UILabel *messageTextL;
@property (nonatomic, copy, readonly) NSDictionary *textStyle;

@end

@implementation NPChatTextsTableViewCell
@synthesize textStyle = _textStyle;

#pragma mark - 重写基类方法

- (void)updateConstraints
{
    [super updateConstraints];
    [self.messageTextL mas_remakeConstraints:^(MASConstraintMaker *make)
    {
//        make.edges.equalTo(self.messageContentView).with.insets(UIEdgeInsetsMake(8, 16, 8, 16));
        make.edges.mas_equalTo(UIEdgeInsetsMake(8, 16, 8, 16));
    }];
}

#pragma mark - 公有方法

- (void)setup
{
    [self.messageContentView addSubview:self.messageTextL];
    [super setup];
}

- (void)configureCellWithData:(id)data
{
    [super configureCellWithData:data];
    
    NPMessageItem *item = data;
    
    NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc ]initWithString:item.body?item.body:@""];
    [attrS addAttributes:self.textStyle range:NSMakeRange(0, attrS.length)];
    self.messageTextL.attributedText = attrS;
}

#pragma mark - Getters方法

- (UILabel *)messageTextL
{
    if (!_messageTextL)
    {
        _messageTextL = [[UILabel alloc] init];
        _messageTextL.textColor = [UIColor blackColor];
        _messageTextL.font = [UIFont systemFontOfSize:16.0f];
        _messageTextL.numberOfLines = 0;
        _messageTextL.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _messageTextL;
}

- (NSDictionary *)textStyle
{
    if (!_textStyle)
    {
        UIFont *font = [UIFont systemFontOfSize:14.0f];
        
        UIColor *color = self.messageOwner == MessageOwnerSelf ? [UIColor colorWithHexString:@"FFFFFF"] : [UIColor colorWithHexString:@"000000"];
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.alignment = NSTextAlignmentLeft;
        style.paragraphSpacing = 0.25 * font.lineHeight;
        style.hyphenationFactor = 1.0;
        _textStyle = @{NSFontAttributeName: font,
                       NSParagraphStyleAttributeName: style,NSForegroundColorAttributeName:color};
    }
    return _textStyle;
}

@end
