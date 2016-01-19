//
//  MessageView.m
//  Message
//
//  Created by chengsong on 12-8-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MessageView.h"
#import "SoloVC.h"
#import "MacroBMSns.h"
#import "ProfileVC.h"

static  int s_lastMsgShowedIndex = -1;

@interface MessageView()
// // 初始化消息View
-(void)createView;

-(void)doRefreshMessageArray;

//-(void)getMessageFromSever;

// // 一个消息显示完的回调
-(void)animationDidStopMsgView:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
@end

@implementation MessageView
@synthesize messageArray = _messageArray;
@synthesize isRunning = _isRunning;
@synthesize fontSize = _fontSize;
@synthesize fontName = _fontName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _messageViewStyle = MessageViewStyleDefault;
        
        [self createView];
        
        [self doRefreshMessageArray];
        
        NSNotificationCenter *noticeCenter = [NSNotificationCenter defaultCenter];
        // // 邀请消息
        [noticeCenter addObserver:self selector:@selector(refreshMessageArrayFromDataManager:) name:@"MessageViewData" object:nil];
        
        //[noticeCenter addObserver:self selector:@selector(didOneCircleMessage:) name:@"MessageOverCircle" object:nil];
        _isNeedRefreshMsgArr = NO;
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame messageViewStyle:(MessageViewStyle)style
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _messageViewStyle = style;
        
        [self createView];
        
        [self doRefreshMessageArray];
        
        NSNotificationCenter *noticeCenter = [NSNotificationCenter defaultCenter];
        // // 邀请消息
        [noticeCenter addObserver:self selector:@selector(refreshMessageArrayFromDataManager:) name:@"MessageViewData" object:nil];
        
        //[noticeCenter addObserver:self selector:@selector(didOneCircleMessage:) name:@"MessageOverCircle" object:nil];
        _isNeedRefreshMsgArr = NO;
        
        [self addNotification];
    }
    return self;
}

+(MessageView *)createMessageViewWithFrame:(CGRect)frame messageViewStyle:(MessageViewStyle)style
{
    MessageView *messageView = [[MessageView alloc]initWithFrame:frame messageViewStyle:style];
    
    return messageView;
}

-(void)dealloc
{
    [self removeNotification];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_bgView release];
    
    _msgTextViewOne.delegate = nil;
    _msgTextViewTwo.delegate = nil;
    [_msgTextViewOne release];
    [_msgTextViewTwo release];
    [_messageArray release];

    [_msgLineComArr release];
    [_msgLineSizeArr release];
    [_showMsgRectView release];
    if (_aniRNTimer)
    {
        [_aniRNTimer release];
    }

    [super dealloc];
    CSLog(@"%s",__FUNCTION__);
    
}

-(void)refreshMessageArrayFromDataManager:(NSNotification *)notice
{
    _isNeedRefreshMsgArr = YES;
}

-(void)doRefreshMessageArray
{
    if (_messageArray == nil)
    {
        _messageArray = [[NSMutableArray alloc]init];
    }
    else
    {
        [_messageArray removeAllObjects];
    }
    
//    NSArray *tmpArr = [[DataManager shareDataManager].msg_BroadcastInfo_Dic allValues];
    NSMutableDictionary *broadcastInfoDic_ = [NSMutableDictionary dictionary];
    [[DataManager shareDataManager].localDBManager selectDAta_BroadcastMsgInfo_Table_2:broadcastInfoDic_];
    NSArray *tmpArr = [broadcastInfoDic_ allValues];
    
    for (BroadCastMessageInfo *info in tmpArr)
    {
        if (_messageArray == nil)
        {
            break;
        }
        if (info != nil && [info isKindOfClass:[BroadCastMessageInfo class]])
        {
            [_messageArray addObject:info.message];
        }
        CSLog(@"%@",info.message);
    }
    [self doAnalysisMessage];
    
    _isNeedRefreshMsgArr = NO;
}


/*
 *  @brief: 1、对label需要显示的所有广播消息做字符串分析
 *          2、计算所有广播消息所占的行数，高度
 */
