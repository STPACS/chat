//
//  Category.h
//  Orimuse
//
//  Created by yryz on 16/2/17.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 渐变方式
 
 - IHGradientChangeDirectionLevel:              水平渐变
 - IHGradientChangeDirectionVertical:           竖直渐变
 - IHGradientChangeDirectionUpwardDiagonalLine: 向下对角线渐变
 - IHGradientChangeDirectionDownDiagonalLine:   向上对角线渐变
 */
typedef NS_ENUM(NSInteger, IHGradientChangeDirection) {
    IHGradientChangeDirectionLevel,
    IHGradientChangeDirectionVertical,
    IHGradientChangeDirectionUpwardDiagonalLine,
    IHGradientChangeDirectionDownDiagonalLine,
};

// 颜色(RGB)
#define RGB_COLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]
#define HEX_COLOR(str)          [UIColor colorWithHexString:str]
#define RGBA_COLOR(r, g, b, a)   [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]



@interface UIColor (Helper)

+ (UIColor *)themeColor;
+ (UIColor *)mallThemeColor;

+ (UIColor *)colorWithHexString:(NSString *)colorStr;

+ (UIColor *)colorWithHexString:(NSString *)colorStr darkColor:(NSString *)darkColorStr ;

+ (UIColor *)colorWithHexString:(NSString *)colorStr alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)colorStr darkColor:(NSString *)darkColorStr alpha:(CGFloat)alpha;

/**
 创建渐变颜色
 
 @param size       渐变的size
 @param direction  渐变方式
 @param startcolor 开始颜色
 @param endColor   结束颜色
 
 @return 创建的渐变颜色
 */
+ (instancetype)bm_colorGradientChangeWithSize:(CGSize)size
                                     direction:(IHGradientChangeDirection)direction
                                    startColor:(UIColor *)startcolor
                                      endColor:(UIColor *)endColor;


/**随机色 */
+ (UIColor *)randomColor;


+ (UIColor *)baseColorWithHexString:(NSString *)colorStr alpha:(CGFloat)alpha;

@end

/*! 16进制颜色 */
static inline UIColor * _hex(NSInteger hex) {
    NSString *hexStr = [NSString stringWithFormat:@"%02lX%02lX%02lX", ((hex & 0xFF0000) >> 16), ((hex & 0xFF00) >> 8), (hex & 0xFF)];
    return [UIColor baseColorWithHexString:hexStr alpha:1];
}

/*! 16进制动态颜色 */
static inline UIColor * _hexDynamic(NSInteger hex) {
    NSString *hexStr = [NSString stringWithFormat:@"%02lX%02lX%02lX", ((hex & 0xFF0000) >> 16), ((hex & 0xFF00) >> 8), (hex & 0xFF)];
    return [UIColor colorWithHexString:hexStr];
}
