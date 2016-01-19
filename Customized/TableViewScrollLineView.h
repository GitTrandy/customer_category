//
//  TableViewScrollLineView.h
//  beatmasterSNS
//
//  Created by chengsong on 13-4-24.
//
//

#import <UIKit/UIKit.h>

typedef enum
{
    ScrollLineStyleBLue  = 0, // // 俱乐部大厅
    ScrollLineStylePurple,        // // 战报
    ScrollLineStyleYellow,           // // 档案
    ScrollLineStyleRed,              // // 商城
    ScrollLineStyleGreen,           // 练习
    ScrollLineStyleGray             // 消息
    
}ScrollLineStyle;

@interface TableViewScrollLineView : UIView
{
    ScrollLineStyle     _lineStyle;
    UIScrollView        *_superScrollView;
    
    // // scroll line 宽 高
    CGFloat             _lineWidth;
    CGFloat             _lineHeight;
    
    // // line 偏移量
    CGFloat             _lineMargin;
    
    // // 刚开始的时候不显示
    BOOL                _isFirstShow;
}

- (id)initWithSuperScrollView:(UIScrollView *)scrollView lineStyle:(ScrollLineStyle)style margin:(CGFloat)margin;
// // 设置scroll line 的位置和长度
-(void)doSetScrollLineViewFrame;
// // scroll line 隐藏消失动画
-(void)doSetHideAnimation;

#define TVSLV_HideTime  0.2f
// // 最小的line长度
#define TVSLV_MinLineHeight (30.0f*SNS_SCALE_H)

@end
