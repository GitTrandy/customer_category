//
//  DialogueButton.h
//  beatmasterSNS
//
//  Created by chengsong on 13-10-29.
//
//

#import <UIKit/UIKit.h>

// // DialogueButton 公用的EventKey
#define Key_ToCheckMoneyContentView       @"ToCheckMoney"       // // 去检查金额是否充足View
#define Key_ToNotEnoughMoneyView          @"ToNotEnoughMoney"   // // 去金额不足View
//#define Key_ToBuyRequestView              @"ToBuyRequest"       // // 暂时
#define Key_ToWaitNetRequestView          @"ToWaitNetRequest"   // // 去网络等待View
#define Key_ToCloseView                   @"ToCloseView"        // // 关闭对话框事件
#define Key_ToChargeMoney                 @"ToChargeMoney"      // // 去充值事件
#define Key_ToPetFoodMoneyView            @"ToPetFoodMoney"     // // 去计算宠物食物金额View

typedef enum
{
    MoneyTypeCoin = 0,      // // 闪光
    MoneyTypeDiamond,       // // 钻石
}MoneyType;

@class DialogueContentView;
@interface DialogueButton : UIButton
// // 此按钮被点击之后将引起事件的Key
// // 主要用在SNSDialogueView中对应跳到哪一个对话内容的Key
@property(nonatomic,retain) NSString *eventKey;
@property(nonatomic,assign) DialogueContentView *dialogueContentView;

/*
 *  @brief: 初始化一个DialogueButton
 *  @param: origin
 *          按钮的位置origin，按钮的大小按图片大小决定
 *  @param: normalImg
 *          普通状态按钮图片名称
 *  @param: highlightImg
 *          点中高亮状态图片名称
 *  @param: eventKey
 *          按钮被点击之后，触发的事件标记，比如eventKey = @"ToSecondView"：代表
 *          点击这个按钮之后会调转到标记为"ToSecondView"的view，或者事件
 */
- (id)initWithPosition:(CGPoint)origin normalImg:(NSString *)normalImg highlight:(NSString *)highlightImg eventKey:(NSString *)eventKey;
/*
 *  @brief: 初始化一个autorelease的DialogueButton(完全自己处理点击事件)
 *  @param: 同上
 */
+ (id)DialogueButtonWithPosition:(CGPoint)origin normalImg:(NSString *)normalImg highlight:(NSString *)highlightImg eventKey:(NSString *)eventKey target:(id)target action:(SEL)actionSel;
/*
 *  @brief: (推荐)创建一个点击事件交给所指定的DialogueContentView处理的Button，
 *          一般这个被指定的view是包含这个Button的view
 *  @param: 同上
 *  @param: dialogueContentView
 *          所指定的DialogueContentView,一般是包含这个Button的DialogueContentView.
 */
+ (id)DialogueButtonWithPosition:(CGPoint)origin normalImg:(NSString *)normalImg highlight:(NSString *)highlightImg eventKey:(NSString *)eventKey target:(DialogueContentView *)dialogueContentView;

@end
