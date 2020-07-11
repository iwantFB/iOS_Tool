//
//  HTUIFactory.m
//  WALNUTT
//
//  Created by WalnutTech on 2018/9/4.
//  Copyright © 2018年 WalnutTech. All rights reserved.
//

#import "HFUIFactory.h"

@implementation HTUIFactory

+ (UILabel *)labelWithFont:(UIFont *)font textColor:(UIColor *)textColor
{
    return [self labelWithFont:font textColor:textColor text:nil];
}

+ (UILabel *)labelWithFont:(UIFont *)font textColor:(UIColor *)textColor text:(NSString *)text
{
    UILabel *lb = [UILabel new];
    lb.font = font;
    lb.textColor = textColor;
    if(text)lb.text = text;
    return lb;
}

+ (UILabel *)centerAlignmentLabelWithFont:(UIFont *)font textColor:(UIColor *)textColor text:(NSString *)text
{
    return ({
        UILabel *lb = [self labelWithFont:font textColor:textColor text:text];
        lb.textAlignment = NSTextAlignmentCenter;
        lb;
    });
}

+ (UIButton *)buttonWithImageStrForNormal:(NSString *)imageStr
                                   target:(id)target
                                   action:(SEL)action
{
    return [self buttonWithImageStrForNormal:imageStr imageStrForSelected:nil target:target action:action];
}

+ (UIButton *)buttonWithImageStrForNormal:(NSString *)imageStr
                      imageStrForSelected:(NSString *)imageStrForSelected
                                   target:(id)target
                                   action:(SEL)action
{
    return [self buttonWithType:UIButtonTypeCustom
              imageStrForNormal:imageStr
            imageStrForSelected:imageStrForSelected
                         target:target
                         action:action];
}

+ (UIButton *)buttonWithTitleForNormal:(NSString *)title
                             textColor:(UIColor *)textColor
                                  font:(UIFont *)font
                                target:(id)target
                                action:(SEL)action
{
    UIButton *btn = [self buttonWithTitle:title
                       textColorForNormal:textColor
                     textColorForSelected:nil
                                   target:target
                                   action:action];
    btn.titleLabel.font = font;
    return btn;
}

+ (UIButton *)buttonWithTitle:(NSString *)title
           textColorForNormal:(UIColor *)normalColor
         textColorForSelected:(UIColor *)selectedColor
                       target:(id)target
                       action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:normalColor forState:UIControlStateNormal];
    if(selectedColor)[btn setTitleColor:selectedColor forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    if([target respondsToSelector:action])[btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+ (UIButton *)buttonWithImageName:(NSString *)imageName
                            title:(NSString *)title
                        textColor:(UIColor *)textColor
                             font:(UIFont *)font
                   titleLeftSpace:(CGFloat)space
                           target:(id)target
                           action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    if([target respondsToSelector:action])[btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+ (UIButton *)systemTypeButtonWithImageStrForNormal:(NSString *)imageStr
                                imageStrForSelected:(NSString *)imageStrForSelected
                                             target:(id)target
                                             action:(SEL)action
{
    return [self buttonWithType:UIButtonTypeSystem
              imageStrForNormal:imageStr
            imageStrForSelected:imageStrForSelected
                         target:target
                         action:action];
}

+ (UIButton *)buttonWithType:(UIButtonType )type
           imageStrForNormal:(NSString *)imageStr
         imageStrForSelected:(NSString *)imageStrForSelected
                      target:(id)target
                      action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if(imageStr.length != 0)[btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    if(imageStrForSelected.length != 0)[btn setImage:[UIImage imageNamed:imageStrForSelected] forState:UIControlStateSelected];
    if([target respondsToSelector:action])[btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+ (UIView *)viewForBackgroundColor:(UIColor *)backgroundColor frame:(CGRect)frame
{
    UIView *view = [UIView new];
    view.frame = frame;
    view.backgroundColor = backgroundColor;
    return view;
}

+ (UIView *)viewForBackgroundColor:(UIColor *)backgroundColor
{
    return [self viewForBackgroundColor:backgroundColor frame:CGRectZero];
}

#pragma mark- tableView
+ (UITableView *)tableViewWithTableStyle:(UITableViewStyle )tableStyle
                               cellClass:(Class )cellClass
                              identifier:(NSString *)identifier
                                delegate:(id<UITableViewDelegate>)delegate
                              dataSource:(id<UITableViewDataSource>)dataSource
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:tableStyle];
    [tableView registerClass:cellClass forCellReuseIdentifier:identifier];
    tableView.delegate = delegate;
    tableView.dataSource = dataSource;
    tableView.tableFooterView = [UIView new];
    return tableView;
}

+ (UITableView *)tableViewWithTableStyle:(UITableViewStyle )tableStyle
                             cellNIBName:(NSString *)cellNIBName
                              identifier:(NSString *)identifier
                                delegate:(id<UITableViewDelegate>)delegate
                              dataSource:(id<UITableViewDataSource>)dataSource
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:tableStyle];
    [tableView registerNib:[UINib nibWithNibName:cellNIBName bundle:nil] forCellReuseIdentifier:identifier];
    tableView.delegate = delegate;
    tableView.dataSource = dataSource;
    tableView.tableFooterView = [UIView new];
    return tableView;
}

#pragma mark- imageView
+ (UIImageView *)imageViewForAspectFill
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    return imageView;
}

+ (UIImageView *)imageViewWithImageName:(NSString *)imageName
{
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
}

 + (UIImageView *)cellIndicatorImageView
{
    return [self imageViewWithImageName:@"cell_indicator"];
}

@end
