//
//  NPKeyboardView.m
//  Chat
//
//  Created by mac on 2020/4/10.
//  Copyright © 2020 mac. All rights reserved.
//

#import "NPKeyboardView.h"
#import "NPChatMoreView.h"
#import "Masonry.h"

@interface NPKeyboardView ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ChatMoreViewDelegate,ChatMoreViewDataSource>

@property (strong, nonatomic) UIButton *voiceButton;       /**< 切换录音模式按钮 */
@property (strong, nonatomic) UIButton *voiceRecordButton; /**< 录音按钮 */

@property (strong, nonatomic) UIButton *moreButton;        /**< 更多按钮 */
@property (strong, nonatomic) NPChatMoreView *moreView;    /**< 当前活跃的底部view,用来指向moreView */
@property (strong, nonatomic) UITextView *textView;

@property (assign, nonatomic, readonly) CGFloat bottomHeight;
@property (strong, nonatomic, readonly) UIViewController *rootViewController;

@property (assign, nonatomic) CGRect keyboardFrame;
@property (copy, nonatomic) NSString *inputText;

@end

@implementation NPKeyboardView

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        [self setup];
    }
    return self;
}

- (void)updateConstraints
{
    [super updateConstraints];
    [self.voiceButton mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.left.equalTo(self.mas_left).with.offset(10);
        make.top.equalTo(self.mas_top).with.offset(8);
        make.width.equalTo(self.voiceButton.mas_height);
    }];
    
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.top.equalTo(self.mas_top).with.offset(8);
        make.width.equalTo(self.moreButton.mas_height);
    }];

    [self.textView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.left.equalTo(self.voiceButton.mas_right).with.offset(10);
        make.right.equalTo(self.moreButton.mas_left).with.offset(-10);
        make.top.equalTo(self.mas_top).with.offset(4);
        make.bottom.equalTo(self.mas_bottom).with.offset(-4);
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [self sendTextMessage:textView.text];
        return NO;
    }
    else if (text.length == 0)
    {
        //判断删除的文字是否符合表情文字规则
        NSString *deleteText = [textView.text substringWithRange:range];
        if ([deleteText isEqualToString:@"]"])
        {
            NSUInteger location = range.location;
            NSUInteger length = range.length;
            NSString *subText;
            while (YES) {
                if (location == 0)
                {
                    return YES;
                }
                location -- ;
                length ++ ;
                subText = [textView.text substringWithRange:NSMakeRange(location, length)];
                if (([subText hasPrefix:@"["] && [subText hasSuffix:@"]"])) {
                    break;
                }
            }
            textView.text = [textView.text stringByReplacingCharactersInRange:NSMakeRange(location, length) withString:@""];
            [textView setSelectedRange:NSMakeRange(location, 0)];
            [self textViewDidChange:self.textView];
            return NO;
        }
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.moreButton.selected = self.voiceButton.selected = NO;
    [self showMoreView:NO];
    [self showVoiceView:NO];
    return YES;
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self sendImageMessage:image imageType:NO];
    [self.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.rootViewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - ChatMoreViewDelegate & ChatMoreViewDataSource

- (void)moreView:(NPChatMoreView *)moreView selectIndex:(ChatMoreItemType)itemType
{
    switch (itemType)
    {
        case ChatMoreItemImageAlbum:
        {
            //显示相册
            UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
            pickerC.delegate = self;
            [self.rootViewController presentViewController:pickerC animated:YES completion:nil];
            break;
        }
        case ChatMoreItemImage:
        {
            //显示拍照
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您的设备不支持拍照" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                break;
            }
            UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
            pickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerC.delegate = self;
            [self.rootViewController presentViewController:pickerC animated:YES completion:nil];
            break;
        }
        case ChatMoreItemVideoAlbum:
        {
            //显示视频相册
            break;
        }
        case ChatMoreItemVideo:
        {
            //显示拍视频
            break;
        }
  
        default:
            break;
    }
}

- (NSArray *)titlesOfMoreView:(NPChatMoreView *)moreView
{
    return @[@"拍照",
             @"照片",
             @"视频",
             ];
}

- (NSArray *)imageNamesOfMoreView:(NPChatMoreView *)moreView
{
    return @[@"chat_bar_icons_pic_camera",
             @"chat_bar_icons_pic",
             @"chat_bar_icons_video",
             ];
}

#pragma mark - 公有方法

- (void)endInputing
{
    [self showViewWithType:FunctionViewShowNothing];
}

#pragma mark - 私有方法

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.keyboardFrame = CGRectMake(0, BottomHeight, 0, BottomHeight);
    [self textViewDidChange:self.textView];
}

- (void)keyboardFrameWillChange:(NSNotification *)notification
{
    self.keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self textViewDidChange:self.textView];
    [self updateConstraints];
}