-(void)doAnalysisMessage
{
    if (_messageArray == nil ||[_messageArray count] == 0)
    {
        return;
    }
    
    if (_msgLineComArr == nil)
    {
        _msgLineComArr = [[NSMutableArray alloc]init];
    }
    else
    {
        [_msgLineComArr removeAllObjects];
    }
    if (_msgLineSizeArr == nil)
    {
        _msgLineSizeArr = [[NSMutableArray alloc]init];
    }
    else
    {
        [_msgLineSizeArr removeAllObjects];
    }
    
//    NSArray *arrrarr = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0", nil];
//    [_messageArray removeAllObjects];
//    [_messageArray addObjectsFromArray:arrrarr];
    
    CSTextView *analysisTextView = [[[CSTextView alloc]initWithFrame:CGRectMake(0, 0, _showMsgRectView.frame.size.width, 9999)]autorelease];
    analysisTextView.normalFont = MessageFont;
    analysisTextView.normalColor = MessageNormalColor;
    CGSize limitSize = CGSizeMake(_showMsgRectView.frame.size.width, 99999);
    
    CGFloat lineHeight = 0.0f;
    for (NSString *msgStr in _messageArray)
    {
        analysisTextView.originalString = msgStr;
        NSArray *lineComArrTmp = [analysisTextView doGetLinesAttrCompomentsArr];
        NSMutableArray *lineComArr = [NSMutableArray array];
        NSMutableArray *lineHeightArr = [NSMutableArray array];
        int linesCount = lineComArrTmp.count;
        for (int i=linesCount-1; i>=0; i--)
        {
            CSTextCompoment *com = lineComArrTmp[i];
            analysisTextView.csTextCompoment = com;
            CGSize size = [analysisTextView doGetMinSizeInContainSize:limitSize];
            lineHeight = size.height;
            [lineHeightArr addObject:@(lineHeight)];
            [lineComArr addObject:com];
            
        }
        
        // 存储每条Message的所有行数据
        [_msgLineComArr addObject:lineComArr];
        [_msgLineSizeArr addObject:lineHeightArr];
    }
}


#pragma mark - DataOperationDelegate Methods

