//
//  MessageView.h
//  Message
//
//  Created by chengsong on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//#import "BroadcastLabel.h"
#import "CSTextView.h"
#import "DataManager.h"
#define MessageFontSize (15 * SNS_SCALE)
#define MessageFont [UIFont systemFontOfSize:15 * SNS_SCALE]
#define MessageNormalColor SNSColorMake(153.0f,153.0f,153.0f,1.0f)
#define MessageSpecialColor SNSColorMake(255.0f,119.0f,117.0f,1.0f)
#define MessageLineSpace 1.0

#define MsgMaxWidth    9999
#define MsgMaxHeight   9999

#define MessageLabelScrollUpDuration    1.0f
#define MessageLabelRadeOutTime         1.0f
#define MessageLabelDelayTime           4.0f
#define MessageLabelTimerInterval       0.02f

#define DefaultShowMsgViewBgImg @"Com_messageViewBg_1.png"

typedef enum
{
    MessageViewStyleDefault = 0,           // // 默认
    MessageViewStyleMainView = 1,          // // MainVC
    MessageViewStyleClubView,              // // 俱乐部
    MessageViewStylePracticeView,          // // 练习
    MessageViewStyleBattleInfoView,        // // 战报
    MessageViewStyleMallView,              // // 商城
    MessageViewStyleProfileView,           // // 档案
    MessageViewStyleSearchView             // // 搜索
}MessageViewStyle;

@interface MessageView : UIView<CSTextViewDelegate>
{
    // // 广播背景图
    UIImageView        *_bgView;
    
    // // 信息栏
    CSTextView         *_msgTextViewOne;
    CSTextView         *_msgTextViewTwo;
    
    // // 移动的四个中心位置
    CGPoint            _labelPoint_Top;     // // 上
    CGPoint            _labelPoint_Mid;     // // 中
    CGPoint            _labelPoint_Bot;     // // 下
    CGPoint            _labelPoint_underBot;// // 再下
    CGFloat            _labelMoveOffset;
    
    // // 包含所有信息的数组
    // // 未处理的广播消息
    NSMutableArray     *_messageArray;
    // // 经过字符串处理的广播消息(NSAttributeString)
    //NSMutableArray     *_msgStrAttrArray;
    // // 经过字符串处理之后每条广播消息在Label中占的行数，行高信息
    //NSMutableArray     *_msgStrSizeArray;
    // // 所有广播消息的行信息集合
    NSMutableArray     *_msgLineComArr;
    // // 所有广播消息的行的高度的集合
    NSMutableArray     *_msgLineSizeArr;
    
    
    // // 前消息的索引
    int         _preMsgIndex;
    
    // // 当前消息的索引
    int         _curMsgIndex;
    
    // // 消息所占的行数
    int         _msgLineNum;
    
    // // 是否新消息
    //BOOL        _isNewMsg;
    
    // // 是否停止动画
    BOOL        _isRunning;
    
    // // 是否需要刷新Message数组
    BOOL        _isNeedRefreshMsgArr;
    
    // // 是否是按HomeKey进入后台的
    BOOL        _isHomeKeyPressed;
    
    // // 字体大小
    NSInteger   _fontSize;
    
    // // 字体
    NSString    *_fontName;
    
    // // 字符串占的矩形大小
    //MessageSize *_msgStrSize;
    
    // // 消息显示范围view
    UIView  *_showMsgRectView;
    //CGRect  _showMsgTextRect;
    
    // // MessageView 种类
    MessageViewStyle    _messageViewStyle;
    
    int     _delayTimes;
    int     _animationTimes;
    int     _fadeOutTimes;
    
    RNTimer *_aniRNTimer;
    
}

@property(nonatomic,retain)NSMutableArray  *messageArray;
@property(nonatomic,assign)BOOL     isRunning;
@property(nonatomic,assign,readonly)NSInteger fontSize;
@property(nonatomic,assign,readonly)NSString  *fontName;

+(MessageView *)createMessageViewWithFrame:(CGRect)frame messageViewStyle:(MessageViewStyle)style;
-(void)doSetBGImg:(UIImage *)bgImg;
-(void)doSetWordsFrame:(CGRect)frame;
//-(void)playMessage;
-(void)doRelease;
-(void)doStartBroadcast;
-(void)doStopBroadcast;

@end

