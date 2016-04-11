//
//  DialogueButton.m
//  beatmasterSNS
//
//  Created by chengsong on 13-10-29.
//
//

#import "DialogueButton.h"
#import "DialogueContentView.h"

@interface DialogueButton ()

// // 按钮当时是不是能响应那次点击事件
@property(nonatomic,assign)BOOL canBtnDoAction;
@property(nonatomic,assign)id target;
@property(nonatomic,assign)SEL actionSel;

@end

@implementation DialogueButton

- (id)initWithPosition:(CGPoint)origin normalImg:(NSString *)normalImg highlight:(NSString *)highlightImg eventKey:(NSString *)eventKey
{
    self = [super init];
    if (self) {
        // // init codes
        
        UIImage *norImg = [UIImage imageNamed_New:normalImg];
        UIImage *hlImg = [UIImage imageNamed_New:highlightImg];
        if (norImg)
        {
            [self setBackgroundImage:norImg forState:UIControlStateNormal];
        }
        if (hlImg)
        {
            [self setBackgroundImage:hlImg forState:UIControlStateHighlighted];
        }
        self.eventKey = eventKey;
        self.frame = SNSRect(origin.x, origin.y, norImg.size.width*SNS_SCALE, norImg.size.height*SNS_SCALE);
        self.exclusiveTouch = YES;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15 * SNS_SCALE];
        
        [self addTarget:self action:@selector(dialogueButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.canBtnDoAction = YES;
    }
    
    return self;
}

+ (id)DialogueButtonWithPosition:(CGPoint)origin normalImg:(NSString *)normalImg highlight:(NSString *)highlightImg eventKey:(NSString *)eventKey target:(id)target action:(SEL)actionSel
{
    DialogueButton *ret_btn = [[self alloc]initWithPosition:origin normalImg:normalImg highlight:highlightImg eventKey:eventKey];
    ret_btn.target = target;
    ret_btn.actionSel = actionSel;
    return [ret_btn autorelease];
}

+ (id)DialogueButtonWithPosition:(CGPoint)origin normalImg:(NSString *)normalImg highlight:(NSString *)highlightImg eventKey:(NSString *)eventKey target:(DialogueContentView *)dialogueContentView
{
    DialogueButton *ret_btn = [[self alloc]initWithPosition:origin normalImg:normalImg highlight:highlightImg eventKey:eventKey];
    ret_btn.dialogueContentView = dialogueContentView;
    return ret_btn;
}

/*
 *  @brief: 按钮点击处理判定
 */
-(void)dialogueButtonClicked:(id)sender
{
    if (_canBtnDoAction)
    {
        PlayEffect(SFX_BUTTON);
        self.canBtnDoAction = NO;
        [self performSelector:@selector(clickEventDone:) withObject:sender afterDelay:0.2f];
    }
    
}
/*
 *  @brief: 按钮点击事件处理
 */
-(void)clickEventDone:(id)sender
{
    // // 自己处理模式
    if (_target && [_target respondsToSelector:_actionSel])
    {
        [_target performSelector:_actionSel withObject:sender];
        self.canBtnDoAction = YES;
    }
    else
    {
        // // 指定的对话内容View管理模式
        if (_dialogueContentView && _dialogueContentView.btnEventBlock)
        {
            _dialogueContentView.btnEventBlock(sender);
            self.canBtnDoAction = YES;
        }
    }
}

-(void)dealloc
{
    self.eventKey = nil;
    [super dealloc];
    CSLog(@"%s",__FUNCTION__);
}

@end
