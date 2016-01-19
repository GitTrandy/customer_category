//
//  UILabel+Extension.h
//  circle_iphone
//
//  Created by sujie on 15/4/14.
//  Copyright (c) 2015年 ctquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

/*
 设置label行间距
 
 param:     lineSpace  间距高度
            str        label.text
 */
- (void)setLineSpace:(float)lineSpace text:(NSString *)str;


/*
 获取动态label的size
 
 param:     text        label.text
            fontSize    字号
            maxSize     最大宽高限制
            lineSpace   间距高度
 */
+ (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize lineSpace:(float)lineSpace;

@end
