
//
//  NPVoicePointAnimationView.m
//  NutritionPlan
//
//  Created by mac on 2020/4/20.
//  Copyright © 2020 laj. All rights reserved.
//

#import "NPVoicePointAnimationView.h"
#import "UIView+NTES.h"

@interface NPVoicePointAnimationView(){
    BOOL start;
}

@property(nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIImageView *voiceImageView;

@end

@implementation NPVoicePointAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        [self prepareUI];
    }
    return self;
}

- (void)layoutSubviews {
    self.contentView.frame = CGRectMake(0, 0, self.width, self.height);
    self.voiceImageView.frame = CGRectMake(0, 0, self.width, self.height);
}

- (void)prepareUI {
    
    self.contentView = [[UIView alloc] init];
    [self addSubview:self.contentView];
   
    _voiceImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_voiceImageView];
   
}

- (void)voiceTap {
    
    if (start == NO) {
        [_voiceImageView startAnimating];
        start = YES;
    }else {
        [_voiceImageView stopAnimating];
        start = NO;
    }
}

- (void)setStop:(BOOL)stop {
    if (stop == YES) {
        [_voiceImageView stopAnimating];
    }else {
        
    }
}

- (void)setShow_animation:(BOOL)show_animation {
    _show_animation = show_animation;
    if (show_animation == YES) {
        [_voiceImageView startAnimating];
    }
}

- (void)setMessage_self:(BOOL)message_self {
    _message_self = message_self;
    
    NSArray * animateNames;
    NSString * imageStr;
    if (message_self) {
        animateNames = @[@"message_voice_sender_playing_1",@"message_voice_sender_playing_2",@"message_voice_sender_playing_3"];
        imageStr = @"message_voice_sender_playing_3";
    }else {
        animateNames = @[@"message_voice_receiver_playing_1",@"message_voice_receiver_playing_2",@"message_voice_receiver_playing_3"];
        imageStr = @"message_voice_receiver_playing_3";
    }
    
    UIImage * image = [UIImage imageNamed:imageStr];
    _voiceImageView.image = image;
  
    
    _voiceImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(voiceTap)];
    [_voiceImageView addGestureRecognizer:tap];
    
    
    NSMutableArray * animationImages = [[NSMutableArray alloc] initWithCapacity:animateNames.count];
    for (NSString * animateName in animateNames) {
        UIImage * animateImage = [UIImage imageNamed:animateName];
        [animationImages addObject:animateImage];
    }
    
    _voiceImageView.animationImages = animationImages;
    _voiceImageView.animationDuration = 1.0;
}

@end
