//
//  FHAlertSheetView.h
//  demo
//
//  Created by 胡斐 on 2018/8/7.
//  Copyright © 2018年 胡斐. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FHAlertAction.h"

typedef NS_ENUM(NSInteger, FHAlertControllerStyle) {
    FHAlertControllerStyleActionSheet = 0,
    FHAlertControllerStyleAlert
} NS_ENUM_AVAILABLE_IOS(8_0);

@interface FHAlertSheetView : UIView

@property (nonatomic, strong, readonly)NSMutableArray *actions;

///点击按钮的高度
@property (nonatomic, assign) CGFloat itemHeight UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIFont *itemFont UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) CGFloat offsetX UI_APPEARANCE_SELECTOR;

///底部间距
@property (nonatomic, assign) CGFloat offsetY UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) CGFloat animationDuration UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *seperatorColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *destructiveColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) CGFloat space UI_APPEARANCE_SELECTOR;


+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(FHAlertControllerStyle)preferredStyle;

- (void)addAction:(FHAlertAction *)action;

///展示在window上
- (void)show;
///展示在哪个视图上
- (void)showInView:(UIView *)view;

@end
