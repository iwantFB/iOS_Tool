//
//  AvatarListView.h
//  DEMO
//
//  Created by 夜站 on 2018/3/16.
//  Copyright © 2018年 夜站. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AvatarViewCoverType){
    ///右边压住左边
    AvatarViewCoverTypeRight,
    AvatarViewCoverTypeLeft,
    AvatarViewCoverTypeNone
};

@interface AvatarListConfigration : NSObject

@property (nonatomic) CGFloat itemHeight;
@property (nonatomic) CGFloat itemWidth;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic,) AvatarViewCoverType coverType;
@property (nonatomic,) CGFloat coverSpace;
//图片之间的间距设置这个值之后会默认覆盖掉coverType, coverSpace
@property (nonatomic,) CGFloat avatarMargin;
//距离上左下右的距离
@property (nonatomic,) UIEdgeInsets edges;
//图片占位图
@property (nonatomic, copy)NSString *placeHolderImageStr;

@property (nonatomic, copy)NSArray *avatarArr;

@end

@interface AvatarListView : UIView

@property (nonatomic) CGFloat itemHeight;
@property (nonatomic) CGFloat itemWidth;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic,) AvatarViewCoverType coverType;
@property (nonatomic,) CGFloat coverSpace;
//图片之间的间距设置这个值之后会默认覆盖掉coverType, coverSpace
@property (nonatomic,) CGFloat avatarMargin;
//距离上左下右的距离
@property (nonatomic,) UIEdgeInsets edges;
//图片占位图
@property (nonatomic, copy)NSString *placeHolderImageStr;

@property (nonatomic, copy)NSArray *avatarArr;

@end
