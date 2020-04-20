//
//  NPVoiceView.m
//  NutritionPlan
//
//  Created by mac on 2020/4/16.
//  Copyright © 2020 laj. All rights reserved.
//

#import "NPVoiceView.h"
//#import "NPRecodAudioAnimationView.h"
#import "Marco.h"
#import "NPProcessButton.h"

@interface NPVoiceView(){
    NSInteger timerStatus;//
}
//@property (nonatomic, strong) UILabel *timeLabel;//时间
@property (nonatomic, strong) UILabel *testLabel;//振幅频率
@property (nonatomic, strong) UILabel *tipsLabel;//提示文字
@property (nonatomic, strong) UIButton *actionBtn;//按钮
@property (nonatomic,strong) dispatch_source_t   timer;//计时器
@property (nonatomic, assign) NSInteger recodeTime;//记录时间
@property (nonatomic, strong) UIButton *cancelBtn;//取消按钮
@property (nonatomic, strong) UIButton *sendBtn;//发送按钮
@property (nonatomic, assign) BOOL isAtion;//是否是试听
//@property (nonatomic, strong) NPRecodAudioAnimationView *andome;//动画按钮
//@property (nonatomic,weak) NPMoveView *moveView;      // 播放时振幅
@property (nonatomic,strong) CADisplayLink *levelTimer;     // 振幅计时器
@property (nonatomic, assign) BOOL isNewSize;//

@property (nonatomic) NPProcessButton *progressBarView;

@end

@implementation NPVoiceView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
        [self initViews];
    }
    return self;
}

- (void)initViews {
    
    timerStatus = 0;
    
//    self.timeLabel = ({
//        UILabel *label = UILabel.new;
//        label.preferredMaxLayoutWidth = ScreenWidth() - real(32);
//        label.numberOfLines = 0;
//        label.sz_lineSpace = real(4);
//        label.font = [UIFont systemFontOfSize:real(15)];
//        label.textColor = [NPColor getLogoColor];
//        [self addSubview:label];
//        label.textAlignment = NSTextAlignmentCenter;
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.mas_top).mas_offset(13);
//            make.left.offset(real(126));
//            make.right.offset(real(-126));
//            make.height.offset(real(13));
//        }];
//        label;
//    });
    
    self.actionBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    self.actionBtn.layer.cornerRadius = real(60/2);
    self.actionBtn.layer.masksToBounds = YES;
    [self.actionBtn addTarget:self action:@selector(btnaction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.actionBtn];
    
    [self.actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(real(74), real(74)));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(real(40));
    }];
    
    self.progressBarView = [[NPProcessButton alloc]init];

    self.progressBarView.userInteractionEnabled = NO;
    [self.progressBarView setBackgroundColor:[UIColor clearColor]];
    self.progressBarView.progressBarColor = [UIColor colorWithHexString:@"#3874F5"];
    self.progressBarView.progressBarArcWidth = real(3);
    self.progressBarView.wrapperArcWidth = real(3);
    self.progressBarView.wrapperColor = [UIColor clearColor];
    self.progressBarView.duration = RECORD_TIME;
    self.progressBarView.hidden = YES;
    [self.progressBarView pause];
    [self addSubview: self.progressBarView];

    [self.progressBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(real(77), real(77)));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.actionBtn.mas_centerY);
    }];
    
    self.cancelBtn = ({
        UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
        btn.backgroundColor = [UIColor colorWithHexString:@"#F1F3F8"];
        btn.layer.cornerRadius = real(45/2);
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:real(14)];

        btn.layer.masksToBounds = YES;
        [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(real(45), real(45)));
            make.centerY.mas_equalTo(self.actionBtn.mas_centerY);
            make.right.mas_equalTo(self.actionBtn.mas_left).mas_offset( - real(44));
        }];
        btn;
    });
    
    self.sendBtn = ({
        UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
        btn.backgroundColor = [UIColor colorWithHexString:@"#F1F3F8"];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:real(14)];

        [btn setTitle:@"发送" forState:UIControlStateNormal];
        btn.layer.cornerRadius = real(45/2);
        [btn setTitleColor:[UIColor colorWithHexString:@"3874F5"] forState:UIControlStateNormal];
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(real(45), real(45)));
            make.centerY.mas_equalTo(self.actionBtn.mas_centerY);
            make.left.mas_equalTo(self.actionBtn.mas_right).mas_offset(real(44));
        }];
        btn;
    });
    
    self.cancelBtn.hidden = YES;
    
    self.sendBtn.hidden = YES;

    self.testLabel = ({
        UILabel *label = UILabel.new;
        label.preferredMaxLayoutWidth = ScreenWidth() - real(32);
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:real(11)];
        label.textColor = [UIColor colorWithHexString:@"333333"];
        [self addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.actionBtn.mas_top).mas_offset(-20);
            make.left.offset(real(0));
            make.width.offset(real(60));
            make.height.offset(real(20));
        }];
        label;
    });
    
    self.tipsLabel = ({
        UILabel *label = UILabel.new;
        label.preferredMaxLayoutWidth = ScreenWidth() - real(32);
        label.numberOfLines = 0;
//        label.sz_lineSpace = real(4);
        label.font = [UIFont systemFontOfSize:real(15)];
        label.textColor = [UIColor colorWithHexString:@"#899096"];
        [self addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.actionBtn.mas_bottom).mas_offset(real(15));
            make.left.offset(real(16));
            make.right.offset(real(-16));
            make.height.offset(real(17));
        }];
        label;
    });

    [self initAudio];
}

