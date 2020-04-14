

//
//  NPDateTimeTableViewCell.m
//  Chat
//
//  Created by mac on 2020/4/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NPDateTimeTableViewCell.h"
#import <Masonry.h>

@interface NPDateTimeTableViewCell ()

@property (nonatomic, weak) UILabel *systemMessageL;
@property (nonatomic, strong) UIView *systemmessageContentView;
@property (nonatomic, strong, readonly) NSDictionary *systemMessageStyle;

@end

@implementation NPDateTimeTableViewCell
@synthesize systemMessageStyle = _systemMessageStyle;

#pragma mark - 重写基类方法

- (void)updateConstraints
{
    [super updateConstraints];
    [self.systemmessageContentView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(self.contentView.mas_top).with.offset(8);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-8);
        make.width.lessThanOrEqualTo(@([UIApplication sharedApplication].keyWindow.frame.size.width/5*3));
        make.centerX.equalTo(self.contentView.mas_centerX);
        
    }];
}

#pragma mark - 公有方法

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.systemmessageContentView];
    [self updateConstraintsIfNeeded];
}

- (void)configureCellWithData:(id)data
{
    [super configureCellWithData:data];
    
    NPMessageItem *item = data;
    
    self.systemMessageL.attributedText = [[NSAttributedString alloc] initWithString:item.text?item.text:@"" attributes:self.systemMessageStyle];
}

#pragma mark - Getters方法

- (UIView *)systemmessageContentView
{
    if (!_systemmessageContentView)
    {
        _systemmessageContentView = [[UIView alloc] init];
        _systemmessageContentView.backgroundColor = [UIColor lightGrayColor];
        _systemmessageContentView.alpha = .8f;
        _systemmessageContentView.layer.cornerRadius = 6.0f;
        _systemmessageContentView.translatesAutoresizingMaskIntoConstraints = NO;

        UILabel *systemMessageL = [[UILabel alloc] init];
        systemMessageL.numberOfLines = 0;
        
        [_systemmessageContentView addSubview:self.systemMessageL = systemMessageL];
        [systemMessageL mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.edges.equalTo(_systemmessageContentView).with.insets(UIEdgeInsetsMake(8, 16, 8, 16));
        }];
        
        systemMessageL.attributedText = [[NSAttributedString alloc] initWithString:@"2016-4-17" attributes:self.systemMessageStyle];
    }
    return _systemmessageContentView;
}

- (NSDictionary *)systemMessageStyle
{
    if (!_systemMessageStyle)
    {
        UIFont *font = [UIFont systemFontOfSize:14];
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.paragraphSpacing = 0.15 * font.lineHeight;
        style.hyphenationFactor = 1.0;
        style.lineBreakMode = NSLineBreakByWordWrapping;
        style.alignment = NSTextAlignmentCenter;
        _systemMessageStyle = @{
                 NSFontAttributeName: font,
                 NSParagraphStyleAttributeName: style,
                 NSForegroundColorAttributeName: [UIColor whiteColor]
                 };
    }
    return _systemMessageStyle;
}
@end
