//
//  UIImage+ImgSize.h
//  NutritionPlan
//
//  Created by yryz on 2019/8/29.
//  Copyright © 2019 laj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ImgSize)
+ (CGSize)getImageSizeWithURL:(id)URL;

/// 压缩图片
- (UIImage *)resetSizeOfImage;

///设置圆角
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;

///设置圆角
- (UIImage*)resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale;

///设置圆角
- (UIImage*)resizedImageToSize:(CGSize)dstSize;

///图片旋转
- (UIImage *)cropImage:(CGRect)rect;

///将图片进行角度转换
- (UIImage *)fixOrientation;

///链接生成图片
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize;
//通过 layer 生成图片
+ (UIImage *)imageForLayer:(CALayer *)layer;
//生成高斯模糊图片
+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

-(CGSize)imageShowSize;

//重新绘制图片
- (UIImage *)imageWithColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
