//
//  FHAlertHeaderView.m
//  demo
//
//  Created by 胡斐 on 2018/8/6.
//  Copyright © 2018年 胡斐. All rights reserved.
//

#import "FHAlertHeaderView.h"
#import "Masonry.h"

@implementation FHAlertHeaderView

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        
        _titleLb = [[UILabel alloc] init];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _messageLb = [[UILabel alloc] init];
        _messageLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLb];
        [self addSubview:_messageLb];
        
        [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.left.right.equalTo(self);
            make.bottom.equalTo(self->_messageLb.mas_top).offset(-10);
        }];
        [_messageLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-10);
            make.left.right.equalTo(self);
            make.top.equalTo(self.titleLb.mas_bottom).offset(10);
        }];
        
    }
    return self;
}

@end
