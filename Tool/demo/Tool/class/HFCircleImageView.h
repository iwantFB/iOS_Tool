//
//  HFCircleImageView.h
//  DEMO
//
//  Created by 胡斐 on 2018/1/19.
//  Copyright © 2018年 胡斐. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface HFCircleImageView : UIImageView

/*圆角Size**/
@property (nonatomic, assign)CGSize cornerSize;

@property (nonatomic, assign) CGFloat boarderWidth;
@property (nonatomic, strong) UIColor *boarderColor;

@end