#pragma mark - private methods
// //******************// //
// //   初始化消息View   // //
-(void)createView
{
    // // 初始化属性参数
    _preMsgIndex = 0;
    _curMsgIndex = s_lastMsgShowedIndex+1;  // // 直接播放上一个MessageView播放的下一条
    _msgLineNum = 0;
    _isRunning  = NO;
    _fontName = @"华文楷体";
    _fontSize = 10;
    _isHomeKeyPressed = NO;
    
    NSString *viewBgStr = nil;
    if (IS_IPHONE5)
    {
        viewBgStr = [NSString stringWithFormat:@"Com_messageViewBg_%d_i5.png",_messageViewStyle];
    }
    else
    {
        viewBgStr = [NSString stringWithFormat:@"Com_messageViewBg_%d.png",_messageViewStyle];
    }
    UIImage *msgViewBgImg = [UIImage imageNamed_New:viewBgStr];
    if (msgViewBgImg == nil)
    {
        msgViewBgImg = [UIImage imageNamed_New:DefaultShowMsgViewBgImg];
    }
    
    _bgView = [[UIImageView alloc]initWithImage:msgViewBgImg];
    [self addSubview:_bgView];
    _bgView.frame = SNSRect(0, 0, self.frame.size.width, self.frame.size.height);
    
    CGRect showMsgRectTmp = SNSRect(50 * SNS_SCALE, 0.0f, _bgView.frame.size.width - 20.f * SNS_SCALE - 50.f * SNS_SCALE, 20.f * SNS_SCALE);
    _showMsgRectView = [[UIView alloc]initWithFrame:showMsgRectTmp];
    [_showMsgRectView setClipsToBounds:YES];
    _showMsgRectView.backgroundColor = [UIColor clearColor];
    CGPoint showMsgViewCenter = _showMsgRectView.center;
    showMsgViewCenter.y = _bgView.frame.size.height/2.0f-3.0f*SNS_SCALE;
    _showMsgRectView.center = showMsgViewCenter;
    [self addSubview:_showMsgRectView];
    
    // // 初始化消息TextView 1 2
    _msgTextViewOne = [[CSTextView alloc]initWithFrame:SNSRect(0, 0, _showMsgRectView.frame.size.width, _showMsgRectView.frame.size.height)];
    _msgTextViewOne.normalFont = MessageFont;
    _msgTextViewOne.normalColor = MessageNormalColor;
    _msgTextViewOne.delegate = self;
    _msgTextViewOne.backgroundColor = [UIColor clearColor];
    [_showMsgRectView addSubview:_msgTextViewOne];
    
    _msgTextViewTwo = [[CSTextView alloc]initWithFrame:SNSRect(0, 0, _showMsgRectView.frame.size.width, _showMsgRectView.frame.size.height)];
    _msgTextViewTwo.normalFont = MessageFont;
    _msgTextViewTwo.normalColor = MessageNormalColor;
    _msgTextViewTwo.delegate = self;
    _msgTextViewTwo.backgroundColor = [UIColor clearColor];
    [_showMsgRectView addSubview:_msgTextViewTwo];
    
    // // label移动的四个中心位置
    CGFloat showMsgRectWidth = _showMsgRectView.frame.size.width;
    CGFloat showMsgRectHeight = _showMsgRectView.frame.size.height;
    _labelPoint_Top = CGPointMake(showMsgRectWidth/2.0f, -1 * showMsgRectHeight/2.0f);
    _labelPoint_Mid = CGPointMake(showMsgRectWidth/2.0f, showMsgRectHeight/2.0f);
    _labelPoint_Bot = CGPointMake(showMsgRectWidth/2.0f, showMsgRectHeight*3.0f/2.0f);
    _labelPoint_underBot = CGPointMake(showMsgRectWidth/2.0f, showMsgRectHeight*5.0f/2.0f);
    _labelMoveOffset = showMsgRectHeight * MessageLabelTimerInterval / MessageLabelScrollUpDuration;
    
}

-(void)animationDidStopMsgView:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    // // 有通知过来，在播放完一个动画后刷新广播数据
    if (_isNeedRefreshMsgArr)
    {
        [self doRefreshMessageArray];
        //_msgLineNum = 0;
    }
    _msgLineNum = 0;
    
    // //过渡到下一个消息ScrollUp
    _curMsgIndex++;
    if (_curMsgIndex>=[_messageArray count])
    {
        // // 回到第一个消息
        _curMsgIndex = 0;
        
    }
    [UIView beginAnimations:@"MessageLabelFadeOut" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:MessageLabelRadeOutTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDelay:MessageLabelDelayTime];
    [UIView setAnimationDidStopSelector:@selector(playMessage)];
    
    _msgTextViewOne.alpha = 0;
    _msgTextViewTwo.alpha = 0;
    [UIView commitAnimations];
}

/*
 *  @brief: 设置消息背景
 */
-(void)doSetBGImg:(UIImage *)bgImg
{
    if (_bgView != nil && bgImg != nil && [bgImg isKindOfClass:[UIImage class]])
    {
        _bgView.image = bgImg;
        _bgView.frame = SNSRect(_bgView.frame.origin.x, _bgView.frame.origin.y, bgImg.size.width * SNS_SCALE, bgImg.size.height * SNS_SCALE);
        
    }
}

/*
 *  @brief: 设置消息内容显示范围
 */
-(void)doSetWordsFrame:(CGRect)frame
{
    if (_showMsgRectView != nil && !CGRectEqualToRect(frame, _showMsgRectView.frame))
    {
        _showMsgRectView.frame = frame;
    }
}

