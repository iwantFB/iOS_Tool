//
//  FHClipImageViewController.m
//  Calendar
//
//  Created by 胡斐 on 2018/4/22.
//  Copyright © 2018年 胡斐. All rights reserved.
//

#define KSCREEN_W ([UIScreen mainScreen].bounds.size.width)
#define KSCREEN_H ([UIScreen mainScreen].bounds.size.height)

#import "FHClipImageViewController.h"
#import "MaskView.h"

@interface FHClipImageViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) MaskView *maskView;

@property (nonatomic, strong) UIImage *targetImage;
@property (nonatomic, assign)CGRect maskFrame;

@end

@implementation FHClipImageViewController

#pragma mark- life circle
- (instancetype)init
{
    NSAssert(YES, @"请用initWithTargetImage: maskFrame: clipBlock:来创建");
    return [self initWithTargetImage:nil maskFrame:CGRectZero clipBlock:nil];
}

- (instancetype)initWithTargetImage:(UIImage *)targetImage maskFrame:(CGRect)maskFrame clipBlock:(void(^)())clipImageBlock
{
    if(self = [super init]){
        _targetImage = targetImage;
        _maskFrame = maskFrame;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    
    _scrollView.frame = _maskFrame;
    _maskView.frame = self.view.bounds;
}

#pragma mark- public method
- (void)_getClipImage
{
    // 创建一个context
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, NO, 1.);
    //把当前的全部画面导入到栈顶context中并进行渲染
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    // 从当前context中创建一个新图片
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    //获取到的图片
    img = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(img.CGImage, _maskFrame)];
}

#pragma mark- private method
- (void)p_setupUI
{
    self.view.clipsToBounds = YES;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    [self.view addSubview:self.maskView];
    self.scrollView.delegate = self;
    
    if (@available(iOS 11.0, *)) {
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _scrollView.maximumZoomScale = 3.0;
    _scrollView.minimumZoomScale = 1.0;
    _scrollView.bounces = YES;
    
    CGFloat image_width = _targetImage.size.width;
    CGFloat image_height = _targetImage.size.height;
    
    NSInteger targetHeight = CGRectGetHeight(_maskFrame);
    NSInteger targetWidth = (targetHeight / image_height)*image_width;
    
    NSLog(@"look %ld , %ld",(long)targetWidth,(long)targetHeight);
    
    _imageView.frame = CGRectMake(0, 0, targetWidth, targetHeight);
    
    _imageView.image = [self imageResize:_targetImage andResizeTo:CGSizeMake(targetWidth, targetHeight)];
    
    _scrollView.contentSize = CGSizeMake(targetWidth, targetHeight);
    
    _maskView.maskFrame = _maskFrame;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(_getClipImage)];
}

-(UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize
{
    CGFloat scale = [[UIScreen mainScreen]scale];
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark- scrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

#pragma mark- setter/getter
- (MaskView *)maskView{
    if(!_maskView){
        _maskView = [[MaskView alloc] init];
    }
    return _maskView;
}

- (UIImageView *)imageView
{
    if(!_imageView){
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UIScrollView *)scrollView
{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.clipsToBounds = NO;
    }
    return _scrollView;
}
@end
