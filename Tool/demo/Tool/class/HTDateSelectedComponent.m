//
//  HTDateSelectedComponent.m
//  WALNUTT
//
//  Created by 胡斐 on 2019/8/5.
//  Copyright © 2019 WalnutTech. All rights reserved.
//

#import "HTDateSelectedComponent.h"

@interface HTDateSelectedComponent()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *doneBtn;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIDatePicker *datePicker;


@end

@implementation HTDateSelectedComponent

- (instancetype)initWithDateFormatter:(NSString *)dateFormatter
                    selectedDateBlock:(SelectedDateBlcok) selectedBlock
{
    if(self = [super initWithFrame:[UIScreen mainScreen].bounds]){
        _selectedBlock = selectedBlock;
        _dateFormatStr = dateFormatter;
        [self _configSubView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithDateFormatter:@"YYYY-MM-dd"
                     selectedDateBlock:nil];
}

#pragma mark- action
- (void)_cancelBtnAction
{
    [self dismiss];
}

- (void)_doneBtnAction
{
    if(!_dateFormatStr)_dateFormatStr = @"YYYY-MM-dd";
    
    self.dateFormatter.dateFormat = _dateFormatStr;
    NSDate *selectedDate = _datePicker.date;

    NSString *dateStr = [self.dateFormatter stringFromDate:selectedDate];
    if(_selectedBlock)_selectedBlock(dateStr);
    [self dismiss];
}

#pragma mark- public method
- (void)show
{
    [self showToView:[UIApplication sharedApplication].keyWindow];
}

- (void)showToView:(UIView *)targetView
{
    if(!targetView)targetView = [UIApplication sharedApplication].keyWindow;
    
    [targetView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(targetView);
    }];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    [_contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.right.equalTo(self);
    }];
    [UIView animateWithDuration:0.15 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }];
}

- (void)dismiss
{
    [_contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom);
        make.left.right.equalTo(self);
    }];
    [UIView animateWithDuration:0.15 animations:^{
        [self setNeedsLayout];
        [self layoutIfNeeded];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    } completion:^(BOOL finished) {
       [self removeFromSuperview];
    }];
}

#pragma mark- private method
- (void)_configSubView
{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.cancelBtn];
    [self.contentView addSubview:self.doneBtn];
    [self.contentView addSubview:self.datePicker];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_bottom);
    }];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(42);
        make.height.mas_equalTo(47);
        make.left.equalTo(_contentView).offset(13);
        make.top.equalTo(_contentView);
    }];
    [_doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(42);
        make.height.mas_equalTo(47);
        make.right.equalTo(_contentView).offset(-13);
        make.top.equalTo(_contentView);
    }];
    [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_doneBtn.mas_bottom);
        make.bottom.left.right.equalTo(_contentView);
        make.height.mas_equalTo(190*_MAIN_SCALE_IPHONE6);
    }];
}

#pragma mark- setter/getter
- (UIButton *)cancelBtn
{
    if(!_cancelBtn){
        _cancelBtn = [HTUIFactory buttonWithTitleForNormal:NSLocalizedString(@"app_cancel", nil) textColor:UIHEXCOLOR(0x9B9B9B) font:HTSYSTEMFONT(14.0) target:self action:@selector(_cancelBtnAction)];
    }
    return _cancelBtn;
}

- (UIButton *)doneBtn
{
    if(!_doneBtn){
        _doneBtn = [HTUIFactory buttonWithTitleForNormal:NSLocalizedString(@"app_OK", nil) textColor:UIHEXCOLOR(0x303030) font:HTSYSTEMFONT(14.0) target:self action:@selector(_doneBtnAction)];
    }
    return _doneBtn;
}

- (UIDatePicker *)datePicker
{
    if(!_datePicker){
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.date = [NSDate date];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.maximumDate = [NSDate date];
        _datePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:10*365*24*60*60];
    }
    return _datePicker;
}

- (NSDateFormatter *)dateFormatter
{
    if(!_dateFormatter){
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

- (UIView *)contentView
{
    if(!_contentView){
        _contentView = [HTUIFactory viewForBackgroundColor:UIHEXCOLOR(0xF6F6F6)];
    }
    return _contentView;
}


@end
