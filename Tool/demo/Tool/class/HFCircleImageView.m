//
//  HFCircleImageView.m
//  DEMO
//
//  Created by 胡斐 on 2018/1/19.
//  Copyright © 2018年 胡斐. All rights reserved.
//

#import "HFCircleImageView.h"

@interface HFCircleImageView()

@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, strong) CAShapeLayer *boarderLayer;

@end

@implementation HFCircleImageView

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
    if(_boarderWidth > 0 && _boarderColor){
        if(!self.boarderLayer.superlayer)[self.layer addSublayer:self.boarderLayer];
        self.boarderLayer.lineWidth = _boarderWidth;
        self.boarderLayer.path = circlePath.CGPath;
        self.boarderLayer.strokeColor = _boarderColor.CGColor;
    }
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

- (CAShapeLayer *)boarderLayer
{
    if(!_boarderLayer){
        _boarderLayer = [CAShapeLayer layer];
        _boarderLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _boarderLayer;
}

@end
