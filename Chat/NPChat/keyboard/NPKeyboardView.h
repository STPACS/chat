//
//  NPKeyboardView.h
//  Chat
//
//  Created by mac on 2020/4/10.
//  Copyright © 2020 mac. All rights reserved.
//

#define kMaxHeight          60.0f
#define npToolbarHeight          50.0f
#define kFunctionViewHeight 210.0f

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FunctionViewShowType)
{
    FunctionViewShowNothing,   /**< 不显示functionView */
    FunctionViewShowFace,      /**< 显示表情View */
    FunctionViewShowVoice,     /**< 显示录音view */
    FunctionViewShowMore,      /**< 显示更多view */
    FunctionViewShowKeyboard,  /**< 显示键盘 */
};


NS_ASSUME_NONNULL_BEGIN

@class NPKeyboardView;

/**
 *  XMKeyboardView代理事件,发送图片,地理位置,文字,语音信息等
 */
@protocol NPKeyboardViewDelegate <NSObject>


@optional

- (void)startAudio;//开始录音
- (void)stopAudio;//停止录音
- (void)audition;//试听录音
- (void)Stopaudition;//停止试听录音
- (void)sendAudition:(NSInteger)time;//发送录音
- (void)cancelAction;//取消录音

/**
 *  chatBarFrame改变回调
 *
 */
- (void)chatBarFrameDidChange:(NPKeyboardView *)chatBar frame:(CGRect)frame;


/**
 *  发送图片信息,支持多张图片
 *
 *  @param pictures 需要发送的图片信息
 */
- (void)chatBar:(NPKeyboardView *)chatBar sendPictures:(NSArray *)pictures imageType:(BOOL)isGif;

/**
 *  发送视频信息,支持多张图片
 *
 *  @param videos 需要发送的视频信息
 */
- (void)chatBar:(NPKeyboardView *)chatBar Message:(NSURL *)videoUrl coverImage:(UIImage *)coverImage duration:(CGFloat)duration;

/**
 *  发送普通的文字信息,可能带有表情
 *
 *  @param message 需要发送的文字信息
 */
- (void)chatBar:(NPKeyboardView *)chatBar sendMessage:(NSString *)message;

@end



@interface NPKeyboardView : UIView

@property (weak, nonatomic) id<NPKeyboardViewDelegate> delegate;

/**
 *  结束输入状态
 */
- (void)endInputing;


@end

NS_ASSUME_NONNULL_END
