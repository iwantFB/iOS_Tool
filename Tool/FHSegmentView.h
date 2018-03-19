//
//  FHSegmentView.h
//  DEMO
//
//  Created by 夜站 on 2018/3/19.
//  Copyright © 2018年 夜站. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FHSegmentConfiguration : NSObject

@property (nonatomic, assign) CGFloat fontSize;

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

@property (nonatomic, assign) CGFloat segmentHeight;

/**顶部按钮的背景视图的颜色*/
@property (nonatomic, strong) UIColor *segmentColor;
//默认为NO,不显示分割线
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

@property (nonatomic, assign, readonly) NSInteger currentIndex;


/**设置某个控制器会将superViewController设置为childVCArr中的vc的父控制器,用来做控制器管理*/
@property (nonatomic, strong)UIViewController *superViewController;

@property (nonatomic, strong)FHSegmentConfiguration *configration;

@property (nonatomic, copy) NSArray<UIViewController *> *childVCArr;

- (instancetype)initWithFrame:(CGRect)frame configration:(FHSegmentConfiguration *)configration;

- (void)buildUI;

/**必须在调用了一次build之后才能有效*/
- (void)selectIndex:(NSInteger )index animation:(BOOL)animation;

@end
