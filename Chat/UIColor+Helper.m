//
//  "UIColor+Helper.h"
//  Rrz
//
//  Created by yryz on 16/2/17.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//
#import "UIColor+Helper.h"

@implementation UIColor (Helper)

+ (UIColor *)colorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue a:(CGFloat)alpha {
    
    return [UIColor colorWithRed:red/255.0f
                           green:green/255.0f
                            blue:blue/255.0f
                           alpha:alpha];
}

+ (UIColor *)colorWithHex:(int32_t)rgbValue {
    return [[self class] colorWithHex:rgbValue a:1.0];
}

+ (UIColor *)colorWithHex:(int32_t)rgbValue a:(CGFloat)alpha {
    return [[self class] colorWithR:((float)((rgbValue & 0xFF0000) >> 16))
                                  g:((float)((rgbValue & 0xFF00) >> 8))
                                  b:((float)(rgbValue & 0xFF))
                                  a:alpha];
}

+ (NSString *)colorReverseWithHexString:(NSString *)colorStr{
    NSString *cString = [[colorStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6) {
        cString = @"000000";
    }
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int red, green, blue;
    [[NSScanner scannerWithString:rString] scanHexInt:&red];
    [[NSScanner scannerWithString:gString] scanHexInt:&green];
    [[NSScanner scannerWithString:bString] scanHexInt:&blue];
    NSString *dark = cString;
    if (abs(red - green) < 30 && abs(red - blue) < 30 && abs(green - blue) < 30) {
        NSMutableArray *l = NSMutableArray.array;
        for (NSInteger index = 0; index < cString.length; index++) {
            int num = 0;
            const char * str = [[cString substringWithRange:NSMakeRange(index, 1)] cStringUsingEncoding:NSUTF8StringEncoding];
            sscanf(str, "%x", &num);
            NSInteger r = 15 - num;
            [l addObject:[NSString stringWithFormat:@"%lx", (long)r]];
        }
        dark = [l componentsJoinedByString:@""];
    }
    
    return dark;
}

+ (UIColor *)themeColor {
    return [self colorWithHexString:@"#3874F5" darkColor:@"#3874F5"];
}

+ (UIColor *)mallThemeColor {
    return [self colorWithHexString:@"#FE5500" darkColor:@"#FE5500"];
}

+ (UIColor *)colorWithHexString:(NSString *)colorStr {
    
    NSString *dark = [[self class] colorReverseWithHexString:colorStr];
    
    return [[self class] colorWithHexString:colorStr darkColor:dark alpha:1.0] ;
}

+ (UIColor *)colorWithHexString:(NSString *)colorStr darkColor:(NSString *)darkColorStr {
    
    return [[self class] colorWithHexString:colorStr darkColor:darkColorStr alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)colorStr alpha:(CGFloat)alpha {
    
    NSString *dark = [[self class] colorReverseWithHexString:colorStr];
    
    return [[self class] colorWithHexString:colorStr darkColor:dark alpha:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)colorStr darkColor:(NSString *)darkColorStr alpha:(CGFloat)alpha{
    if (@available(iOS 13.0, *)) {
        UIColor * color = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection)
                           {
            /// 判断当前是深色还是浅色
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight)
            {
                return [[self class] baseColorWithHexString:colorStr alpha:alpha] ;
            }
            else if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)
            {
                return [[self class] baseColorWithHexString:darkColorStr alpha:alpha];
            }
            return [[self class] baseColorWithHexString:colorStr alpha:alpha];
        }];
        return color;
    }
    return [[self class] baseColorWithHexString:colorStr alpha:alpha];
}

+ (UIColor *)baseColorWithHexString:(NSString *)colorStr alpha:(CGFloat)alpha {
    
    NSString *cString = [[colorStr stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int red, green, blue;
    [[NSScanner scannerWithString:rString] scanHexInt:&red];
    [[NSScanner scannerWithString:gString] scanHexInt:&green];
    [[NSScanner scannerWithString:bString] scanHexInt:&blue];
    
    return [[self class] colorWithR:(float)red
                                  g:(float)green
                                  b:(float)blue
                                  a:alpha];
}


+ (instancetype)bm_colorGradientChangeWithSize:(CGSize)size
                                     direction:(IHGradientChangeDirection)direction
                                    startColor:(UIColor *)startcolor
                                      endColor:(UIColor *)endColor {
    
    if (CGSizeEqualToSize(size, CGSizeZero) || !startcolor || !endColor) {
        return nil;
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    
    CGPoint startPoint = CGPointZero;
    if (direction == IHGradientChangeDirectionDownDiagonalLine) {
        startPoint = CGPointMake(0.0, 1.0);
    }
    gradientLayer.startPoint = startPoint;
    
    CGPoint endPoint = CGPointZero;
    switch (direction) {
        case IHGradientChangeDirectionLevel:
            endPoint = CGPointMake(1.0, 0.0);
            break;
        case IHGradientChangeDirectionVertical:
            endPoint = CGPointMake(0.0, 1.0);
            break;
        case IHGradientChangeDirectionUpwardDiagonalLine:
            endPoint = CGPointMake(1.0, 1.0);
            break;
        case IHGradientChangeDirectionDownDiagonalLine:
            endPoint = CGPointMake(1.0, 0.0);
            break;
        default:
            break;
    }
    gradientLayer.endPoint = endPoint;
    
    gradientLayer.colors = @[(__bridge id)startcolor.CGColor, (__bridge id)endColor.CGColor];
    UIGraphicsBeginImageContext(size);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:image];
}

+ (UIColor *)randomColor
{
    CGFloat red     = ( arc4random() % 256);
    CGFloat green   = ( arc4random() % 256);
    CGFloat blue    = ( arc4random() % 256);
    
    return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1];
}


@end
