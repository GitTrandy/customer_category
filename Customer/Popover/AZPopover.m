//
//  AZPopover.m
//  zhibuniao
//
//  Created by AndrewZhang on 15/9/26.
//  Copyright (c) 2015年 AndrewZhang. All rights reserved.
//

#import "AZPopover.h"

@implementation AZPopover

/** 单例 */
+(instancetype)sharePopOver
{
    static AZPopover *popover=nil;
    static dispatch_once_t popOverOnce;
   dispatch_once(&popOverOnce, ^{
       popover=[AZPopover new];
//       popover.maskType=DXPopoverMaskTypeNone;
       //popover.backgroundColor=UIColorFromRGB(0x262626);
   });
    return popover;
}

- (void)showAtPoint:(CGPoint)point
     popoverPostion:(DXPopoverPosition)position
    withContentView:(UIView *)contentView
             inView:(UIView *)containerView
{
    _isShow=YES;
    [super showAtPoint:point popoverPostion:position withContentView:contentView inView:containerView];
}

-(void)dismiss
{
    [super dismiss];
    _isShow=NO;
}


@end
