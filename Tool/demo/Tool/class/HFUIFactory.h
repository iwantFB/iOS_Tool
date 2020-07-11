//
//  HTUIFactory.h
//  WALNUTT
//
//  Created by WalnutTech on 2018/9/4.
//  Copyright © 2018年 WalnutTech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface HTUIFactory : NSObject

#pragma mark- label
+ (UILabel *)labelWithFont:(UIFont *)font textColor:(UIColor *)textColor;

+ (UILabel *)labelWithFont:(UIFont *)font textColor:(UIColor *)textColor text:(NSString *)text;

+ (UILabel *)centerAlignmentLabelWithFont:(UIFont *)font textColor:(UIColor *)textColor text:(NSString *)text;

#pragma mark- button
+ (UIButton *)buttonWithImageStrForNormal:(NSString *)imageStr
                      imageStrForSelected:(NSString *)imageStrForSelected
                                   target:(id)target
                                   action:(SEL)action;

+ (UIButton *)buttonWithImageStrForNormal:(NSString *)imageStr
                                   target:(id)target
                                   action:(SEL)action;

+ (UIButton *)buttonWithTitleForNormal:(NSString *)title
                             textColor:(UIColor *)textColor
                                  font:(UIFont *)font
                                target:(id)target
                                action:(SEL)action;

+ (UIButton *)buttonWithTitle:(NSString *)title
           textColorForNormal:(UIColor *)normalColor
         textColorForSelected:(UIColor *)selectedColor
                       target:(id)target
                       action:(SEL)action;


+ (UIButton *)buttonWithImageName:(NSString *)imageName
                            title:(NSString *)title
                        textColor:(UIColor *)textColor
                             font:(UIFont *)font
                   titleLeftSpace:(CGFloat)space
                           target:(id)target
                           action:(SEL)action;

+ (UIButton *)systemTypeButtonWithImageStrForNormal:(NSString *)imageStr
                      imageStrForSelected:(NSString *)imageStrForSelected
                                   target:(id)target
                                   action:(SEL)action;

#pragma mark- view
+ (UIView *)viewForBackgroundColor:(UIColor *)backgroundColor frame:(CGRect)frame;

+ (UIView *)viewForBackgroundColor:(UIColor *)backgroundColor;

#pragma mark- tableView
+ (UITableView *)tableViewWithTableStyle:(UITableViewStyle )tableStyle
                               cellClass:(Class )cellClass
                                identifier:(NSString *)identifier
                                delegate:(id<UITableViewDelegate>)delegate
                              dataSource:(id<UITableViewDataSource>)dataSource;

+ (UITableView *)tableViewWithTableStyle:(UITableViewStyle )tableStyle
                               cellNIBName:(NSString *)cellNIBName
                              identifier:(NSString *)identifier
                                delegate:(id<UITableViewDelegate>)delegate
                              dataSource:(id<UITableViewDataSource>)dataSource;

#pragma mark- imageView
+ (UIImageView *)imageViewForAspectFill;
+ (UIImageView *)imageViewWithImageName:(NSString *)imageName;
+ (UIImageView *)cellIndicatorImageView;

@end
