//
//  NPChatMoreItem.m
//  Chat
//
//  Created by mac on 2020/4/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NPChatMoreItem.h"
#import "Masonry.h"

@interface NPChatMoreItem   ()

@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation NPChatMoreItem

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithHexString:@"#F6F7FB"];
        
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make)
    {
//        make.left.equalTo(self.mas_left).with.offset(34);
//        make.centerY.mas_equalTo(self.mas_centerY);
//        make.width.mas_equalTo(real(23.5));
//        make.height.mas_equalTo(real(18));
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make)
//    {
//        make.left.equalTo(self.button.mas_right).with.offset(10.5);
//        make.centerY.equalTo(self.mas_centerY);
//    }];
}

#pragma mark - 公有方法

- (void)fillViewWithTitle:(NSString *)strTitle imageName:(NSString *)strImageName
{
//    self.titleLabel.text = strTitle;
    [self.button setImage:[UIImage imageNamed:strImageName] forState:UIControlStateNormal];
    [self.button setTitle:strTitle forState:UIControlStateNormal];
//    [self.button setBackgroundImage:[UIImage imageNamed:strImageName] forState:UIControlStateNormal];
    [self updateConstraintsIfNeeded];
}

#pragma mark - 私有方法

- (void)setup
{
    [self addSubview:self.button];
//    [self addSubview:self.titleLabel];
    [self updateConstraintsIfNeeded];
}

- (void)buttonAction
{
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.button setHighlighted:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [self.button setHighlighted:NO];
}

#pragma mark - Getters方法
- (UIButton *)button
{
    if (!_button)
    {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        _button.titleLabel.font = [UIFont boldSystemFontOfSize:real(15)];
        [_button setTitleColor:[UIColor colorWithHexString:@"#666D92"] forState:UIControlStateNormal];
//        _titleLabel.textColor = [UIColor colorWithHexString:@"#666D92"];
//        _button.titleEdgeInsets = UIEdgeInsetsMake(0, real(20), 0, 0);
//        [_button sz_layoutWithMargin:real(5)];
    }
    return _button;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:real(15)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#666D92"];
    }
    return _titleLabel;
}

@end