-(void)doStartBroadcast
{
    if (!_isRunning)
    {
        _isRunning = YES;
        [self playMessage];
    }
}
-(void)doStopBroadcast
{
    _isRunning = NO;
    if (_aniRNTimer)
    {
        [_aniRNTimer invalidate];
        [_aniRNTimer release];
        _aniRNTimer = nil;
    }
    [self release];
}

#pragma mark - public methods
// //**************// //
// //  开始播放消息  // //
-(void)playMessage
{
    _delayTimes = 0;
    _animationTimes = MessageLabelScrollUpDuration/MessageLabelTimerInterval;
    _fadeOutTimes = 0;
    _msgLineNum = 0;
    [self doNextLineMsg];
    
    __block MessageView *weakSelf = self;
    if (_aniRNTimer == nil)
    {
        _aniRNTimer = [[RNTimer repeatingTimerWithTimeInterval:MessageLabelTimerInterval block:^{
            //
            [weakSelf animationBlock];
        }] retain];
    }
    
}

-(void)animationBlock
{
    if (_delayTimes > 0)
    {
        // // 停留事件
        _delayTimes--;
        if (_delayTimes == 0)
        {
            _msgLineNum--;
            if (_msgLineNum == 0)
            {
                // // 一条消息结束
                _fadeOutTimes = MessageLabelRadeOutTime / MessageLabelTimerInterval;
            }
            else
            {
                // // 一行消息完成
                [self doNextLineMsg];
                _animationTimes = MessageLabelScrollUpDuration / MessageLabelTimerInterval;
            }
        }
        
        return;
    }
    if (_animationTimes > 0)
    {
        // // 动画，消息翻动事件
        _animationTimes--;
        CGPoint centerOne = _msgTextViewOne.center;
        centerOne.y -= _labelMoveOffset;
        _msgTextViewOne.center = centerOne;
        
        CGPoint centerTwo = _msgTextViewTwo.center;
        centerTwo.y -= _labelMoveOffset;
        _msgTextViewTwo.center = centerTwo;
        if (_animationTimes == 0)
        {
            // // 一行消息移动完成
            _delayTimes = MessageLabelDelayTime / MessageLabelTimerInterval;
            
        }
        
        return;
    }
    if (_fadeOutTimes > 0)
    {
        // // 动画，淡出事件
        _fadeOutTimes--;
        _msgTextViewOne.alpha = _fadeOutTimes * MessageLabelTimerInterval / MessageLabelRadeOutTime;
        _msgTextViewTwo.alpha = _fadeOutTimes * MessageLabelTimerInterval / MessageLabelRadeOutTime;
        if (_fadeOutTimes == 0)
        {
            if (_isNeedRefreshMsgArr)
            {
                [self doRefreshMessageArray];
            }
            _curMsgIndex++;
            if (_curMsgIndex>=[_messageArray count])
            {
                // // 回到第一个消息
                _curMsgIndex = 0;
            }
            [self doNextLineMsg];
            _animationTimes = MessageLabelScrollUpDuration / MessageLabelTimerInterval;
        }
        
        return;
    }
    
        
    
}