- (void)setup
{
    [self addSubview:self.voiceButton];
    [self addSubview:self.moreButton];
    [self addSubview:self.textView];
    [self.textView addSubview:self.voiceRecordButton];
    
    UIImageView *topLine = [[UIImageView alloc] init];
    topLine.backgroundColor = [UIColor colorWithRed:184/255.0f green:184/255.0f blue:184/255.0f alpha:1.0f];
    [self addSubview:topLine];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.mas_equalTo(@.5f);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.backgroundColor = [UIColor colorWithRed:235/255.0f green:236/255.0f blue:238/255.0f alpha:1.0f];
    [self updateConstraintsIfNeeded];
    
    [self layoutIfNeeded];
}

- (void)longPressForRecord:(UILongPressGestureRecognizer *)press
{
    static BOOL bSend;
    switch (press.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            [self startRecordVoice];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint currentPoint = [press locationInView:press.view];
            
            if (currentPoint.y < -50)
            {
                [self updateCancelRecordVoice];
                bSend = NO;
            }
            else
            {
                bSend = YES;
                [self updateContinueRecordVoice];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            if (bSend)
            {
                [self endRecordVoice];
            }
            else
            {
                [self cancelRecordVoice];
            }
            break;
        }
        case UIGestureRecognizerStateFailed:
            NSLog(@"failed");
            break;
        default:
            break;
    }
}

- (void)startRecordVoice
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(startRecordVoice)])
    {
        [self.delegate startRecordVoice];
    }
}

- (void)cancelRecordVoice
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelRecordVoice)])
    {
        [self.delegate cancelRecordVoice];
    }
}

- (void)endRecordVoice
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(endRecordVoice)])
    {
        [self.delegate endRecordVoice];
    }

}

- (void)updateCancelRecordVoice
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateCancelRecordVoice)])
    {
        [self.delegate updateCancelRecordVoice];
    }
}

- (void)updateContinueRecordVoice
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateContinueRecordVoice)])
    {
        [self.delegate updateContinueRecordVoice];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGRect addBarFrame = self.frame;
    addBarFrame.size.height = 45;
    addBarFrame.origin.y = SCREEN_HEIGHT - self.bottomHeight - naviBarHeight  - addBarFrame.size.height;
    [self setFrame:addBarFrame animated:NO];

}

- (CGFloat)bottomHeight
{
    
    if (self.moreView.superview)
    {
        return MAX(self.keyboardFrame.size.height, self.moreView.frame.size.height + BottomHeight);
    }
    else
    {
        return MAX(self.keyboardFrame.size.height, CGFLOAT_MIN);
    }
    
}

- (void)showViewWithType:(FunctionViewShowType)showType
{
    //显示对应的View
    [self showMoreView:showType == FunctionViewShowMore && self.moreButton.selected];
    [self showVoiceView:showType == FunctionViewShowVoice && self.voiceButton.selected];
    
    switch (showType)
    {
        case FunctionViewShowNothing:
        case FunctionViewShowVoice:
        {
            self.inputText = self.textView.text;
            self.textView.text = nil;
            [self setFrame:CGRectMake(0, SCREEN_HEIGHT - BottomHeight - npToolbarHeight - naviBarHeight, SCREEN_WIDTH, npToolbarHeight) animated:NO];
            [self.textView resignFirstResponder];
            break;
        }
        case FunctionViewShowMore:
        {
            self.inputText = self.textView.text;
            
            
            [self setFrame:CGRectMake(0, SCREEN_HEIGHT - kFunctionViewHeight - naviBarHeight  - BottomHeight - npToolbarHeight, SCREEN_WIDTH,kFunctionViewHeight + npToolbarHeight) animated:NO];
            [self.textView resignFirstResponder];
//            [self textViewDidChange:self.textView];
            break;
        }
        case FunctionViewShowKeyboard:
            self.textView.text = self.inputText;
            [self textViewDidChange:self.textView];
            self.inputText = nil;
            break;
        default:
            break;
    }
    
}

- (void)buttonAction:(UIButton *)button
{
    self.inputText = self.textView.text;
    FunctionViewShowType showType = button.tag;
    
    //更改对应按钮的状态
   if (button == self.moreButton)
    {
        [self.moreButton setSelected:!self.moreButton.selected];
        [self.voiceButton setSelected:NO];
    }
    else if (button == self.voiceButton)
    {
        [self.moreButton setSelected:NO];
        [self.voiceButton setSelected:!self.voiceButton.selected];
    }
    
    if (!button.selected)
    {
        showType = FunctionViewShowKeyboard;
        [self.textView becomeFirstResponder];
    }
    else
    {
        self.inputText = self.textView.text;
    }
    
    [self showViewWithType:showType];
}



