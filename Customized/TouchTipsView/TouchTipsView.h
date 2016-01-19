//
//  TouchTipsView.h
//  TipsView
//
//  Created by chengsong on 13-8-20.
//  Copyright (c) 2013年 chengsong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopTipsView.h"

typedef enum
{
    TouchTipsShowDefault = 0,   // // 默认中间/自动选择
    TouchTipsShowTop,           // // 上
    TouchTipsShowBot,           // // 下
    TouchTipsShowLeft,          // // 左
    TouchTipsShowRight,         // // 右
}TouchTipsShow;

@interface TouchTipsView : UIView
{
    @private
    TouchTipsShow       _touchTipsShowOrientation;
    CGPoint             _curCenterPoint;
    CGFloat             _margin;
    UIView              *_mapView;
//    UIControl           *_popTipsView;
    PopTipsView           *_popTipsView;
    
    UIImageView         *_tipsBg;
    UIImage             *_tipsBgImg;
    BOOL                _isTipsBgSizeFitText;
    UIFont              *_labelFont;
    UIColor             *_textColor;
    
    @public
    NSString            *_tipsText;
    UILabel             *_tipsLabel;
    BOOL                _autoShowOrientation;
    
}
@property(nonatomic, copy) NSString *tipsText;
@property(nonatomic,assign) BOOL    autoShowOrientation;
@property(nonatomic,assign) CGFloat margin;
@property(nonatomic,retain) UIImage *tipsBgImg;
@property(nonatomic,copy)   UIFont  *labelFont;
@property(nonatomic,copy)   UIColor *textColor;
@property(nonatomic,assign) BOOL    isTipsBgSizeFitText;

-(id)initWithFrame:(CGRect)frame orien:(TouchTipsShow)orien text:(NSString *)text margin:(CGFloat)margin;

+(id)sharedTouchTipsView;

//-(void)popTouchTipsView:(CGRect)targetFrame orien:(TouchTipsShow)orien text:(NSString *)text margin:(CGFloat)margin;
-(void)dismissPopTipsView;

-(void)popTouchTipsView:(CGRect)targetFrame orien:(TouchTipsShow)orien text:(NSString *)text margin:(CGFloat)margin withBgImg:(UIImage *)bgImg bgSizeFitText:(BOOL)isBgSizeFitText font:(UIFont *)labelFont textColor:(UIColor *)textColor;

@end

#define TTV_MaxLabelSize    CGSizeMake(150.0f*SNS_SCALE, 999.0f)
#define TTV_edgeWidth   5.0f*SNS_SCALE
