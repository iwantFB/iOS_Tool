//
//  FHAlertAction.h
//  demo
//
//  Created by 胡斐 on 2018/8/6.
//  Copyright © 2018年 胡斐. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FHAlertActionStyle) {
    FHAlertActionStyleDefault = 0,
    FHAlertActionStyleCancel,
    FHAlertActionStyleDestructive
};

@interface FHAlertAction : NSObject

@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) FHAlertActionStyle style;
@property (nonatomic, readonly) CGFloat fontSize;
@property (nonatomic, readonly) UIColor *textColor;

///系统默认样式
+ (instancetype)actionWithTitle:(nullable NSString *)title style:(FHAlertActionStyle)style handler:(void (^ __nullable)(FHAlertAction *action))handler;

///高度自定义点击的样式
+ (instancetype)actionWithTitle:(nullable NSString *)title fontSize:(CGFloat )fontSize textColor:(UIColor *)textColor style:(FHAlertActionStyle)style handler:(void (^ __nullable)(FHAlertAction *action))handler;

@end
