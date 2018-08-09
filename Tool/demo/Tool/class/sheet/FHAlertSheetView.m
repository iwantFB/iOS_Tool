//
//  FHAlertSheetView.m
//  demo
//
//  Created by 胡斐 on 2018/8/7.
//  Copyright © 2018年 胡斐. All rights reserved.
//

#import "FHAlertSheetView.h"
#import "FHAlertHeaderView.h"
#import "Masonry.h"

@interface FHLineView:UIView
@end

@implementation FHLineView
- (CGSize)intrinsicContentSize
{return CGSizeMake(1, 1);}
@end

@interface FHActionItem : UIButton
@end
@implementation FHActionItem

- (CGSize)intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    return CGSizeMake(size.width, [FHAlertSheetView appearance].itemHeight);
}

@end

@interface FHAlertSheetView()

@property (nonatomic, assign)FHAlertControllerStyle preferredStyle;

@property (nonatomic ,strong) FHLineView *headerLineView;
/// 顶部视图，包含
@property (nonatomic, strong) FHAlertHeaderView *headerView;

@property (nonatomic, strong) UIStackView *headerActionContentView;
@property (nonatomic, strong) UIStackView *footerActionContentView;

///最主要的弹窗视图，存放headerContentView，footerContentView
@property (nonatomic, strong) UIView *alertContentView;
///上方的响应视图，主要用来做圆角，footerContentView也是一样
@property (nonatomic, strong) UIView *headerContentView;
@property (nonatomic, strong)UIView *footerContentView;

@property (nonatomic, strong)NSMutableArray *actions;

@property (nonatomic, copy) void(^handler)(FHAlertAction *action);

@end

@implementation FHAlertSheetView