- (void)stopTimerMeter  {
    [self.levelTimer invalidate];
}

//取消
- (void)cancelAction {
    [self initAudio];

    if ([self.audioDelegate respondsToSelector:@selector(cancelAction)]) {
        [self.audioDelegate cancelAction];
    }
}

//发送
- (void)sendAction {
    [self initAudio];
    
    if ([self.audioDelegate respondsToSelector:@selector(sendAudition:)]) {
        [self.audioDelegate sendAudition:self.recodeTime];
    }
}

- (void)initAudio {
    
    //试听留下的视图
    if(self.timer){
        dispatch_source_cancel(self.timer);
    }
    self.timer = nil;
    //去掉光晕动画
    for (UIView *findLabel in self.subviews) {
        if (findLabel.tag == 10001)
        {
            [findLabel removeFromSuperview ];
        }
    }
    
    timerStatus = 0;
    self.tipsLabel.text = @"点击开始录音";
//    self.timeLabel.text = [NSString stringWithFormat:@"%@",@"00s/ 180s"];
//    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:self.timeLabel.text];
//
//    [AttributedStr addAttribute:NSForegroundColorAttributeName
//
//                          value:[UIColor colorWithHexString:@"#333333"]
//
//                          range:NSMakeRange(self.timeLabel.text.length - 6, 6)];
//
//    self.timeLabel.attributedText = AttributedStr;

    self.cancelBtn.hidden = YES;
    self.sendBtn.hidden = YES;
    self.isAtion = NO;
    [self.actionBtn setBackgroundImage:[UIImage imageNamed:@"luyin_green"] forState:UIControlStateNormal];
}

//开始
- (void)startTimer:(CGFloat)deadlineSecond{
    
    if (!self.isAtion) {
        timerStatus = 1;//开始
    }
    __weak __typeof(self) weakSelf = self;
    
    if (_timer == nil) {
        __block NSInteger timeout = deadlineSecond; // 倒计时时间
        __block NSInteger time = 0; // 时间

        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC,  0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout <= 0){ //  当倒计时结束时做需要的操作:
                    dispatch_source_cancel(weakSelf.timer);
                    weakSelf.timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (!self.isAtion) {
//                            weakSelf.timeLabel.text = @"180s/180s";
//                            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:weakSelf.timeLabel.text];
//
//                            [AttributedStr addAttribute:NSForegroundColorAttributeName
//
//                                                  value:[UIColor colorWithHexString:@"#333333"]
//
//                                                  range:NSMakeRange(weakSelf.timeLabel.text.length - 6, 6)];
//                            weakSelf.timeLabel.attributedText = AttributedStr;
                            
                            [weakSelf stopTimer];
                            [weakSelf stopTimerMeter];

                        }
                    });
                    
                } else {
                    weakSelf.recodeTime = time;
//                    NSString *strTime = [NSString stringWithFormat:@"%02lds/ %@s", (long)time,@"180"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
//                        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:strTime];
//
//                        [AttributedStr addAttribute:NSForegroundColorAttributeName
//
//                                              value:[UIColor colorWithHexString:@"#333333"]
//
//                                              range:NSMakeRange(self.timeLabel.text.length - 6, 6)];
//                        weakSelf.timeLabel.attributedText = AttributedStr;
                        
//                        NPRecodAudioAnimationView *andome = [[NPRecodAudioAnimationView alloc] initWithFrame:weakSelf.actionBtn.frame];
//                        andome.backgroundColor = [UIColor clearColor];
//                        andome.CGfrom_x = weakSelf.actionBtn.bounds.size.width;
//
//                        andome.tag = 10001;
//                        [weakSelf addSubview:andome];
//                        [weakSelf sendSubviewToBack:andome];
//
//                        [UIView animateWithDuration:2 animations:^{
//                            andome.transform = CGAffineTransformScale(andome.transform, 1.5, 1.5);
//                            andome.alpha = 0;
//                        } completion:^(BOOL finished) {
//                            [andome removeFromSuperview];
//                            NPLog(@"结束动画");
//                        }];
                        
                    });
                    timeout--; // 递减 倒计时-1(总时间以秒来计算)
                    time++;
                }
            });
            dispatch_resume(_timer);
        }
    }
    
    if (!self.isAtion) {
        if ([self.audioDelegate respondsToSelector:@selector(startAudio)]) {
            [self.audioDelegate startAudio];
        }
    }
}

