//
//  UIScrollView+CustomScrollbar.m
//  CustomUIScrollView
//
//  Created by Nikita Leonov on 4/22/11.
//  Copyright 2011 leonov.co. All rights reserved.
//

#import "UIScrollView+CustomScrollbar.h"

static const int UIScrollViewHorizontalBarIndexOffset = 0;
static const int UIScrollViewVerticalBarIndexOffset = 1;

@interface UIScrollView(UIScrollView_CustomScrollbarPrivate)

-(UIImageView *)scrollbarImageViewWithIndex:(int)indexOffset;

@end

@implementation UIScrollView(UIScrollView_CustomScrollbarPrivate)

-(UIImageView *)scrollbarImageViewWithIndex:(int)indexOffset 
{
    int viewsCount = [[self subviews] count];
    UIImageView *result = [self subviews][viewsCount - indexOffset - 1];
    
    return result;
}

@end

@implementation UIScrollView(UIScrollView_CustomScrollbar)

-(void)setHorizontalScrollbarImage:(UIImage *)image 
{
    UIView* view = [self scrollbarImageViewWithIndex:UIScrollViewHorizontalBarIndexOffset];
    if ([view isMemberOfClass:[UIImageView class]])
    {
        [(UIImageView *)view setImage:image];
    }
}

-(void)setVerticalScrollbarImage:(UIImage *)image 
{
    UIView* view = [self scrollbarImageViewWithIndex:UIScrollViewHorizontalBarIndexOffset];
    if ([view isMemberOfClass:[UIImageView class]])
    {
        [(UIImageView *)view setImage:image];
    }
}

-(void)setHorizontalScrollbarHeight:(int)height 
{
    UIImageView *scrollBar = [self scrollbarImageViewWithIndex:UIScrollViewHorizontalBarIndexOffset];
    
    CGRect frame = [scrollBar frame];
    frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
    [scrollBar setFrame:frame];
}

-(void)setVerticalScrollbarWidth:(int)width 
{
    UIImageView *scrollBar = [self scrollbarImageViewWithIndex:UIScrollViewVerticalBarIndexOffset];
    
    CGRect frame = [scrollBar frame];
    frame = CGRectMake(frame.origin.x, frame.origin.y, width, frame.size.height);
    [scrollBar setFrame:frame];    
}

@end
