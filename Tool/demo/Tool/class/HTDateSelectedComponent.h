//
//  HTDateSelectedComponent.h
//  WALNUTT
//
//  Created by 胡斐 on 2019/8/5.
//  Copyright © 2019 WalnutTech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectedDateBlcok)(NSString *dateStr);

@interface HTDateSelectedComponent : UIView

@property (nonatomic, copy) SelectedDateBlcok selectedBlock;
@property (nonatomic, copy) NSString *dateFormatStr;

- (instancetype)initWithDateFormatter:(NSString *)dateFormatter
                    selectedDateBlock:(nullable SelectedDateBlcok) selectedBlock;

- (void)show;
- (void)showToView:(UIView *)targetView;

@end

NS_ASSUME_NONNULL_END
