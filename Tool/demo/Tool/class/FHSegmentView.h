//
//  FHSegmentView.h
//  DEMO
//
//  Created by 夜站 on 2018/3/19.
//  Copyright © 2018年 夜站. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FHSegmentView;

@protocol FHSegmentViewDelegate<NSObject>

- (void)segmentView:(FHSegmentView *)segmentView
     didSelectedTab:(NSInteger)selectedTab;

@end

@interface FHSegmentConfiguration : NSObject

@property (nonatomic, strong) UIFont *fontForSelect;
@property (nonatomic, strong) UIFont *fontForNormal;

@property (nonatomic, strong) UIColor *textColorForNormal;
@property (nonatomic, strong) UIColor *textColorForSelected;
@property (nonatomic, strong) UIColor *bgColorForNormal;
@property (nonatomic, strong) UIColor *bgColorForSelected;

@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) CGFloat itemSpace;
/**
 是否自动将按钮居中,若为YES,只要设置itemWidth和itemHeight和itemSpace
 若为NO,则需要设置insets和itemSpace
 */
@property (nonatomic, assign) BOOL    adjustCenter;
@property (nonatomic, assign) UIEdgeInsets insets;

///顶部的数据的高度
@property (nonatomic, assign) CGFloat segmentHeight;

/**顶部按钮的背景视图的颜色*/
@property (nonatomic, strong) UIColor *segmentColor;
///默认为NO,不显示分割线
@property (nonatomic, assign) BOOL needSeparator;
@property (nonatomic, strong) UIColor *separatorColor;
@property (nonatomic, assign) UIEdgeInsets separatorInset;
@property (nonatomic, assign) CGFloat indexViewWidth;
@property (nonatomic, assign) CGFloat indexViewHeight;
@property (nonatomic, assign) CGFloat indexViewBottomMargin;
@property (nonatomic, strong) UIColor *indexViewColor;

@property (nonatomic) BOOL scrollEnable;
@property (nonatomic) BOOL scrollAnimation;

+ (instancetype)defaluConfiguration;

@end

@interface FHSegmentView : UIView

///若要改变,调用selectIndex: animation:
@property (nonatomic, assign, readonly) NSInteger currentIndex;


/**设置某个控制器会将superViewController设置为childVCArr中的vc的父控制器,用来做控制器管理*/
@property (nonatomic, strong)UIViewController *superViewController;

@property (nonatomic, strong)FHSegmentConfiguration *configration;

@property (nonatomic, weak) id<FHSegmentViewDelegate>delegate;

///在buildUI之前设置
@property (nonatomic, copy) NSArray<UIViewController *> *childVCArr;

- (instancetype)initWithFrame:(CGRect)frame
                   childVCArr:(nonnull NSArray *)childVCArr
                 configration:(nullable FHSegmentConfiguration *)configration;

/// 配置好了数据之后开始配置视图,这应该是放在最后的
- (void)buildUI;

/**选择哪一个tab*/
- (void)selectIndex:(NSInteger )index animation:(BOOL)animation;

@end
