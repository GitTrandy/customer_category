//
//  HudMessageView.h
//  beatmasterSNS
//
//  Created by wanglei on 13-2-27.
//
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

#define SNS_DEPRECATED_ATTRIBUTE __attribute__((deprecated))

typedef enum _tagShowType{
    
    EST_NORMAL=0,
    EST_SUCCESS,
    EST_FAIL,
    
}enShowType;

@interface HudMessageView : NSObject{
    
    MBProgressHUD*  _hud;
    
}

+(HudMessageView*) sharedHudMessageView;
+(void) destroyHudMessageView;

-(id) init;


/////////////////////////////////////////////////////////////////////////
//                                                                     //
//                      新接口,每个接口都可以单独调用                       //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

/*  loading提示
 title       :   提示的文字
 imagePath   :   提示的图片路径,可以为nil,如果是nil则使用默认的菊花图案
 missTime    :   停留的时间,如果是0,则不会自动消失
 */
-(void) loadingPromptWithTitle:(NSString *)title imagePath:(NSString *) imagePath missTime:(float)missTime;

/*  成功提示
 title           :   提示的文字
 succImagePath   :   提示图片,nil的情况默认是对勾图片
 missTime        :   停留时间
 */
-(void) successPromptWithTitle:(NSString *)title succImagePath:(NSString*)succImagePath missTime:(float)missTime;

/*  失败提示
 title           :   提示的文字
 failImagePath   :   提示图片,nil的情况默认是叉叉图片
 missTime        :   停留时间
 */
-(void) failPromptWithTitle:(NSString *)title failImagePath:(NSString*)failImagePath missTime:(float)missTime;

/*  纯文字提示
 title       :   提示的文字
 missTime    :   停留时间,如果是0,则不会自动消失
 */
-(void) wordPromptWithTitle:(NSString *)title missTime:(float) missTime;



/////////////////////////////////////////////////////////////////////////
//                                                                     //
//          以下的接口都是以前的老接口,还可以用,不建议再使用                   //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

//下面的函数
//函数成单调用 调用时设置延时时间 到时间后自动消失
-(void) showWithType:(enShowType)showType title:(NSString*)title afterDelay:(float)afterDelay SNS_DEPRECATED_ATTRIBUTE;
-(void) showWithType:(enShowType)showType title:(NSString*)title afterDelay:(float)afterDelay hudMode:(MBProgressHUDMode)mode SNS_DEPRECATED_ATTRIBUTE;

//下面的函数是过程式 调用方式成对出现
//1. 首先调用showloading 显示状态
//2. 再调用showSuccess 或者 showFailStatus 延时隐藏
-(void) showLoading:(NSString*)title SNS_DEPRECATED_ATTRIBUTE;
-(void) showSuccessStatus:(NSString*)title afterDelay:(float)afterDelay SNS_DEPRECATED_ATTRIBUTE;
-(void) showSuccessStatusKeepMode:(NSString*)title afterDelay:(float)afterDelay SNS_DEPRECATED_ATTRIBUTE;
-(void) showFailStatus:(NSString*)title afterDelay:(float)afterDelay SNS_DEPRECATED_ATTRIBUTE;
-(void) showFailStatusKeepMode:(NSString*)title afterDelay:(float)afterDelay SNS_DEPRECATED_ATTRIBUTE;
-(void) showLoading:(NSString*)title imagePath:(NSString*)imagePath SNS_DEPRECATED_ATTRIBUTE;
-(void) showSuccessStatus:(NSString*)title succImagePath:(NSString*)succImagePath afterDelay:(float)afterDelay SNS_DEPRECATED_ATTRIBUTE;
-(void) showFailStatus:(NSString*)title failImagPath:(NSString*)failImagPath afterDelay:(float)afterDelay SNS_DEPRECATED_ATTRIBUTE;

-(void) adjustHUDOrientation;

@end
