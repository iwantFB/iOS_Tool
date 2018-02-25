//
//  YZNumberTextField.m
//  NightStation
//
//  Created by jackson on 2018/1/12.
//  Copyright © 2018年 hufei. All rights reserved.
//

#import "HFNumberTextField.h"

#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define isiPhoneX (kScreen_Height == 812 && kScreen_Width == 375)

@interface HFNumberTextField()

//这个button只做展示,添加在键盘上的按钮触发的事件会被忽略,
@property (nonatomic, strong) UIButton *doneBtn;

@property (nonatomic, strong) UIButton *trueDoneBtn;

@end

@implementation HFNumberTextField

#pragma mark- life circle
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self p_configTF];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self p_configTF];
    }
    return self;
}

- (void)dealloc
{
    _doneBtn = nil;
    _trueDoneBtn = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark- private method
- (void)p_configTF
{
    self.keyboardType = UIKeyboardTypeNumberPad;
    self.hideKeyboard = YES;
    
    [self addTarget:self action:@selector(_willbeginEdit) forControlEvents:UIControlEventEditingDidBegin];
    [self addTarget:self action:@selector(_didEndEdit) forControlEvents:UIControlEventEditingDidEnd];
    
    //注册键盘弹起通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark- action
- (void)_willbeginEdit
{
    self.doneBtn.hidden = NO;
    self.trueDoneBtn.hidden = NO;
}

- (void)_didEndEdit
{
    self.doneBtn.hidden = YES;
    self.trueDoneBtn.hidden = YES;
}

- (void)keyboardWillShow:(NSNotification *)noti
{
    if(![self isUseExtensionInputMode]){
        [self configBtnsWithNoti:noti];
    }
}

- (void)configBtnsWithNoti:(NSNotification *)noti
{
    if(!self.doneBtn.superview){
        NSArray *windows = [UIApplication sharedApplication].windows;
        UIWindow *keyboardWindow = nil;
        for (UIWindow *window in windows) {
            if([window isKindOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")]){
                keyboardWindow = window;
            }
        }
        if(keyboardWindow){
            NSArray *views = keyboardWindow.rootViewController.view.subviews;
            UIView *keyboardView = views.lastObject;
            [self performSelector:@selector(addBtns:) withObject:@[keyboardView,keyboardWindow] afterDelay:0.01f];
        }
    }
    CGRect keyboardFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat iphoneX_Space = isiPhoneX?75.f:0.f;//iphoneX 的键盘高度比其他的高出了75
    CGFloat btnWidth = keyboardFrame.size.width / 3.0;
    CGFloat btnHeight = (keyboardFrame.size.height - iphoneX_Space) / 4.0;
    self.doneBtn.frame = CGRectMake(0, btnHeight*3.0, btnWidth, btnHeight);
    self.trueDoneBtn.frame = CGRectMake(0,  keyboardFrame.origin.y + btnHeight*3.0, btnWidth, btnHeight);
}

- (void)addBtns:(NSArray *)superViews {
    if(!_doneBtn.superview)[superViews.firstObject addSubview:_doneBtn];
    if(!_trueDoneBtn.superview)[superViews.lastObject addSubview:_trueDoneBtn];
}

- (void)_doneBtnAction
{
    if(_hideKeyboard)[self resignFirstResponder];
    if(_doneBlock){
        _doneBlock();
    }
}

#pragma mark- private method
//判断是否有第三方输入法
- (BOOL)isUseExtensionInputMode
{
    UITextInputMode *inputMode = [self textInputMode];
    return [NSStringFromClass([inputMode class]) isEqualToString:@"UIKeyboardExtensionInputMode"];
}

#pragma mark- setter/getter
- (void)setDoneBtnTitle:(NSString *)doneBtnTitle
{
    _doneBtnTitle = doneBtnTitle;
    [_doneBtn setTitle:doneBtnTitle forState:UIControlStateNormal];
}

- (UIButton *)doneBtn
{
    if(!_doneBtn){
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        _trueDoneBtn.frame = CGRectMake(0, kScreen_Height, 200, 44);
        [_doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _doneBtn.hidden = YES;
    }
    return _doneBtn;
}

- (UIButton *)trueDoneBtn
{
    if(!_trueDoneBtn){
        _trueDoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _trueDoneBtn.backgroundColor = [UIColor clearColor];
        _trueDoneBtn.frame = CGRectMake(0, kScreen_Height, 200, 44);
        _trueDoneBtn.hidden = YES;
        [_trueDoneBtn addTarget:self action:@selector(_doneBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _trueDoneBtn;
}

@end

