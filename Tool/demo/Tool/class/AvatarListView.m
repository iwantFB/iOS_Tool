//
//  AvatarListView.m
//  DEMO
//
//  Created by 夜站 on 2018/3/16.
//  Copyright © 2018年 夜站. All rights reserved.
//

#import "AvatarListView.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation AvatarListConfigration

+ (instancetype)defaultConfigration
{
    AvatarListConfigration *config = [[AvatarListConfigration alloc] init];
    config.coverType = AvatarViewCoverTypeLeft;
    config.coverSpace = 50;
    config.edges = UIEdgeInsetsMake(10, 10, 0, 0);
    config.itemHeight = 100;
    config.itemWidth = 100;
    config.borderColor = [UIColor blueColor];
    config.borderWidth = 2;
    config.cornerRadius = 50;
    config.placeHolderImageStr = @"timg";
    //这个值设置之后会覆盖掉coverSpace,coverType会变成none,这样是没有覆盖的,只有间隔
//    config.avatarMargin = 10;
    return config;
}

@end

@interface FHAvatarFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) AvatarListConfigration *configration;

@end

@implementation FHAvatarFlowLayout

-(void)prepareLayout{
    //    获取collectionView中第0组的item个数
    _dataArr = [NSMutableArray array];
    NSInteger itemNum= [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger i = 0; i < itemNum; i++) {
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForItem:i inSection:0];
        //布局
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexpath];
        
        CGFloat x = 0 ;
        CGFloat y = _configration.edges.top;
        CGFloat item_width = _configration.itemWidth;
        CGFloat item_Height = _configration.itemHeight;
        if(_configration.avatarMargin){
            x = _configration.edges.left + i*item_width + i * _configration.avatarMargin;
        }else {
            x = _configration.edges.left + (item_width - _configration.coverSpace) * i;
        }
        attr.frame = CGRectMake(x, y, item_width, item_Height);
        
        [self.dataArr addObject:attr];
    }
}

- (CGSize)collectionViewContentSize
{
    CGFloat contentWidth = _configration.edges.left + _configration.edges.right;
    NSInteger count = self.dataArr.count;
    if(_configration.avatarMargin){
        contentWidth += _configration.itemWidth*count + _configration.avatarMargin*count - _configration.avatarMargin;
    }else{
        contentWidth += _configration.itemWidth*count - _configration.coverSpace*count + _configration.coverSpace;
    }
    return CGSizeMake(contentWidth, _configration.itemHeight + _configration.edges.top+_configration.edges.bottom);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.dataArr;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    return _dataArr[itemIndexPath.item];
}

@end

#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)

@interface HFAvatarCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *avatarImageView;

@end

@implementation HFAvatarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self p_initSubView];
    }
    return self;
}

- (void)p_initSubView
{
    [self.contentView addSubview:self.avatarImageView];
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark- setter/getter
- (UIImageView *)avatarImageView
{
    if(!_avatarImageView)
    {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _avatarImageView;
}

@end

@interface AvatarListView()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *avatarCollectionView;

@end

@implementation AvatarListView

#pragma mark- life circle
- (instancetype)init{
    return [self initWithFrame:CGRectZero configration:[AvatarListConfigration defaultConfigration] avatarArr:nil selectedBlock:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
                 configration:(AvatarListConfigration *)configration
                    avatarArr:(NSArray *)avatarArr
                selectedBlock:(void (^)(NSInteger))selectedBlock
{
    self = [super initWithFrame:frame];
    if(self){
        _configration = configration;
        _avatarArr = avatarArr;
        _selectedBlock = selectedBlock;
        [self p_initSubView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame configration:[AvatarListConfigration defaultConfigration] avatarArr:nil selectedBlock:nil];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self p_initSubView];
    }
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [_avatarCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(_configration.edges);
    }];
}

#pragma mark- hitTest
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *result = [super hitTest:point withEvent:event];
    UIView *target = nil;
    
    UICollectionView *collectionView = self.avatarCollectionView;
    NSArray *cells = collectionView.visibleCells;
    for (UICollectionViewCell *cell in cells) {
        CGPoint location = [self convertPoint:point toView:collectionView];
        if(CGRectContainsPoint(cell.frame, location) && cell.layer.zPosition > target.layer.zPosition){
            target = cell;
        }
    }
    if(target)return target;
    
    return result;
}

#pragma mark- collectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.avatarArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HFAvatarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HFAvatarCell" forIndexPath:indexPath];
    
    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_avatarArr[indexPath.item]] placeholderImage:[UIImage imageNamed:_configration.placeHolderImageStr]];
    cell.layer.borderColor = _configration.borderColor.CGColor;
    cell.layer.borderWidth = _configration.borderWidth;
    cell.layer.cornerRadius = _configration.cornerRadius;
    cell.layer.masksToBounds = YES;
    
    CGFloat zPosition = _configration.coverType == AvatarViewCoverTypeRight ? indexPath.item + 1000 : 1000 - indexPath.item;
    cell.layer.zPosition = zPosition;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(_selectedBlock)_selectedBlock(indexPath.item);
}

#pragma mark- private method
- (void)p_initSubView
{
    [self addSubview:self.avatarCollectionView];
}

#pragma mark- setter/getter
- (UICollectionView *)avatarCollectionView
{
    if(!_avatarCollectionView){
        FHAvatarFlowLayout *flow = [[FHAvatarFlowLayout alloc] init];
        flow.minimumInteritemSpacing = 0;
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flow.configration = _configration;
        _avatarCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) ) collectionViewLayout:flow];
        _avatarCollectionView.backgroundColor = [UIColor clearColor];
        _avatarCollectionView.showsVerticalScrollIndicator = NO;
        _avatarCollectionView.showsHorizontalScrollIndicator = NO;
        [_avatarCollectionView registerClass:[HFAvatarCell class] forCellWithReuseIdentifier:@"HFAvatarCell"];
        _avatarCollectionView.delegate = self;
        _avatarCollectionView.dataSource = self;
    }
    return _avatarCollectionView;
}

- (void)setAvatarArr:(NSArray *)avatarArr
{
    _avatarArr = avatarArr;
    
    [_avatarCollectionView reloadData];
}

- (void)setConfigration:(AvatarListConfigration *)configration
{
    _configration = configration;
    FHAvatarFlowLayout *layout = (FHAvatarFlowLayout *)self.avatarCollectionView.collectionViewLayout;
    layout.configration = _configration;
    [self.avatarCollectionView reloadData];
}

@end


