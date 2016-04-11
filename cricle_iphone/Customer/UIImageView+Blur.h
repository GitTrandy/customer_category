//
//  UIImageView+Blur.h
//  circle_iphone
//
//  Created by sujie on 15/11/17.
//  Copyright © 2015年 ctquan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BlurStyleDark,
    BlurStyleLight,
    BlurStyleExtraLight
}BlurStyle;

@interface UIImageView (Blur)

- (void)blurImageViewWithStyle:(BlurStyle)style;

@end
