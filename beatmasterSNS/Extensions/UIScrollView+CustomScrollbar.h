//
//  UIScrollView+CustomScrollbar.h
//  CustomUIScrollView
//
//  Created by Nikita Leonov on 4/22/11.
//  Copyright 2011 leonov.co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIScrollView(UIScrollView_CustomScrollbar)

-(void)setHorizontalScrollbarImage:(UIImage *)image;
-(void)setVerticalScrollbarImage:(UIImage *)image;

-(void)setHorizontalScrollbarHeight:(int)height;
-(void)setVerticalScrollbarWidth:(int)width;

@end
