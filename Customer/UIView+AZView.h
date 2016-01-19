//
//  UIView+AZView.h
//  AZSinaWeibo
//
//  Created by AndrewZhang on 15/2/28.
//  Copyright (c) 2015年 AndrewZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AZView)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;


/** 获取视图的根控制器 */
-(UIViewController *)azViewController;

@end
