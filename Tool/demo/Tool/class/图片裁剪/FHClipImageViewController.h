//
//  FHClipImageViewController.h
//  Calendar
//
//  Created by 胡斐 on 2018/4/22.
//  Copyright © 2018年 胡斐. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FHClipImageViewController : UIViewController

@property (nonatomic, copy) void(^clipImageBlock)(UIImage *result);

- (instancetype)initWithTargetImage:(UIImage *)targetImage maskFrame:(CGRect)maskFrame clipBlock:(void(^)(UIImage *result))clipImageBlock;

@end
