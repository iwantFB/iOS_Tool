//
//  MaskView.h
//  Calendar
//
//  Created by 胡斐 on 2018/4/20.
//  Copyright © 2018年 胡斐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaskView : UIView

@property (nonatomic, assign)CGRect maskFrame;

//控制移动的上下左右的宽高
@property (nonatomic, assign)CGFloat moveViewWidth;
@property (nonatomic, assign)CGFloat moveViewHeight;

@end
