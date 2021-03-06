//
//  ViewController.m
//  Demo
//
//  Created by 胡斐 on 2018/4/26.
//  Copyright © 2018年 jackson. All rights reserved.
//

#import "ViewController.h"
#import "HFCircleImageView.h"
#import "YZVerifyButton.h"
#import "FHClipImageViewController.h"
#import "AvatarListView.h"

#import "FHAlertSheetView.h"

#import "HFGradientButton.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;
@property (weak, nonatomic) IBOutlet HFCircleImageView *imageView;
@property (weak, nonatomic) IBOutlet AvatarListView *avatarListView;
@property (weak, nonatomic) IBOutlet HFGradientButton *footerButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _imageView.cornerSize = CGSizeMake(5, 5);
    
    //个人觉得设置图片的z-position不是一种特别好的办法，还是要重写flowlayout试试
    _avatarListView.avatarArr = @[@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3912945903,2440251137&fm=27&gp=0.jpg",@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3912945903,2440251137&fm=27&gp=0.jpg",@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3912945903,2440251137&fm=27&gp=0.jpg",@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3912945903,2440251137&fm=27&gp=0.jpg",@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3912945903,2440251137&fm=27&gp=0.jpg",@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3912945903,2440251137&fm=27&gp=0.jpg",@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3912945903,2440251137&fm=27&gp=0.jpg",@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3912945903,2440251137&fm=27&gp=0.jpg",@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3912945903,2440251137&fm=27&gp=0.jpg",@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3912945903,2440251137&fm=27&gp=0.jpg",];
    _avatarListView.configration = [AvatarListConfigration defaultConfigration];
    _avatarListView.selectedBlock = ^(NSInteger item) {
        NSLog(@"点击的是%ld",(long)item);
    };
    
    [_footerButton buildHorizBtnColorWithColors:@[(id)[UIColor redColor].CGColor,(id)[UIColor orangeColor].CGColor]];
}

- (IBAction)startCount:(YZVerifyButton *)sender {
    //验证码都是网络请求成功之后开始计时，故提供开启计时的方法
    [sender openCountdown];
}
- (IBAction)clipImageGestureAction:(id)sender {
    
    //图片固定裁剪，希望有好的思路可以提给我，谢谢,主要是固定比例暂时没有好的思路
    FHClipImageViewController *vc = [[FHClipImageViewController alloc] initWithTargetImage:[UIImage imageNamed:@"lady"] maskFrame:CGRectMake(40, 40, 300, 500) clipBlock:^(UIImage *result) {
        _resultImageView.image = result;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)checkSheetView:(id)sender {
    //cancel 会自动分到下一组去，分组有且只有2组，可以设置间隔
    FHAlertSheetView *alert = [FHAlertSheetView alertControllerWithTitle:@"头" message:@"message" preferredStyle:FHAlertControllerStyleActionSheet];
    FHAlertAction *action1 = [FHAlertAction actionWithTitle:@"one" style:FHAlertActionStyleDefault handler:^(FHAlertAction *action) {
        NSLog(@"one");
    }];
    FHAlertAction *action2 = [FHAlertAction actionWithTitle:@"two" fontSize:30 textColor:[UIColor yellowColor] style:FHAlertActionStyleDefault handler:^(FHAlertAction *action) {
        NSLog(@"two");
    }];
    FHAlertAction *action3 = [FHAlertAction actionWithTitle:@"three" style:FHAlertActionStyleCancel handler:^(FHAlertAction *action) {
        NSLog(@"three");
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [alert show];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