- (void)showMoreView:(BOOL)isShow
{
    if (isShow)
    {
        [self.superview addSubview:self.moreView];
        [UIView animateWithDuration:.3 animations:^
        {
            
            [self.moreView setFrame:CGRectMake(0, SCREEN_HEIGHT - kFunctionViewHeight - BottomHeight , SCREEN_WIDTH, kFunctionViewHeight)];
        } completion:nil];
    }
    else
    {
        [UIView animateWithDuration:.3 animations:^
        {
            [self.moreView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kFunctionViewHeight)];
        }
        completion:^(BOOL finished)
        {
            [self.moreView removeFromSuperview];
        }];
    }
}

- (void)showVoiceView:(BOOL)isShow
{
    self.voiceButton.selected = isShow;
    self.voiceRecordButton.selected = isShow;
    self.voiceRecordButton.hidden = !isShow;
}

- (void)sendTextMessage:(NSString *)strText
{
    if (!strText || strText.length == 0)
    {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:sendMessage:)])
    {
        [self.delegate chatBar:self sendMessage:strText];
    }
    
    self.inputText = @"";
    self.textView.text = @"";
    [self setFrame:CGRectMake(0, SCREEN_HEIGHT - self.bottomHeight - npToolbarHeight - naviBarHeight, SCREEN_WIDTH, npToolbarHeight) animated:NO];
    [self showViewWithType:FunctionViewShowKeyboard];
}

/**
 *  通知代理发送语音信息
 *
 *  @param seconds   语音时长
 */
- (void)sendVoiceMessage:(NSString *)voiceFileName seconds:(NSTimeInterval)seconds
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:sendVoice:seconds:)])
    {
        [self.delegate chatBar:self sendVoice:voiceFileName seconds:seconds];
    }
}

/**
 *  通知代理发送图片信息
 *
 *  @param image 发送的图片
 */
- (void)sendImageMessage:(UIImage *)image imageType:(BOOL)isGif
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:sendPictures:imageType:)])
    {
        [self.delegate chatBar:self sendPictures:@[image] imageType:isGif];
    }
}

/**
 *  通知代理发送视频信息
 *
 *  @param video 发送的视频
 */
- (void)sendVideoMessage:(NSData *)video
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:sendVideos:)])
    {
        [self.delegate chatBar:self sendVideos:@[video]];
    }
}
#pragma mark - Getters方法

- (NPChatMoreView *)moreView
{
    if (!_moreView)
    {
        _moreView = [[NPChatMoreView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kFunctionViewHeight)];
        _moreView.delegate = self;
        _moreView.dataSource = self;
        _moreView.backgroundColor = self.backgroundColor;
    }
    return _moreView;
}

- (UITextView *)textView
{
    if (!_textView)
    {
        _textView = [[UITextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:16.0f];
        _textView.delegate = self;
        _textView.layer.cornerRadius = 4.0f;
        _textView.layer.borderColor = [UIColor colorWithRed:204.0/255.0f green:204.0/255.0f blue:204.0/255.0f alpha:1.0f].CGColor;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.layer.borderWidth = .5f;
        _textView.layer.masksToBounds = YES;
    }
    return _textView;
}
             
- (UIButton *)voiceButton
{
    if (!_voiceButton)
    {
        _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceButton.tag = FunctionViewShowVoice;
        [_voiceButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_voice_normal"] forState:UIControlStateNormal];
        [_voiceButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_input_normal"] forState:UIControlStateSelected];
        [_voiceButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_voiceButton sizeToFit];
    }
    return _voiceButton;
}

- (UIButton *)voiceRecordButton
{
    if (!_voiceRecordButton) {
        _voiceRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceRecordButton.hidden = YES;
        _voiceRecordButton.frame = self.textView.bounds;
        _voiceRecordButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_voiceRecordButton setBackgroundColor:[UIColor lightGrayColor]];
        _voiceRecordButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_voiceRecordButton setTitle:@"按住说话" forState:UIControlStateNormal];
        UILongPressGestureRecognizer *presss = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressForRecord:)];
        [_voiceRecordButton addGestureRecognizer:presss];
    }
    return _voiceRecordButton;
}

- (UIButton *)moreButton
{
    if (!_moreButton)
    {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.tag = FunctionViewShowMore;
        [_moreButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_more_normal"] forState:UIControlStateNormal];
        [_moreButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_input_normal"] forState:UIControlStateSelected];
        [_moreButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_moreButton sizeToFit];
    }
    return _moreButton;
}




- (UIViewController *)rootViewController
{
    return [[UIApplication sharedApplication] keyWindow].rootViewController;
}

#pragma mark - Getters方法

- (void)setFrame:(CGRect)frame animated:(BOOL)animated
{
    if (animated)
    {
        [UIView animateWithDuration:.3 animations:^
        {
            [self setFrame:frame];
        }];
    }
    else
    {
        [self setFrame:frame];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBarFrameDidChange:frame:)])
    {
        [self.delegate chatBarFrameDidChange:self frame:frame];
    }
}
@end
