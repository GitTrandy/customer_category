//
//  SNSColorPopView.h
//  beatmasterSNS
//
//  Created by chengsong on 13-11-26.
//
//

#import <UIKit/UIKit.h>

typedef enum
{
    SNSColorPopViewStyleDefault = 0,    // // 默认Style
}SNSColorPopViewStyle;

@interface SNSColorPopView : UIView
// // 彩色背景View
@property(nonatomic,strong)UIImageView *bgImgView;

// // 根据style初始化
-(id)initWithStyle:(SNSColorPopViewStyle)style;

// // 启动动画
-(void)startAnimation;

@end
