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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;
@property (weak, nonatomic) IBOutlet HFCircleImageView *imageView;
@property (weak, nonatomic) IBOutlet AvatarListView *avatarListView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _imageView.cornerSize = CGSizeMake(5, 5);
    
    //个人觉得设置图片的z-position不是一种特别好的办法，还是要重写flowlayout试试
    _avatarListView.avatarArr = @[@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3912945903,2440251137&fm=27&gp=0.jpg",@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3912945903,2440251137&fm=27&gp=0.jpg",@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3912945903,2440251137&fm=27&gp=0.jpg",@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3912945903,2440251137&fm=27&gp=0.jpg",@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=3912945903,2440251137&fm=27&gp=0.jpg",];
    _avatarListView.borderWidth = 1.0;
    _avatarListView.borderColor = [UIColor blueColor];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
