//
//  SNSDialogueView.h
//  beatmasterSNS
//
//  Created by chengsong on 13-10-29.
//
//

#import <UIKit/UIKit.h>
#import "DialogueContentView.h"
#import "SNSDialogueCommon.h"

//************************//
//         对话框          //
//************************//

// // 对话内容View中的按钮点击事件的回调
typedef void (^DialogueBtnClickBlock)(id btn, NSString *eventKey);
// // 对话框中的关闭( "X" )按钮的回调
typedef void (^DialogueCloseBtnBlock)(id closeBtn);
// // 根据按钮的EventKey动态获取下一个对话内容View的回调
typedef DialogueContentView* (^DialogueContentSourceBlock)(NSString *eventKey);
@interface SNSDialogueView : UIView

// // 整个对话框中可能出现的对话内容
@property(nonatomic,retain)NSMutableDictionary *dialogueContentViewPool;
// // DialogueContentView中的Button在触发切换对话内容的同时，还会执行此Block
@property(nonatomic,copy)DialogueBtnClickBlock dialogueBtnClickBlock;
// // 关闭按钮点击事件Block，当为nil的时候默认把DialogueView removeFromSuperView
@property(nonatomic,copy)DialogueCloseBtnBlock dialogueCloseBtnBlock;
// // 背景颜色类型
@property(nonatomic,assign)SNSDialogueBgStyle   dialogueBgStyle;
/*
 *  @brief: 根据背景色类型和对话内容views创建对话框
 *  @param: bgStyle
 *          背景类型，对应每个大功能模块的颜色主题
 *  @param: contentViews
 *          对话框中可能出现的对话内容，都是DialogueContentView,
 *          DialogueContentView的定制参看DialogueContentView.h
 *  @param: firstKey
 *          第一个要显示的对话内容View的Key
 *  @param: block
 *          DialogueContentView中的Button在触发切换对话内容的同时，还会执行此Block
 */
- (id)initWithBgStyle:(SNSDialogueBgStyle)bgStyle contentViews:(NSArray *)contentViews firstKey:(NSString *)firstKey dialogueBtnClickBlock:(DialogueBtnClickBlock)block;

/*
 *  @brief: 根据背景色类型和动态获取的对话内容view创建对话框
 *  @param: bgStyle
 *          背景类型，对应每个大功能模块的颜色主题
 *  @param: firstKey
 *          第一个要显示的对话内容View的Key
 *  @param: sourceBlock
 *          通过这个Block动态获取响应EventKey的那个对话内容View
 *  @param: block
 *          DialogueContentView中的Button在触发切换对话内容的同时，还会执行此Block
 */
- (id)initWithBgStyle:(SNSDialogueBgStyle)bgStyle firstKey:(NSString *)firstKey DialogueContentSourceWithKey:(DialogueContentSourceBlock)sourceBlock dialogueBtnClickBlock:(DialogueBtnClickBlock)block;

/*
 *  @brief: 切换到下一个要显示的对话内容View
 *  @param: contentViewKey
 *          即将要显示的下一个对话内容View所对应的eventKey
 */
-(void)goNextDialogueContentViewWithKey:(NSString *)contentViewKey;
/*
 *  @brief: 切换到下一个要显示的对话内容View
 *  @param: contentView
 *          即将要显示的下一个对话内容View
 */
-(void)goNextDialogueContentViewWithContentView:(DialogueContentView *)contentView;

/*
 *  @brief: 播放第一次弹出来的动画
 */
-(void)startAnimation;

/*
 *  @brief: 调整背景位置
 */
-(void)resetDialogueBgViewPosx:(CGFloat)dx y:(CGFloat)dy;
/*
 *  @brief: 全局的一个对话框，一般用于两个View之间的对话框内容更改
 */
+(SNSDialogueView *)shareSNSDialogueViewWithBgStyle:(SNSDialogueBgStyle)bgStyle;
+(void)shareSNSDialogueViewRemoveFromSuperView;
/*
 *  @brief: 销毁全局对话框
 */
+(void)deleteShareSNSDialogueView;
@end