-(void)doNextLineMsg
{
    if(_messageArray==nil || [_messageArray count]<=0 || !_isRunning)
    {
        return;
    }
    if ([_messageArray count] < (_curMsgIndex+1) || _curMsgIndex < 0) {
        _curMsgIndex = 0;
        //return;
    }
    
    s_lastMsgShowedIndex = _curMsgIndex;
    CSLog(@"MessageViewCurIndex:%d",s_lastMsgShowedIndex);
    
    _msgTextViewOne.alpha = 1;
    _msgTextViewTwo.alpha = 1;
    // // 即将播放的消息
    
    NSArray *linesComArr = _msgLineComArr[_curMsgIndex];
    NSArray *linesHeightArr = _msgLineSizeArr[_curMsgIndex];
    
    if (_msgLineNum < 0 || _msgLineNum > 20)
    {
        // // 条数 <0 || >20条  就算出错
        return;
    }
    
    // // 设置开始的位置
    if (_msgLineNum == 0)
    {
        // // 是新消息
        _msgLineNum = [linesComArr count];
        if (_msgLineNum <= 0)
        {
            return;
        }
        
        [self doSetCSTextView:_msgTextViewOne comArr:linesComArr lineHeightArr:linesHeightArr lineNum:_msgLineNum-1];
        [self doSetCSTextView:_msgTextViewTwo comArr:linesComArr lineHeightArr:linesHeightArr lineNum:_msgLineNum-2];
        
        _msgTextViewOne.center = _labelPoint_Bot;
        _msgTextViewTwo.center = _labelPoint_underBot;
        
    }
    
    if (_msgTextViewOne.center.y < 0)
    {
        [self doSetCSTextView:_msgTextViewOne comArr:linesComArr lineHeightArr:linesHeightArr lineNum:_msgLineNum-1];
        _msgTextViewOne.center = _labelPoint_Bot;
    }
    if (_msgTextViewTwo.center.y < 0)
    {
        [self doSetCSTextView:_msgTextViewTwo comArr:linesComArr lineHeightArr:linesHeightArr lineNum:_msgLineNum-1];
        _msgTextViewTwo.center = _labelPoint_Bot;
    }
}

/*
 *  @brief: 设置显示广播的textView的内容和Rect
 *      textView        :需要显示的textView
 *      linesComArr     :某个广播的所有行
 *      linesHeightArr  :某个广播所有行的高度
 *      lineNum         :当前要设置的行数(0 1 2 ...)
 */
-(void)doSetCSTextView:(CSTextView *)textView comArr:(NSArray *)linesComArr lineHeightArr:(NSArray *)linesHeightArr lineNum:(int)lineNum
{
    if (textView == nil || linesComArr == nil || linesHeightArr == nil || lineNum < 0)
    {
        return;
    }
    if (![linesComArr isKindOfClass:[NSArray class]] || [linesComArr count] <= lineNum)
    {
        return;
    }
    if (![linesHeightArr isKindOfClass:[NSArray class]] || [linesHeightArr count] <= lineNum)
    {
        return;
    }
    
    textView.csTextCompoment = linesComArr[lineNum];
    
    CGFloat lineHeight = [linesHeightArr[lineNum] floatValue];
    CGRect rect = textView.frame;
    rect.size.height = lineHeight;
    textView.frame = rect;
    
}

-(void)doRelease
{
    _isRunning = NO;
    [self release];
}


#pragma mark-
#pragma mark notification

-(void)addNotification
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(willResignActive) name:@"PressHomeKeyToBackgroundForMsgView" object:nil];
    [center addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)removeNotification
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:@"PressHomeKeyToBackgroundForMsgView" object:nil];
    [center removeObserver:self  name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)willResignActive
{
    CSLog(@"Stop playMessage()");
    _isRunning = NO;
    _isHomeKeyPressed = YES;
    if (_aniRNTimer)
    {
        [_aniRNTimer invalidate];
        [_aniRNTimer release];
        _aniRNTimer = nil;
    }
}

-(void)didBecomeActive
{
    CSLog(@"Start playMessage()");
    if (_isHomeKeyPressed)
    {
        _isHomeKeyPressed = NO;
        [self doStartBroadcast];
    }
}

#pragma mark - CSTextViewDelegate methods
-(void)CSTextView:(CSTextView *)view clickedWithType:(NSString *)clickType withInfo:(NSString *)info
{
    if (clickType && [clickType isKindOfClass:[NSString class]])
    {
        UINavigationController *nav = (UINavigationController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
        
        UIViewController *toVC = nil;
        if ([clickType isEqualToString:[DataManager shareDataManager].self_UserInfo.userID])
        {
            // // 当点击的是自己的名字的时候
            toVC = [[[ProfileVC alloc]init]autorelease];
            toVC.view.frame = SCREEN_FRAME;
            
        }
        else
        {
            toVC = [[[SoloVC alloc]initWithUid:clickType]autorelease];
        }
        [nav pushViewControllerAnimatedWithFIFO:toVC];
    }
    
}

@end
