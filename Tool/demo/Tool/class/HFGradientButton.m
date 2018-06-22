//
//  HFGradientButton.m
//  Tool
//
//  Created by 夜站 on 2018/6/22.
//  Copyright © 2018年 jackson. All rights reserved.
//

#import "HFGradientButton.h"

@implementation HFGradientButton

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

- (void)buildBtnLayerColorWithColors:(NSArray *)colors startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint locations:(NSArray *)loacations
{
    CAGradientLayer *btnLayer = (CAGradientLayer *)self.layer;
    btnLayer.colors = colors;
    btnLayer.startPoint = startPoint;
    btnLayer.endPoint = endPoint;
    btnLayer.locations = loacations;
}

- (void)buildHorizBtnColorWithColors:(NSArray *)colors
{
    [self buildBtnLayerColorWithColors:colors startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0) locations:@[@0,@1]];
}

- (void)buildVerticalBtnColorWithColors:(NSArray *)colors
{
    [self buildBtnLayerColorWithColors:colors startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1) locations:@[@0,@1]];
}


@end
