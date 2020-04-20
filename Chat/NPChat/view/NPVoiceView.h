//
//  NPVoiceView.h
//  NutritionPlan
//
//  Created by mac on 2020/4/16.
//  Copyright © 2020 laj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NPVoiceDelegate <NSObject>

- (void)startAudio;//开始录音
- (void)stopAudio;//停止录音
- (void)audition;//试听录音
- (void)Stopaudition;//停止试听录音
- (void)sendAudition:(NSInteger)time;//发送录音
- (void)cancelAction;//取消录音

@end

@interface NPVoiceView : UIView

@property (nonatomic, weak) id<NPVoiceDelegate> audioDelegate;


@end

NS_ASSUME_NONNULL_END
