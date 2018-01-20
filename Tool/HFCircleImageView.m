//
//  HFCircleImageView.m
//  DEMO
//
//  Created by 夜站 on 2018/1/19.
//  Copyright © 2018年 夜站. All rights reserved.
//

#import "HFCircleImageView.h"

@interface HFCircleImageView()

@property (nonatomic, strong)CAShapeLayer *maskLayer;

@end

@implementation HFCircleImageView

- (void)updateConstraints
{
    [super updateConstraints];
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat centerX = CGRectGetMidX(self.bounds);
    CGFloat centerY = CGRectGetMidY(self.bounds);

    CGFloat corner = MIN(width, height)/2.0;
    NSLog(@"%f",CGRectGetWidth(self.frame));
    NSLog(@"%f",corner);
    NSLog(@"%f",[[UIScreen mainScreen] scale]);
    
    if(CGSizeEqualToSize(_cornerSize, CGSizeZero)){
        _cornerSize = CGSizeMake(corner, corner);
    };
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(centerX-corner, centerY-corner, corner*2.0, corner*2.0) byRoundingCorners:UIRectCornerAllCorners cornerRadii:_cornerSize];
    
    self.maskLayer.path = circlePath.CGPath;

    self.layer.mask = self.maskLayer;
}

#pragma mark-setter/getter
- (CAShapeLayer *)maskLayer
{
    if(!_maskLayer){
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.contentsScale = [[UIScreen mainScreen] scale];
    }
    return _maskLayer;
}
@end
