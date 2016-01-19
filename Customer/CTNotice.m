//
//  CTNotice.m
//  circle_iphone
//
//  Created by trandy on 15/8/21.
//  Copyright (c) 2015年 ctquan. All rights reserved.
//

#import "CTNotice.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation CTNotice

+ (void)showNotice:(NSString* )str
{
    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    hud.customView = nil;
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = str;
    hud.color = CTColorMake(0, 0, 0, 0.6);
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:1.0f];
}

@end
