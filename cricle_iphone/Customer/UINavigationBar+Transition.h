//
//  UINavigationBar+Transition.h
//  circle_iphone
//
//  Created by sujie on 15/11/12.
//  Copyright © 2015年 ctquan. All rights reserved.
//

#import <UIKit/UIKit.h>


/* 原生navbar滑动透明 使用方式
 
 - (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
 }
 
 
 - (void)viewDidLoad {
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
 }
 
 初始化自己在navBar上建立的层，并把需要的按钮add到上面
 -(void)initDiyNav{
    UIView *myNavView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, K_ScreenW, 44)];
    self.navigationItem.titleView=myNavView;//导航背景

    UILabel *myNavTitle=[[UILabel alloc] initWithFrame:CGRectMake(110, 0, 140, 44)];
    [myNavTitle setText:@"我asdasdas"];
    [myNavTitle setTextColor:[UIColor blackColor]];
    [myNavTitle setBackgroundColor:[UIColor clearColor]];
    [myNavTitle setTextAlignment:NSTextAlignmentCenter];
    [myNavTitle setFont:[UIFont systemFontOfSize:16]];
    [myNavView addSubview:myNavTitle];//导航标题

    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.hidesBackButton=YES;
 }
 
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView
 {
     UIColor * color = [UIColor colorWithRed:0/255.0 green:175/255.0 blue:240/255.0 alpha:1];
     CGFloat offsetY = scrollView.contentOffset.y;
     if (offsetY > NAVBAR_CHANGE_POINT) {
     CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
     [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
     } else {
     [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
     }
 }
 */



@interface UINavigationBar (Transition)

- (void)ct_setBackgroundColor:(UIColor *)backgroundColor;
- (void)ct_setElementsAlpha:(CGFloat)alpha;
- (void)ct_setTranslationY:(CGFloat)translationY;
- (void)ct_reset;

@end
