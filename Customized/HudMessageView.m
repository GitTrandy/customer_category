//
//  HudMessageView.m
//  beatmasterSNS
//
//  Created by wanglei on 13-2-27.
//
//

#import "HudMessageView.h"
#import "AppController.h"

@implementation HudMessageView

static HudMessageView* g_HudMessageView = nil;
+(HudMessageView*) sharedHudMessageView{
    
    if (nil==g_HudMessageView)
    {
        g_HudMessageView = [[HudMessageView alloc] init];
    }
    
    return g_HudMessageView;
}

+(void) destroyHudMessageView{
    
    if (g_HudMessageView)
    {
        [g_HudMessageView release];
        g_HudMessageView = nil;
    }
}

-(id) init{
    
    if( (self=[super init]) ) {
        
        UIWindow *window = ((AppController *)[UIApplication sharedApplication].delegate).window;
        _hud = [[MBProgressHUD alloc] initWithView:window];
        [window addSubview:_hud];
        
        // Set determinate mode
        //_hud.delegate = self;
        _hud.dimBackground = YES;
	}
	return self;
}

-(void) dealloc{
    
    [_hud removeFromSuperview];
    [_hud release];
    
    [super dealloc];
}

-(void) showWithType:(enShowType)showType title:(NSString*)title afterDelay:(float)afterDelay{
    
    [self showLoading:title];
    
    switch (showType)
    {
        case EST_NORMAL:
            [_hud hide:YES afterDelay:afterDelay];
            break;
            
        case EST_SUCCESS:
            [self showSuccessStatus:title afterDelay:afterDelay];
            break;
            
        case EST_FAIL:
            [self showFailStatus:title afterDelay:afterDelay];
            break;
            
        default:
            break;
    }
    
}

-(void) showWithType:(enShowType)showType title:(NSString*)title afterDelay:(float)afterDelay hudMode:(MBProgressHUDMode)mode{
    
    [self showLoading:title];
    switch (showType)
    {
        case EST_NORMAL:
            [_hud hide:YES afterDelay:afterDelay];
            break;
            
        case EST_SUCCESS:
            [self showSuccessStatus:title afterDelay:afterDelay];
            break;
            
        case EST_FAIL:
            [self showFailStatus:title afterDelay:afterDelay];
            break;
            
        default:
            break;
    }
    
    _hud.mode = mode;
    
}

-(void) showLoading:(NSString *)title{
    [self showLoading:title imagePath:nil];
}

-(void) showLoading:(NSString*)title imagePath:(NSString*)imagePath{
    
    if (imagePath)
    {
        _hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed_New:imagePath]] autorelease];
        _hud.mode = MBProgressHUDModeCustomView;
    }
    else
    {
        _hud.mode = MBProgressHUDModeIndeterminate;
    }
    
    _hud.labelText = title;
    
    [_hud show:YES];
}

-(void) showSuccessStatus:(NSString *)title afterDelay:(float)afterDelay{
    [self showSuccessStatus:title succImagePath:@"055_success@2x.png" afterDelay:afterDelay];
}

-(void) showSuccessStatusKeepMode:(NSString *)title afterDelay:(float)afterDelay{
    [self showSuccessStatus:title succImagePath:nil afterDelay:afterDelay];
}

-(void) showSuccessStatus:(NSString*)title succImagePath:(NSString*)succImagePath afterDelay:(float)afterDelay{
    
    if (succImagePath)
    {
        _hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed_New:succImagePath]] autorelease];
        _hud.mode = MBProgressHUDModeCustomView;
    }
    
    _hud.labelText = title;
    
    if (fabs(afterDelay) < 0.000001f)
    {
        [_hud hide:YES];
    }
    else
    {
        [_hud hide:YES afterDelay:afterDelay];
    }
}

-(void) showFailStatus:(NSString *)title afterDelay:(float)afterDelay{
    [self showFailStatus:title failImagPath:@"055_fail@2x.png" afterDelay:afterDelay];
    
}

-(void) showFailStatusKeepMode:(NSString *)title afterDelay:(float)afterDelay{
    [self showFailStatus:title failImagPath:nil afterDelay:afterDelay];
    
}

-(void) showFailStatus:(NSString*)title failImagPath:(NSString*)failImagPath afterDelay:(float)afterDelay{
    
    if (failImagPath)
    {
        _hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed_New:failImagPath]] autorelease];
        _hud.mode = MBProgressHUDModeCustomView;
    }
    
    _hud.labelText = title;
    
    if (fabs(afterDelay) < 0.000001f)
    {
        [_hud hide:YES];
    }
    else
    {
        [_hud hide:YES afterDelay:afterDelay];
    }
}

-(void) adjustHUDOrientation
{
    [_hud setTransformForCurrentOrientation:NO];
}

-(void) loadingPromptWithTitle:(NSString *)title imagePath:(NSString *) imagePath missTime:(float)missTime
{
    if (imagePath)
    {
        _hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed_New:imagePath]] autorelease];
        _hud.mode = MBProgressHUDModeCustomView;
    }
    else
    {
        _hud.mode = MBProgressHUDModeIndeterminate;
    }
    
    _hud.labelText = title;
    
    if (_hud.dimBackground)
    {
        [_hud show:YES];
    }
    
    if (fabs(missTime) > 0.000001f)
    {
        [_hud hide:YES afterDelay:missTime];
    }
}

-(void) successPromptWithTitle:(NSString *)title succImagePath:(NSString *)succImagePath missTime:(float)missTime
{
    if (_hud.dimBackground)
    {
        if (succImagePath)
        {
            [self loadingPromptWithTitle:title imagePath:succImagePath missTime:0];
        }
        else
        {
            [self loadingPromptWithTitle:title imagePath:@"055_success@2x.png" missTime:0];
        }
    }
    else
    {
        if (succImagePath)
        {
            _hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed_New:succImagePath]] autorelease];
        }
        else
        {
            _hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed_New:@"055_success@2x.png"]] autorelease];
        }
        _hud.mode =MBProgressHUDModeCustomView;
        _hud.labelText = title;
    }
    
    if (fabs(missTime) < 0.000001f)
    {
        [_hud hide:YES];
    }
    else
    {
        [_hud hide:YES afterDelay:missTime];
    }
}

-(void) failPromptWithTitle:(NSString *)title failImagePath:(NSString*)failImagePath missTime:(float)missTime
{
    if (_hud.dimBackground)
    {
        if (failImagePath)
        {
            [self loadingPromptWithTitle:title imagePath:failImagePath missTime:0];
        }
        else
        {
            [self loadingPromptWithTitle:title imagePath:@"055_fail@2x.png" missTime:0];
        }
    }
    else
    {
        if (failImagePath)
        {
            _hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed_New:failImagePath]] autorelease];
        }
        else
        {
            _hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed_New:@"055_fail@2x.png"]] autorelease];
        }
        _hud.mode =MBProgressHUDModeCustomView;
        _hud.labelText = title;
    }
    
    if (fabs(missTime) < 0.000001f)
    {
        [_hud hide:YES];
    }
    else
    {
        [_hud hide:YES afterDelay:missTime];
    }
}

-(void) wordPromptWithTitle:(NSString *)title missTime:(float) missTime
{
    _hud.mode = MBProgressHUDModeText;
    _hud.labelText = title;
    if (_hud.dimBackground)
    {
        [_hud show:YES];
    }
    
    if (fabs(missTime) > 0.000001f)
    {
        [_hud hide:YES afterDelay:missTime];
    }
}

@end
