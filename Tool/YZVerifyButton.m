//
//  YZVerifyButton.m
//  NightStation
//
//  Created by 夜站 on 2018/1/12.
//  Copyright © 2018年 胡斐. All rights reserved.
//

#import "YZVerifyButton.h"

#define kButtonDisaleTitleColor [UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1]
#define kButtonNormalTitleColor [UIColor darkGrayColor]
#define kDuration 59

@implementation YZVerifyButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self refreshUI];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]){
        [self p_initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self p_initUI];
        [self refreshUI];
    }
    return self;
}

- (void)p_initUI
{
    [self setTitleColor:kButtonDisaleTitleColor forState:UIControlStateDisabled];
    [self setTitleColor:kButtonNormalTitleColor forState:UIControlStateNormal];
}

- (void)refreshUI
{
    if(_timer)dispatch_source_cancel(_timer);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //设置按钮的样式
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.enabled = YES;
    });
}

dispatch_source_t _timer ;
// 开启倒计时效果
-(void)openCountdown{
    
    __block NSInteger time = kDuration; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            [self refreshUI];
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self setTitle:[NSString stringWithFormat:@"%d秒后重试", seconds] forState:UIControlStateNormal];
                
                self.enabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

@end