#pragma mark- life circle
+ (void)initialize
{
    if (self != [FHAlertSheetView class]) {
        return;
    }
    FHAlertSheetView *appearance = [self appearance];
    appearance.itemHeight = 17;
    appearance.cornerRadius = 4;
    appearance.offsetX = 15;
    appearance.animationDuration = 0.25;
    appearance.seperatorColor = [UIColor colorWithRed:211/255.0 green:211/255.0 blue:211/255.0 alpha:1];
    appearance.offsetY = 10;
    appearance.itemHeight = 50;
    appearance.space = 2;
    appearance.destructiveColor = [UIColor colorWithRed:1 green:5/255.0 blue:7/255.0 alpha:1];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self _setupUI];
    }
    return self;
}

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title
                                 message:(nullable NSString *)message
                          preferredStyle:(FHAlertControllerStyle)preferredStyle
{
    FHAlertSheetView *alertView = [[FHAlertSheetView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alertView.preferredStyle = preferredStyle;
    if(title || message){
        alertView.headerView.titleLb.text = title;
        alertView.headerView.messageLb.text = message;
    }
    
    return alertView;
}

- (void)addAction:(FHAlertAction *)action
{
    _handler = [action valueForKey:@"handler"];
    
    [self.actions addObject:action];
}

#pragma mark- public method
///展示在window上
- (void)show{
    [self showInView:nil];
}
///展示在哪个视图上
- (void)showInView:(UIView *)view
{
    if(!view)view = [UIApplication sharedApplication].keyWindow;

    [view addSubview:self];
    
    [self _configShowUI];
}

- (void)hideAlertView
{
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.backgroundColor = [UIColor clearColor];
        if(self.preferredStyle == FHAlertControllerStyleActionSheet){
            self.alertContentView.transform = CGAffineTransformIdentity;
        }else {
            self.alertContentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        }
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark- private method
- (void)_setupUI
{
    self.backgroundColor = [UIColor clearColor];
}

- (void)_senderHandler:(FHActionItem *)sender
{
    NSInteger index = sender.tag - 1000;
    
    FHAlertAction *action = _actions[index];
    _handler = [action valueForKey:@"handler"];
    __weak FHAlertAction *weakAction = action;
    [self hideAlertView];
    _handler(weakAction);
}

///根据不同的action类型将点击按钮放在不同的位置
- (void)dealWithActionConfig
{
    for (int i = 0; i < _actions.count; i++) {
        FHAlertAction *action = _actions[i];
        FHActionItem *sender = [FHActionItem buttonWithType:UIButtonTypeCustom];
        [sender setTitle:action.title forState:UIControlStateNormal];
        UIColor *textColor = action.style == FHAlertActionStyleDestructive ? self.destructiveColor : action.textColor;
        [sender setTitleColor:textColor forState:UIControlStateNormal];
        sender.titleLabel.font = action.style == FHAlertActionStyleCancel ? [UIFont boldSystemFontOfSize:action.fontSize] : [UIFont systemFontOfSize:action.fontSize];
        [sender addTarget:self action:@selector(_senderHandler:) forControlEvents:UIControlEventTouchUpInside];
        sender.tag = 1000 + i;
        if(_preferredStyle == FHAlertControllerStyleActionSheet && action.style == FHAlertActionStyleCancel){
            [self.footerActionContentView addArrangedSubview:sender];
        }else{
            if(_headerActionContentView.arrangedSubviews.count > 0){
                FHLineView *lineView = [[FHLineView alloc] init];
                lineView.backgroundColor = self.seperatorColor;
                [self.headerActionContentView addArrangedSubview:lineView];
            }
            [self.headerActionContentView addArrangedSubview:sender];
        }
    }
}

- (void)_configShowUI
{
    if(_preferredStyle == FHAlertControllerStyleActionSheet){
        [self _configSheetUI];
    }else if (_preferredStyle == FHAlertControllerStyleAlert){
        [self _configAlertUI];
    }
    
    _headerContentView.layer.cornerRadius = self.cornerRadius;
    _footerContentView.layer.cornerRadius = self.cornerRadius;
}

- (void)_configAlertUI
{
    MASViewAttribute *indexTopConstraint = self.headerContentView.mas_top;
    if(_headerView){
        [self.headerContentView addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.headerContentView);
        }];
        indexTopConstraint = _headerView.mas_bottom;
    }
    
    [self dealWithActionConfig];
    
    if(_actions.count < 3){
        _headerActionContentView.axis = UILayoutConstraintAxisHorizontal;
        _headerActionContentView.distribution = UIStackViewDistributionEqualSpacing;
        _headerActionContentView.spacing = 1;
    }
    
    if(_headerActionContentView){
        [self.headerContentView addSubview:_headerActionContentView];
        [_headerActionContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.headerContentView);
            make.top.equalTo(indexTopConstraint);
        }];
    }
    
    if(_headerContentView){
        [self.alertContentView addSubview:_headerContentView];
        [_headerContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.alertContentView);
        }];
    }
    
    [self dealWithHeaderLine];
    
    [self addSubview:self.alertContentView];
    [_alertContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(self.offsetX);
        make.right.equalTo(self).offset(-self.offsetX);
        make.centerY.equalTo(self);
    }];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    _alertContentView.transform = CGAffineTransformMakeScale(0.01, 0.001);
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.backgroundColor = [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1.0];
        self.alertContentView.transform = CGAffineTransformIdentity;
    }];
}

- (void)dealWithHeaderLine
{
    if(_headerView && _headerActionContentView.arrangedSubviews.count > 0){
        [_headerContentView addSubview:self.headerLineView];
        [_headerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.headerContentView);
            make.top.equalTo(self.headerView.mas_bottom);
        }];
    }
}

