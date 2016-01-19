//
//  SNSDialogueView.m
//  beatmasterSNS
//
//  Created by chengsong on 13-10-29.
//
//

#import "SNSDialogueView.h"

#import "ActionItemParallel.h"

static SNSDialogueView *s_shareSNSDialogueView = nil;
@interface SNSDialogueView()

// // 两个用来用来切换对话内容的DialogueContentView
// // 当前显示的对话内容
@property(nonatomic,retain)DialogueContentView *curContentView;
// // 前一次显示过的对话内容
@property(nonatomic,retain)DialogueContentView *preContentView;
// // 对话框关闭按钮
@property(nonatomic,retain)CustomUIButton      *closeBtn;
// // 对话框背景View
@property(nonatomic,retain)UIImageView         *dialogueBgView;
// // 背景颜色类型
//@property(nonatomic,assign)SNSDialogueBgStyle   dialogueBgStyle;
// // 第一个要显示的ContentView的Key
@property(nonatomic,copy)NSString *firstContentViewKey;
@property(nonatomic,copy)DialogueContentSourceBlock dialogueSourceBlock;

// // 第一次对话框启动的动画
@property(nonatomic,retain)ActionItemParallel   *popViewAction;
@property(nonatomic,assign)BOOL isPopViewActionDone;

@end

@implementation SNSDialogueView

- (id)initWithBgStyle:(SNSDialogueBgStyle)bgStyle contentViews:(NSArray *)contentViews firstKey:(NSString *)firstKey dialogueBtnClickBlock:(DialogueBtnClickBlock)block
{
    self = [super initWithFrame:SCREEN_FRAME];
    if (self) {
        // // init codes
        [self dialogueViewVariablesInit];
        
        self.dialogueBgStyle = bgStyle;
        [self addDialogueContentViewWithArray:contentViews];
        self.firstContentViewKey = firstKey;
        self.dialogueBtnClickBlock = block;
        
        [self createDialogueView];
        
    }
    
    return self;
}

- (id)initWithBgStyle:(SNSDialogueBgStyle)bgStyle firstKey:(NSString *)firstKey DialogueContentSourceWithKey:(DialogueContentSourceBlock)sourceBlock dialogueBtnClickBlock:(DialogueBtnClickBlock)block
{
    self = [super initWithFrame:SCREEN_FRAME];
    if (self) {
        // // init codes
        [self dialogueViewVariablesInit];
        
        self.dialogueBgStyle = bgStyle;
        self.firstContentViewKey = firstKey;
        self.dialogueBtnClickBlock = block;
        self.dialogueSourceBlock = sourceBlock;
        
        [self createDialogueView];
        
    }
    
    return self;
}

+(SNSDialogueView *)shareSNSDialogueViewWithBgStyle:(SNSDialogueBgStyle)bgStyle
{
    if (s_shareSNSDialogueView == nil)
    {
        s_shareSNSDialogueView = [[SNSDialogueView alloc]initWithBgStyle:bgStyle firstKey:nil DialogueContentSourceWithKey:nil dialogueBtnClickBlock:nil];
    }
    else
    {
        if (bgStyle != s_shareSNSDialogueView.dialogueBgStyle)
        {
            [s_shareSNSDialogueView release];
            s_shareSNSDialogueView = [[SNSDialogueView alloc]initWithBgStyle:bgStyle firstKey:nil DialogueContentSourceWithKey:nil dialogueBtnClickBlock:nil];
        }
    }
    return s_shareSNSDialogueView;
}
+(void)shareSNSDialogueViewRemoveFromSuperView
{
    if (s_shareSNSDialogueView != nil)
    {
        [s_shareSNSDialogueView removeFromSuperview];
    }
}
+(void)deleteShareSNSDialogueView
{
    if (s_shareSNSDialogueView != nil)
    {
        [s_shareSNSDialogueView removeFromSuperview];
        [s_shareSNSDialogueView release];
        s_shareSNSDialogueView = nil;
    }
}

-(void)dealloc
{
    self.curContentView = nil;
    self.preContentView = nil;
    self.closeBtn = nil;
    self.dialogueBgView = nil;
    self.firstContentViewKey = nil;
    self.dialogueBtnClickBlock = nil;
    self.dialogueCloseBtnBlock = nil;
    self.dialogueSourceBlock = nil;
    self.dialogueContentViewPool = nil;
    [self deletePopViewAction];
    
    [super dealloc];
    CSLog(@"%s",__FUNCTION__);
}

-(void)dialogueViewVariablesInit
{
    self.dialogueBgStyle = SNSDialogueBgStyleDefault;
    self.dialogueContentViewPool = [NSMutableDictionary dictionary];
}

/*
 *  @brief: 把所有的DialogueContentView按EventKey整理好，方便查找
 */
-(void)addDialogueContentViewWithArray:(NSArray *)contentViewArr
{
    if (contentViewArr == nil || ![contentViewArr isKindOfClass:[NSArray class]])
    {
        return;
    }
    
    for (DialogueContentView *view in contentViewArr)
    {
        if ([view isKindOfClass:[DialogueContentView class]] && view.eventKey != nil)
        {
            [self.dialogueContentViewPool setObject:view forKey:view.eventKey];
        }
    }
}

/*
 *  @brief: 对话框布局
 */
