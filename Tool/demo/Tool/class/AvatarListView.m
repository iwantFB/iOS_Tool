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


@end

@interface FHAvatarFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) AvatarListConfigration *configration;

@end

@implementation FHAvatarFlowLayout

-(void)prepareLayout{
    //    获取collectionView中第0组的item个数
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
            x = _configration.edges.left + i * _configration.avatarMargin + (i+1)*item_width;
        }else if (_configration.coverType == AvatarViewCoverTypeRight){
            x = _configration.edges.left + (item_width - _configration.coverSpace) * i;
        }
        attr.frame = CGRectMake(x, y, item_width, item_Height);
        
        [self.dataArr addObject:attr];
        
    }
    
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
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self p_initSubView];
    }
    return self;
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
        make.edges.equalTo(self).insets(_edges);
    }];
}

#pragma mark- collectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.avatarArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HFAvatarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HFAvatarCell" forIndexPath:indexPath];

    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_avatarArr[indexPath.item]] placeholderImage:[UIImage imageNamed:_placeHolderImageStr]];
    cell.layer.borderColor = _borderColor.CGColor;
    cell.layer.borderWidth = _borderWidth;
    cell.layer.cornerRadius = _cornerRadius;
    cell.layer.masksToBounds = YES;

    CGFloat zPosition = _coverType == AvatarViewCoverTypeRight ? indexPath.item + 1000 : 1000 - indexPath.item;
    cell.layer.zPosition = zPosition;
    return cell;
}

#pragma mark- flowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_itemWidth, _itemHeight);
}

#pragma mark- private method
- (void)p_initSubView
{
    _itemHeight = _itemWidth = CGRectGetHeight(self.frame);
    _cornerRadius = _itemHeight / 2.0;
    _coverType = AvatarViewCoverTypeLeft;
    _coverSpace = _itemHeight / 2.0 - 10;

    [self addSubview:self.avatarCollectionView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self p_refreshUI];
}

- (void)p_refreshUI
{
    _edges = UIEdgeInsetsMake(_edges.top, _edges.left, CGRectGetHeight(self.frame) - _itemHeight - _edges.top, _edges.right);

    [_avatarCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(_edges);
    }];
}

#pragma mark- setter/getter
- (UICollectionView *)avatarCollectionView
{
    if(!_avatarCollectionView){
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.itemSize = CGSizeMake(_itemWidth, _itemHeight);
        flow.minimumLineSpacing = _avatarMargin?_avatarMargin:-_coverSpace;
        flow.minimumInteritemSpacing = 0;
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        _avatarCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(_edges.left, _edges.top, CGRectGetWidth(self.frame) - _edges.left - _edges.right, CGRectGetHeight(self.frame) - _edges.top - _edges.bottom) collectionViewLayout:flow];
        _avatarCollectionView.backgroundColor = [UIColor clearColor];
        _avatarCollectionView.showsVerticalScrollIndicator = NO;
        _avatarCollectionView.showsHorizontalScrollIndicator = NO;
        [_avatarCollectionView registerClass:[HFAvatarCell class] forCellWithReuseIdentifier:@"HFAvatarCell"];
        _avatarCollectionView.delegate = self;
        _avatarCollectionView.dataSource = self;
    }
    return _avatarCollectionView;
}

- (void)setItemHeight:(CGFloat)itemHeight
{
    _itemHeight = itemHeight;
    [self p_refreshUI];
}

- (void)setAvatarArr:(NSArray *)avatarArr
{
    _avatarArr = avatarArr;

    [_avatarCollectionView reloadData];
}

@end


