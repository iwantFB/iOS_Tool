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

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    [self p_updateCircleMask];
//}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];

    CGFloat centerX = CGRectGetMidX(self.bounds);
    CGFloat centerY = CGRectGetMidY(self.bounds);
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    NSInteger cornerRadius = MIN(width, height)/2.0;
    
    if(CGSizeEqualToSize(_cornerSize, CGSizeZero)){
        _cornerSize = CGSizeMake(cornerRadius, cornerRadius);
    };
    
   UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(centerX-cornerRadius, centerY-cornerRadius, cornerRadius*2.0, cornerRadius*2.0) byRoundingCorners:UIRectCornerAllCorners cornerRadii:_cornerSize];
    self.maskLayer.path = circlePath.CGPath;
    
    self.layer.mask = self.maskLayer;
}

- (void)p_updateCircleMask
{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat centerX = CGRectGetMidX(self.bounds);
    CGFloat centerY = CGRectGetMidY(self.bounds);
    
    CGFloat corner = MIN(width, height)/2.0;
    
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

