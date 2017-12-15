//
//  ViewController.m
//  ImageRendering
//
//  Created by rock on 2017/12/14.
//  Copyright © 2017年 rock. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIImageView * imageView;
    UIImageView * borderImageView;
    UIImageView * syntheticImageView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}

#pragma mark --UI --
-(void)creatUI{
    //实例化按钮
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"图片绘制" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor orangeColor]];
    btn.frame = CGRectMake((self.view.bounds.size.width-100)/2, 100, 100, 40);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //图片
    imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"默认头像116"]];
    imageView.frame = CGRectMake((self.view.bounds.size.width/2-116/2)/2, btn.bounds.origin.y + 200,116/2 ,116/2);
    [self.view addSubview:imageView];
    
    //边框
    borderImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"头像背景"]];
    borderImageView.frame = CGRectMake((self.view.bounds.size.width/2-60/2)/4+self.view.bounds.size.width/2, btn.bounds.origin.y + 200, 60/2, 67/2);
    [self.view addSubview:borderImageView];
    
    //合成图
    syntheticImageView = [[UIImageView alloc]initWithFrame:CGRectMake(btn.frame.origin.x, imageView.frame.origin.y + 200, borderImageView.frame.size.width, borderImageView.frame.size.height)];
    [self.view addSubview:syntheticImageView];
    
}
#pragma mark -- Btn点击事件 --
-(void)btnClick{
    
   //syntheticImageView.image = [self imageWithIconName:@"默认头像116" borderImage:@"头像背景"];
    
    syntheticImageView.image = [self imageWithIconName:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1513255475199&di=0e38f9b2e4699be022fc04beb93c4baf&imgtype=0&src=http%3A%2F%2Fpic.yesky.com%2FuploadImages%2F2015%2F106%2F59%2FA5G714I04GHK.jpg" borderImage:@"头像背景"];
    
}

#pragma mark -- 处理图片 --
- (UIImage *)imageWithIconName:(NSString *)icon borderImage:(NSString *)borderImage{
    //头像图片
    //UIImage * iconImage = [UIImage imageNamed:icon];
    
    NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:icon]];
    UIImage * iconImage = [UIImage imageWithData:data];
 
    
    UIGraphicsBeginImageContext(iconImage.size);
    UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, iconImage.size.width, iconImage.size.height)];
    [path addClip];
    [iconImage drawAtPoint:CGPointZero];
    iconImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    //*/
    
    //边框图片
    UIImage * borderImg = [UIImage imageNamed:borderImage];
    
    CGSize size = CGSizeMake(borderImg.size.width, borderImg.size.height);
    
    //创建图片上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    //绘制边框的圆
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, size.width,size.height));
    
    //剪切可视范围
    CGContextClip(context);
    
    //绘制边框图片
    [borderImg drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //设置头像frame
    CGFloat iconX = 2;
    CGFloat iconY = 2;
    CGFloat iconW = size.width - iconX;
    CGFloat iconH = size.width - iconY;

    //绘制圆形头像范围
    CGContextAddEllipseInRect(context, CGRectMake(iconX, iconY, iconW, iconH));
    
    //剪切可视范围
    CGContextClip(context);
    
    //绘制头像
    [iconImage drawInRect:CGRectMake(0, 0, iconW, iconH)];
    
    //取出整个图片上下文的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    NSLog(@"w=%f,h=%f",image.size.width,image.size.height);
   
    return image;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
