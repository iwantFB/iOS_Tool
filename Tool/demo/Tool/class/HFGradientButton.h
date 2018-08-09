//
//  HFGradientButton.h
//  Tool
//
//  Created by 夜站 on 2018/6/22.
//  Copyright © 2018年 jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFGradientButton : UIButton

///渐变色设置,colors 颜色数组,元素为CGColor类型,startPoint、endPoint的心x,y都是为0-1,locations为0-1的NSNumber类型的数据,用于区分渐变色的截止点
- (void)buildBtnLayerColorWithColors:(NSArray *)colors
                          startPoint:(CGPoint)startPoint
                            endPoint:(CGPoint)endPoint
                           locations:(NSArray *)loacations;

///构造水平渐变
- (void)buildHorizBtnColorWithColors:(NSArray *)colors;

///构造垂直渐变
- (void)buildVerticalBtnColorWithColors:(NSArray *)colors;

@end
