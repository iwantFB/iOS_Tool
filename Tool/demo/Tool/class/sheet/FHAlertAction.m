//
//  FHAlertAction.m
//  demo
//
//  Created by 胡斐 on 2018/8/6.
//  Copyright © 2018年 胡斐. All rights reserved.
//

#import "FHAlertAction.h"

@interface FHAlertAction()

@property (nullable, nonatomic, ) NSString *title;
@property (nonatomic ) FHAlertActionStyle style;
@property (nonatomic ) CGFloat fontSize;
@property (nonatomic ) UIColor *textColor;
@property (nonatomic, copy) void(^handler)(FHAlertAction *action);

@end

@implementation FHAlertAction

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(FHAlertActionStyle)style handler:(void (^ __nullable)(FHAlertAction *action))handler{
    return [self actionWithTitle:title fontSize:14 textColor:[UIColor blackColor] style:style handler:handler];
}

+ (instancetype)actionWithTitle:(nullable NSString *)title fontSize:(CGFloat )fontSize textColor:(UIColor *)textColor style:(FHAlertActionStyle)style handler:(void (^ __nullable)(FHAlertAction *action))handler
{
    FHAlertAction *action = [[FHAlertAction alloc] init];
    if (!title) {
        assert("must have a title");
    }
    action.title = title;
    action.fontSize = fontSize ? fontSize : 14;
    action.textColor = textColor ? textColor : [UIColor blackColor];
    action.style = style ? style : FHAlertActionStyleDefault;
    action.handler = handler;
    
    return action;
}

@end