- (void)_configSheetUI
{
    
    [self dealWithActionConfig];
    //是否有底部的弹框
    BOOL hasFooter = _footerActionContentView.arrangedSubviews.count != 0;
    BOOL hasHeader = _headerView || _headerActionContentView.arrangedSubviews.count != 0;
    
    MASViewAttribute *indexTopConstraint = self.headerContentView.mas_top;
    MASViewAttribute *indexBottomConstraint;
    if(_headerView){
        [self.headerContentView addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.headerContentView);
        }];
        indexTopConstraint = _headerView.mas_bottom;
        indexBottomConstraint = _headerView.mas_bottom;
        hasHeader = YES;
    }
    
    if(_headerActionContentView.arrangedSubviews.count > 0){
        [self.headerContentView addSubview:_headerActionContentView];
        [_headerActionContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.headerContentView);
            make.top.equalTo(indexTopConstraint).offset(1);
        }];
        
        indexBottomConstraint = _headerActionContentView.mas_bottom;
    }
    
    [self dealWithHeaderLine];
    
    if(hasFooter){
        [self.footerContentView addSubview:_footerActionContentView];
        [_footerActionContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.footerContentView);
        }];
    }
    
    [self addSubview:self.alertContentView];
    [self.alertContentView addSubview:self.footerContentView];
    [self.alertContentView addSubview:self.headerContentView];
    
    if(hasFooter){
        [_footerContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if(hasHeader)make.top.equalTo(self.headerContentView.mas_bottom).offset(self.space);
            else make.top.equalTo(self.alertContentView);
            
            make.bottom.left.right.equalTo(self.alertContentView);
        }];
    }
    if(hasHeader){
        [_headerContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.alertContentView);
            make.bottom.equalTo(indexBottomConstraint);
            if(hasFooter)make.bottom.equalTo(self.footerContentView.mas_top).offset(-self.space);
            else make.bottom.equalTo(self.alertContentView);
        }];
    }
    
    if(!hasHeader && !hasFooter)return;
    [_alertContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(self.offsetX);
        make.right.equalTo(self).offset(-self.offsetX);
        make.top.equalTo(self.mas_bottom);
    }];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.alertContentView.transform = CGAffineTransformMakeTranslation(0, -self.alertContentView.bounds.size.height - self.offsetY);
        self.backgroundColor = [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1.0];
    }];
}

- (UIStackView *)createStackView
{
    UIStackView *actionContentView = [[UIStackView alloc] init];
    actionContentView.axis = UILayoutConstraintAxisVertical;
    actionContentView.distribution = UIStackViewDistributionFill;
    actionContentView.alignment = UIStackViewAlignmentFill;
    return actionContentView;
}

#pragma mark- setter.getter
- (FHAlertHeaderView *)headerView
{
    if(!_headerView){
        _headerView = [[FHAlertHeaderView alloc] init];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

- (UIView *)alertContentView
{
    if(!_alertContentView){
        _alertContentView = [[UIView alloc] init];
    }
    return _alertContentView;
}

- (UIView *)headerContentView
{
    if(!_headerContentView){
        _headerContentView = [[UIView alloc] init];
        _headerContentView.backgroundColor = [UIColor whiteColor];
        _headerContentView.layer.masksToBounds = YES;
    }
    return _headerContentView;
}

- (UIView *)footerContentView
{
    if(!_footerContentView){
        _footerContentView = [[UIView alloc] init];
        _footerContentView.backgroundColor = [UIColor whiteColor];
        _footerContentView.layer.masksToBounds = YES;
    }
    return _footerContentView;
}

- (UIStackView *)headerActionContentView
{
    if(!_headerActionContentView){
        _headerActionContentView = [self createStackView];
    }
    return _headerActionContentView;
}

- (UIStackView *)footerActionContentView
{
    if(!_footerActionContentView){
        _footerActionContentView = [self createStackView];
    }
    return _footerActionContentView;
}

- (FHLineView *)headerLineView
{
    if(!_headerLineView){
        _headerLineView = [[FHLineView alloc] init];
        _headerLineView.backgroundColor = self.seperatorColor;
    }
    return _headerLineView;
}

- (NSMutableArray *)actions
{
    if(!_actions)_actions = [NSMutableArray array];
    return _actions;
}

@end
