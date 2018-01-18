//
//  YZNumberTextField.h
//  NightStation
//
//  Created by 夜站 on 2018/1/12.
//  Copyright © 2018年 liufy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFNumberTextField : UITextField

@property (nonatomic, copy)void(^doneBlock)();

//右下角完成按钮的标题
@property (nonatomic, copy) NSString *doneBtnTitle;

/**
 点击完成按钮(左下角) 是否自动收起键盘,默认YES收起
 */
@property (nonatomic, assign) BOOL hideKeyboard;

@end