- (void)startTimer2:(CGFloat)deadlineSecond{

    __weak __typeof(self) weakSelf = self;
    
    if (_timer == nil) {
        __block NSInteger timeout = deadlineSecond; // 倒计时时间
        __block NSInteger time = 0; // 时间
        
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC,  0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout <= 0){ //  当倒计时结束时做需要的操作:
                    dispatch_source_cancel(weakSelf.timer);
                    weakSelf.timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
//                        NSString *strTime = [NSString stringWithFormat:@"%02lds/ %@s", (long)self.recodeTime,@"180"];
//                        weakSelf.timeLabel.text = strTime;
//
//
//                        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:weakSelf.timeLabel.text];
//
//                        [AttributedStr addAttribute:NSForegroundColorAttributeName
//
//                                              value:[UIColor colorWithHexString:@"#333333"]
//
//                                              range:NSMakeRange(weakSelf.timeLabel.text.length - 6, 6)];
//                        weakSelf.timeLabel.attributedText = AttributedStr;
                        
                        if(weakSelf.timer){
                            dispatch_source_cancel(weakSelf.timer);
                        }
                        weakSelf.timer = nil;
                        //去掉光晕动画
                        for (UIView *findLabel in self.subviews) {
                            if (findLabel.tag == 10001)
                            {
                                [findLabel removeFromSuperview ];
                            }
                        }
                    });
                    
                    
                } else {
                    NSString *strTime = [NSString stringWithFormat:@"%02lds/ %@s", (long)time,@"180"];
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        weakSelf.timeLabel.text = strTime;
//
//                        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:weakSelf.timeLabel.text];
//
//                        [AttributedStr addAttribute:NSForegroundColorAttributeName
//
//                                              value:[UIColor colorWithHexString:@"#333333"]
//
//                                              range:NSMakeRange(weakSelf.timeLabel.text.length - 6, 6)];
//                        weakSelf.timeLabel.attributedText = AttributedStr;
                        
//                        NPRecodAudioAnimationView *andome = [[NPRecodAudioAnimationView alloc] initWithFrame:weakSelf.actionBtn.frame];
//                        andome.backgroundColor = [UIColor clearColor];
//                        andome.CGfrom_x = weakSelf.actionBtn.bounds.size.width;
//
//                        andome.tag = 10001;
//                        [weakSelf addSubview:andome];
//                        [weakSelf sendSubviewToBack:andome];
//
//                        [UIView animateWithDuration:2 animations:^{
//                            andome.transform = CGAffineTransformScale(andome.transform, 1.5, 1.5);
//                            andome.alpha = 0;
//                        } completion:^(BOOL finished) {
//                            [andome removeFromSuperview];
//                            NPLog(@"结束动画");
//                        }];
                        
                    });
                    timeout--; // 递减 倒计时-1(总时间以秒来计算)
                    time++;
                }
            });
            dispatch_resume(_timer);
        }
    }
}

- (void) stopTimer{
    timerStatus = 0;
    if(self.timer){
        dispatch_source_cancel(_timer);
    }
    
    self.tipsLabel.text = @"点击试听";
    self.cancelBtn.hidden = NO;
    self.sendBtn.hidden = NO;
    [self stopTimerMeter];

    _timer = nil;
    if ([self.audioDelegate respondsToSelector:@selector(stopAudio)]) {
        [self.audioDelegate stopAudio];
    }
    
    //去掉光晕动画
    for (UIView *findLabel in self.subviews) {
        if (findLabel.tag == 10001)
        {
            [findLabel removeFromSuperview ];
        }
    }
}

- (void)dealloc {
    [self stopTimer];
}

- (void)btnaction {
    
    if (timerStatus == 0) {
        
        self.isNewSize = YES;

        CGFloat deadlineSecond = 60; //单位秒

        [self startTimer:deadlineSecond];
        self.tipsLabel.text = @"点击停止录音";
        [self.actionBtn setBackgroundImage:[UIImage imageNamed:@"over_green"] forState:UIControlStateNormal];

        self.progressBarView.hidden = NO;
        [self.progressBarView run: deadlineSecond];
        
    }else if (timerStatus == 1){
        
        self.progressBarView.hidden = YES;
        [self.progressBarView reset];
        
        [self stopTimer];
        [self.actionBtn setBackgroundImage:[UIImage imageNamed:@"action_green"] forState:UIControlStateNormal];

        timerStatus = 2;
    }else {
        //试听
        if ([self.audioDelegate respondsToSelector:@selector(audition)]) {
            [self.audioDelegate audition];
        }
        
        if(self.timer){
            dispatch_source_cancel(_timer);
        }
        
        _timer = nil;

        self.isAtion = YES;
        [self startTimer2:self.recodeTime];
    }
    
    [self sizeToFit];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(size.width, 216.f);
}

@end
