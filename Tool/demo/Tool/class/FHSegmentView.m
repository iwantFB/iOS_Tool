//
//  FHSegmentView.m
//  DEMO
//
//  Created by 夜站 on 2018/3/19.
//  Copyright © 2018年 夜站. All rights reserved.
//

#import "FHSegmentView.h"

#define SINGLE_LINE_Height           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)

@interface FHSegmentView()<UIScrollViewDelegate>

//两个按钮之间中心间距,即indexView需要移动的距离
@property (nonatomic, assign) CGFloat itemCenterSpace;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *indexView;
@property (nonatomic, strong) UIView *separatorLineView;//底部分割线
@property (nonatomic, strong) UIScrollView *scrollView;

//按钮数组
@property (nonatomic, copy) NSArray *itemsArr;
@property (nonatomic, assign, readwrite) NSInteger currentIndex;
@end

@implementation FHSegmentView

#pragma mark - life circle
- (instancetype)init{
    return  [self initWithFrame:[UIScreen mainScreen].bounds childVCArr:nil configration:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(CGRectEqualToRect(frame, CGRectZero)){
        NSLog(@"不要设置frame为CGRectZore");
        return nil;
    };
    return [self initWithFrame:frame childVCArr:nil configration:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
                   childVCArr:(nonnull NSArray *)childVCArr
                 configration:(nullable FHSegmentConfiguration *)configration;
{
    self = [super initWithFrame:frame];
    if(self){
        if(!configration)_configration = [FHSegmentConfiguration defaluConfiguration];
        if(childVCArr)_childVCArr = childVCArr;
        [self buildUI];
    }
    return self;
}

#pragma mark- action
- (void)p_itemAction:(UIButton *)sender
{
    NSInteger index = sender.tag - 999;
    if(_currentIndex == index)return;
    _currentIndex = index;
    [self selectIndex:_currentIndex animation:_configration.scrollAnimation];
}

- (void)headerViewAnimation
{
    for (UIButton *item in _itemsArr) {
        item.selected = _currentIndex + 999 == item.tag;
    }
}

- (void)moveIndexViewWithContentOffSetX:(CGFloat)contentOffSetX
{
    CGFloat scale = _itemCenterSpace / CGRectGetWidth(self.scrollView.frame);
    CGFloat moveX = contentOffSetX * scale;
    CGFloat centerX = _configration.insets.left + _configration.itemWidth / 2.0 + moveX;
    CGFloat centerY = _indexView.center.y;
    _indexView.center = CGPointMake(centerX, centerY);
}

#pragma mark- public method
- (void)buildUI
{
    CGFloat selfWidth = CGRectGetWidth(self.frame);
    CGFloat scrollViewHeight = CGRectGetHeight(self.frame) - _configration.segmentHeight;
    NSInteger vcCount = _childVCArr.count;
    
    [self addSubview:self.headerView];
    [self.headerView addSubview:self.indexView];
    [self addSubview:self.scrollView];
    if(_configration.needSeparator){
        [self.headerView addSubview:self.separatorLineView];
        self.separatorLineView.frame = CGRectMake(_configration.separatorInset.left, _configration.segmentHeight - SINGLE_LINE_ADJUST_OFFSET - SINGLE_LINE_Height - _configration.separatorInset.bottom, selfWidth - _configration.separatorInset.left - _configration.separatorInset.right, SINGLE_LINE_Height);
        _separatorLineView.backgroundColor = _configration.separatorColor;
    }
    
    _indexView.backgroundColor = _configration.indexViewColor;
    
    _headerView.frame = CGRectMake(0, 0, selfWidth, _configration.segmentHeight);
    _indexView.frame = CGRectMake(0, _configration.segmentHeight - _configration.indexViewHeight - _configration.indexViewBottomMargin, _configration.indexViewWidth, _configration.indexViewHeight);
    _scrollView.frame = CGRectMake(0, _configration.segmentHeight, selfWidth, scrollViewHeight);
    _scrollView.contentSize = CGSizeMake(selfWidth * vcCount, scrollViewHeight);
    _scrollView.scrollEnabled = _configration.scrollEnable;
    
    if(_configration.segmentColor)_headerView.backgroundColor = _configration.segmentColor;
    
    NSMutableArray *items = [NSMutableArray array];
    for (int i = 0; i < vcCount; i++) {
        UIViewController *childVC = _childVCArr[i];
        
        if(_superViewController){
            [childVC willMoveToParentViewController:_superViewController];
            [_superViewController addChildViewController:childVC];
            [self.scrollView addSubview:childVC.view];
            [childVC didMoveToParentViewController:_superViewController];
        }else{
            [self.scrollView addSubview:childVC.view];
        }
        
        childVC.view.frame = CGRectMake(i * selfWidth, 0, selfWidth, CGRectGetHeight(self.frame) - _configration.segmentHeight);
        
        UIButton *item = [self createButtonWithIndex:i totalCount:vcCount title:childVC.title];
        item.tag = 999 + i;
        [item addTarget:self action:@selector(p_itemAction:) forControlEvents:UIControlEventTouchUpInside];
        [items addObject:item];
        [self.headerView addSubview:item];
    }
    
    _itemsArr = [items copy];
    
    _itemCenterSpace = _configration.itemSpace + _configration.itemWidth;
    
    [self selectIndex:0 animation:_configration.scrollAnimation];
    [self moveIndexViewWithContentOffSetX:0];
}

- (void)selectIndex:(NSInteger )index animation:(BOOL)animation
{
    if(index>=_childVCArr.count)return;
    _currentIndex = index;
    [_scrollView setContentOffset:CGPointMake(index * CGRectGetWidth(self.frame), 0) animated:animation];
    [self headerViewAnimation];
    if(_delegate && [_delegate respondsToSelector:@selector(segmentView:didSelectedTab:)]){
        [_delegate segmentView:self didSelectedTab:_currentIndex];
    }
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    [self moveIndexViewWithContentOffSetX:offsetX];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    _currentIndex = offsetX / CGRectGetWidth(self.scrollView.frame);
    [self headerViewAnimation];
}

#pragma mark- private method
- (UIButton *)createButtonWithIndex:(NSInteger )index totalCount:(NSInteger)totalCount title:(NSString *)title
{
    UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [item setBackgroundImage:[self imageWithColor:_configration.bgColorForNormal] forState:UIControlStateNormal];
    [item setBackgroundImage:[self imageWithColor:_configration.bgColorForSelected] forState:UIControlStateSelected];
    [item setTitleColor:_configration.textColorForNormal forState:UIControlStateNormal];
    [item setTitleColor:_configration.textColorForSelected forState:UIControlStateSelected];
    
    [item setTitle:title forState:UIControlStateNormal];

    CGFloat itemX,itemY, itemHeight,itemWidth;
    //自动调整的话只要设置config的itemWith,itemHeight 和itemSpace
    if(_configration.adjustCenter){
        CGFloat margin = (CGRectGetWidth(self.frame) - _configration.itemWidth * totalCount - _configration.itemSpace * (totalCount - 1))/2.0;
        itemX = margin + (_configration.itemWidth + _configration.itemSpace) * (index);
        itemY = (_configration.segmentHeight - _configration.itemHeight)/2.0;
        itemHeight = _configration.itemHeight;
        itemWidth = _configration.itemWidth;
        
        _configration.insets = UIEdgeInsetsMake(itemY, margin,_configration.segmentHeight - itemY - itemHeight , margin);
    }
    //非自动调整需要设置上下左右间距和itemSpace
    else{
        itemWidth = (CGRectGetWidth(self.frame) - _configration.insets.left - _configration.insets.right - _configration.itemSpace * (_childVCArr.count - 1)) / (_childVCArr.count * 1.f);
        itemHeight = CGRectGetHeight(self.headerView.frame) - _configration.insets.top - _configration.insets.bottom;
        itemX = _configration.insets.left + (itemWidth + _configration.itemSpace) * (index);
        itemY = _configration.insets.top;
        
        _configration.itemWidth = itemWidth;
        _configration.itemHeight = itemHeight;
    }
    item.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    
    if(_configration.cornerRadius){
        item.layer.cornerRadius = _configration.cornerRadius;
        item.layer.masksToBounds = YES;
    }
    
    return item;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    if (color == nil)
    {
        assert(0);
        return nil;
    }

    CGFloat alphaChannel;
    [color getRed:NULL green:NULL blue:NULL alpha:&alphaChannel];
    BOOL opaqueImage = (alphaChannel == 1.0);
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, opaqueImage, [UIScreen mainScreen].scale);
    [color setFill];
    UIRectFill(rect);
     UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark- setter/getter
- (UIView *)headerView
{
    if(!_headerView){
        _headerView = [[UIView alloc] init];
    }
    return _headerView;
}

- (UIView *)indexView{
    if(!_indexView){
        _indexView = [UIView new];
    }
    return _indexView;
}

- (UIView *)separatorLineView
{
    if(!_separatorLineView){
        _separatorLineView = [[UIView alloc] init];
    }
    return _separatorLineView;
}

- (UIScrollView *)scrollView
{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

@end

@implementation FHSegmentConfiguration
+ (instancetype)defaluConfiguration
{
    FHSegmentConfiguration *configuration = [[FHSegmentConfiguration alloc] init];
    configuration.fontSize = 14.0;
    configuration.textColorForNormal = [UIColor lightGrayColor];
    configuration.textColorForSelected = [UIColor orangeColor];
    configuration.bgColorForNormal = [UIColor blueColor];
    configuration.bgColorForSelected = [UIColor redColor];
    configuration.itemWidth = 100;
    configuration.itemHeight = 30;
    configuration.itemSpace = 20;
    configuration.cornerRadius = 15.0;
    configuration.adjustCenter = YES;
    
    configuration.separatorColor = [UIColor redColor];
    configuration.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    configuration.needSeparator = YES;
    
    configuration.segmentHeight = 50;
    configuration.segmentColor = [UIColor whiteColor];
    configuration.indexViewWidth = 25.f;
    configuration.indexViewBottomMargin = 0.f;
    configuration.indexViewHeight = 2.0;
    configuration.indexViewColor = [UIColor purpleColor];
    configuration.scrollAnimation = YES;
    configuration.scrollEnable = YES;
    return configuration;
}

@end
