//
//  NTESMutiClientsCell.m
//  NIM
//
//  Created by chris on 15/7/22.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESMutiClientsCell.h"
#import "UIView+NTES.h"

@implementation NTESMutiClientsCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.textLabel.font = [UIFont systemFontOfSize:17.f];
    self.textLabel.textColor = UIColor.grayColor;
}

- (void)refreshWidthCilent:(NIMLoginClient *)client{
    self.textLabel.text = [self nameWithClient:client];
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect hitRect = self.kickBtn.frame;
    return CGRectContainsPoint(hitRect, point) ? self : nil;
}

- (NSString *)nameWithClient:(NIMLoginClient *)client{
    return @"正在使用云信";
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.textLabel sizeToFit];
    self.textLabel.centerY = self.height * .5f;
}
@end
