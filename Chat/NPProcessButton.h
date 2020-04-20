//
//  NPProcessButton.h
//  NutritionPlan
//
//  Created by mac on 2020/4/17.
//  Copyright © 2020 laj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface NPProcessButton : UIButton

@property (strong, nonatomic) UIColor *progressBarColor;
@property (strong, nonatomic) UIColor *wrapperColor;
@property (assign, nonatomic) CGFloat progressBarShadowOpacity;
@property (assign, nonatomic) CGFloat progressBarArcWidth;
@property (assign, nonatomic) CGFloat wrapperArcWidth;
@property (assign, nonatomic) CFTimeInterval duration;
@property (assign, nonatomic) CGFloat currentProgress;

- (void)run:(CGFloat)progress;
- (void)pause;
- (void)reset;

@end

NS_ASSUME_NONNULL_END