-(void)createDialogueView
{
    // // 黑色背景
    self.backgroundColor = SNS_BLACKCOLOR_BG;
    
    // // 对话框背景
    UIImage *bgImg = [UIImage imageNamed_New:[NSString stringWithFormat:@"Com_PMV_bg%02d.png",_dialogueBgStyle]];
    if (bgImg == nil)
    {
        bgImg = [UIImage imageNamed_New:@"Com_PMV_bg01.png"];
    }
    self.dialogueBgView = [[[UIImageView alloc]initWithImage:bgImg]autorelease];
    _dialogueBgView.frame = SNSRect(0, 0, bgImg.size.width * SNS_SCALE, bgImg.size.height * SNS_SCALE);
    _dialogueBgView.center = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f);
    _dialogueBgView.userInteractionEnabled = YES;
    [self addSubview:_dialogueBgView];
    
    // // 显示第一个对话内容
    [self goNextDialogueContentViewWithKey:_firstContentViewKey];
    
    // // "X" 按钮
    self.closeBtn = [CustomUIButton buttonWithNormalImage:[NSString stringWithFormat:@"Com_PMV_xBtn%02d_1.png",_dialogueBgStyle] highlightImage:[NSString stringWithFormat:@"Com_PMV_xBtn%02d_2.png",_dialogueBgStyle] target:self action:@selector(dialogueCloseBtnClicked:) sound:SFX_CLOSEWIN];
    [_dialogueBgView addSubview:_closeBtn];
    _closeBtn.frame = SNSRect(_dialogueBgView.frame.size.width - 50.0f * SNS_SCALE, 2.0f*SNS_SCALE, 50.0f * SNS_SCALE, 50.0f * SNS_SCALE);
    
}

/*
 *  @brief: 切换到下一个要显示的对话内容View
 *  @param: contentViewKey
 *          即将要显示的下一个对话内容View所对应的eventKey
 */
-(void)goNextDialogueContentViewWithKey:(NSString *)contentViewKey
{
    
    if ([contentViewKey isEqualToString:Key_ToCloseView])
    {
        // // 当传递过来关闭Key的时候
        [self dialogueCloseBtnClicked:nil];
        
        return;
    }
    
    DialogueContentView *contentView = nil;
    if (contentViewKey)
    {
        if (self.dialogueSourceBlock)
        {
            // // 动态获取模式
            contentView = self.dialogueSourceBlock(contentViewKey);
        }
        if (contentView == nil)
        {
            // // 初始化的时候就创建好的模式
            contentView = [_dialogueContentViewPool objectForKey:contentViewKey];
        }
    }
    
    if (!contentView)
    {
        // // 当没有下一个跳转view的时候，保持原样不变
        return;
    }
    
    [self goNextDialogueContentViewWithContentView:contentView];
   
}

/*
 *  @brief: 切换到下一个要显示的对话内容View
 *  @param: contentView
 *          即将要显示的下一个对话内容View
 */
-(void)goNextDialogueContentViewWithContentView:(DialogueContentView *)contentView
{
    if (contentView == nil || ![contentView isKindOfClass:[DialogueContentView class]])
    {
        return;
    }
    
    // // 切换显示的ContentView
    self.preContentView = self.curContentView;
   
    self.curContentView = contentView;
    
    if (_preContentView)
    {
        // // 第一次启动动画的View释放前一个View的时候需要先释放动画,动画决定，暂时只能这样
        [self deletePopViewAction];
        [_preContentView disAppearWithAni];
    }
    
    __block typeof(self) weakSelf = self;
    if (_curContentView.btnEventBlock == nil)
    {
        
        _curContentView.btnEventBlock = ^(id sender){
            [weakSelf curContentViewBtnClick:sender];
        };
    }
    else
    {
        
        BtnEventBlock tmp = Block_copy(_curContentView.btnEventBlock);
        _curContentView.btnEventBlock = ^(id sender)
        {
            [weakSelf curContentViewBtnClick:sender];
            tmp(sender);
        };
        Block_release(tmp);
    }
    _curContentView.alpha = 0.0f;
    [_dialogueBgView addSubview:_curContentView];
    [_curContentView appearWithAni];
    
    [_dialogueBgView bringSubviewToFront:_closeBtn];
}

/*
 *  @brief: DialogueContentView中的按钮点击的时候触发的事件处理
 */
-(void)curContentViewBtnClick:(id)sender
{
    DialogueButton *btn = (DialogueButton *)sender;
    // // 内部对话内容切换
    if (btn && [btn isKindOfClass:[DialogueButton class]])
    {
        [self goNextDialogueContentViewWithKey:btn.eventKey];
    }
    // // 外部Block调用
    if (_dialogueBtnClickBlock)
    {
        _dialogueBtnClickBlock(sender,btn.eventKey);
    }
}

/*
 *  @brief: DialogueView关闭按钮事件处理
 */
-(void)dialogueCloseBtnClicked:(id)sender
{
    if (_dialogueCloseBtnBlock)
    {
        _dialogueCloseBtnBlock(sender);
    }
    else
    {
        [self removeFromSuperview];
    }
}

-(void)startAnimation
{
    if (self.isPopViewActionDone)
    {
        return;
    }
    self.isPopViewActionDone = YES;
    assert(nil==_popViewAction);
    NSArray *arr = [NSArray arrayWithObjects:self.dialogueBgView,self.curContentView, nil];
    self.popViewAction = [Utils createViewAnimationWithViewArray:arr];
    [_popViewAction startActionItems];
    
}
-(void)deletePopViewAction
{
    if (self.popViewAction != nil)
    {
        [self.popViewAction clearActionItems];
        self.popViewAction = nil;
    }
}

-(void)resetDialogueBgViewPosx:(CGFloat)dx y:(CGFloat)dy
{
    if (self.dialogueBgView)
    {
        CGRect rect = self.dialogueBgView.frame;
        self.dialogueBgView.frame = CGRectOffset(rect, dx, dy);
    }
}

@end
