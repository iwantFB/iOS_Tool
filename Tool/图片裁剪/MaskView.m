//
//  MaskView.m
//  Calendar
//
//  Created by 胡斐 on 2018/4/20.
//  Copyright © 2018年 胡斐. All rights reserved.
//

#import "MaskView.h"

@interface MaskView ()

@property (nonatomic, strong)CAShapeLayer *shapelayer;

//上下左右四个拉伸点
@property (nonatomic,strong)UIView *topLeftView;
@property (nonatomic,strong)UIView *bottomLeftView;
@property (nonatomic,strong)UIView *topRightView;
@property (nonatomic,strong)UIView *bottomRightView;


@property (nonatomic, assign)CGPoint startPoint;

@end

@implementation MaskView

- (instancetype)init{
    if(self = [super init]){
        [self initConfig];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder]){
        [self initConfig];
    }
    return self;
}

- (void)initConfig{
    _moveViewHeight = 40;
    _moveViewWidth = 40;
    
    self.layer.mask = self.shapelayer;
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    [self addSubview:self.topLeftView];
    [self addSubview:self.topRightView];
    [self addSubview:self.bottomRightView];
    [self addSubview:self.bottomLeftView];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if(CGRectContainsPoint(_topLeftView.frame, point)){
        return _topLeftView;
    }else if(CGRectContainsPoint(_topRightView.frame, point)){
        return _topRightView;
    }else if(CGRectContainsPoint(_bottomLeftView.frame, point)){
        return _bottomLeftView;
    }else if(CGRectContainsPoint(_bottomRightView.frame, point)){
        return _bottomRightView;
    }
    
    for (UIView *subView in self.superview.subviews) {
        if([subView isKindOfClass:[UIScrollView class]]){
            return subView;
        }
    }
    return [super hitTest:point withEvent:event];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:[[UIScreen mainScreen] bounds]];
    
    UIBezierPath *maskPath = [[UIBezierPath bezierPathWithRoundedRect:_maskFrame cornerRadius:2] bezierPathByReversingPath];
    [maskPath appendPath:path];
    
    self.shapelayer.path = maskPath.CGPath;
    
    self.topLeftView.frame = CGRectMake(_maskFrame.origin.x, _maskFrame.origin.y, _moveViewWidth, _moveViewHeight);
    self.topLeftView.center = _maskFrame.origin;
    
    self.topRightView.frame = CGRectMake(_maskFrame.origin.x, _maskFrame.origin.y, _moveViewWidth, _moveViewHeight);
    self.topRightView.center = CGPointMake(CGRectGetMaxX(_maskFrame), _maskFrame.origin.y);
    
    self.bottomLeftView.frame = CGRectMake(_maskFrame.origin.x, _maskFrame.origin.y, _moveViewWidth, _moveViewHeight);
    self.bottomLeftView.center = CGPointMake(_maskFrame.origin.x, CGRectGetMaxY(_maskFrame));
    
    self.bottomRightView.frame = CGRectMake(_maskFrame.origin.x, _maskFrame.origin.y, _moveViewWidth, _moveViewHeight);
    self.bottomRightView.center = CGPointMake(CGRectGetMaxX(_maskFrame), CGRectGetMaxY(_maskFrame));
}

- (void)p_updateMaskLayerWithtargetView:(UIView *)targetView
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:[self bounds]];
    
    NSInteger x = _topLeftView.center.x;
    NSInteger y = _topLeftView.center.y;
    NSInteger width = _bottomRightView.center.x - _bottomLeftView.center.x;
    NSInteger height = _bottomLeftView.center.y - _topLeftView.center.y;
    
    CGRect newFrame = CGRectMake(x, y, width, height);
    UIBezierPath *maskPath = [[UIBezierPath bezierPathWithRoundedRect:newFrame cornerRadius:2] bezierPathByReversingPath];
    [maskPath appendPath:path];
    
    NSLog(@"newFrame = %@",[NSValue valueWithCGRect:newFrame]);
    
    self.shapelayer.path = maskPath.CGPath;
    
}

- (void)p_updateMoveViewWithTargetView:(UIView *)targetView offset:(CGPoint) offset{
    CGFloat target_x = targetView.center.x + offset.x;
    CGFloat target_y = targetView.center.y + offset.y;
    targetView.center = CGPointMake(target_x, target_y);
    if([targetView isEqual:_topLeftView])
    {
        _bottomLeftView.center = CGPointMake(target_x, _bottomLeftView.center.y);
        _topRightView.center = CGPointMake(_topRightView.center.x,target_y);
    }else if ([targetView isEqual:_topRightView])
    {
        _bottomRightView.center = CGPointMake(target_x, _bottomRightView.center.y);
        _topLeftView.center = CGPointMake(_topLeftView.center.x, target_y);
    }else if ([targetView isEqual:_bottomLeftView])
    {
        _topLeftView.center = CGPointMake(target_x, _topLeftView.center.y);
        _bottomRightView.center = CGPointMake(_bottomRightView.center.x, target_y);
    }else if ([targetView isEqual:_bottomRightView])
    {
        _topRightView.center = CGPointMake(target_x, _topRightView.center.y);
        _bottomLeftView.center = CGPointMake(_bottomLeftView.center.x, target_y);
    }
    
    //调整maskLayer的位置
    [self p_updateMaskLayerWithtargetView:targetView];
}

#pragma mark- action
- (void)panGestureAction:(UIPanGestureRecognizer *)sender
{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            _startPoint = [sender locationInView:self];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint movePoint = [sender locationInView:self];
            CGPoint offset = CGPointMake(movePoint.x - _startPoint.x, movePoint.y - _startPoint.y);
            //区分不同位置的手势点
            UIView *targetView = nil;
            if(CGRectContainsPoint(_topLeftView.frame, _startPoint))
            {
                targetView = _topLeftView;
            }else if (CGRectContainsPoint(_bottomLeftView.frame, _startPoint))
            {
                targetView = _bottomLeftView;
            }else if (CGRectContainsPoint(_topRightView.frame, _startPoint))
            {
                targetView = _topRightView;
            }else if (CGRectContainsPoint(_bottomRightView.frame, _startPoint))
            {
                targetView = _bottomRightView;
            }
            [self p_updateMoveViewWithTargetView:targetView offset:offset];
            _startPoint = movePoint;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark- setter/getter
- (CAShapeLayer *)shapelayer
{
    if(!_shapelayer){
        _shapelayer = [CAShapeLayer layer];
        _shapelayer.fillRule = @"even-odd";
    }
    return _shapelayer;
}

- (UIView *)topLeftView
{
    if(!_topLeftView){
        _topLeftView = [[UIView alloc] init];
        //添加手势
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [_topLeftView addGestureRecognizer:panGesture];
    }
    return _topLeftView;
}

- (UIView *)bottomRightView
{
    if(!_bottomRightView){
        _bottomRightView = [[UIView alloc] init];
        //添加手势
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [_bottomRightView addGestureRecognizer:panGesture];
    }
    return _bottomRightView;
}

- (UIView *)bottomLeftView
{
    if(!_bottomLeftView){
        _bottomLeftView = [[UIView alloc] init];
        //添加手势
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [_bottomLeftView addGestureRecognizer:panGesture];
    }
    return _bottomLeftView;
}

- (UIView *)topRightView
{
    if(!_topRightView){
        _topRightView = [[UIView alloc] init];
        //添加手势
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [_topRightView addGestureRecognizer:panGesture];
    }
    return _topRightView;
}



@end

