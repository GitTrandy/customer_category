//
//  SNSBuyDialogueView.h
//  beatmasterSNS
//
//  Created by chengsong on 13-11-4.
//
//

#import <UIKit/UIKit.h>
#import "SNSDialogueView.h"

#define Key_BuyFirstView    @"buyFirstView"

//********************************//
//        用于花钱的购买类           //
// 默认已经嵌入了，花钱确认View、钱不  //
// 足提示View、购买网络等待View      //
@interface SNSBuyDialogueView : SNSDialogueView

// // 确定可以购买之后，是否要显示等待网络请求的状态View，默认是YES。
@property(nonatomic,assign)BOOL needWaitNetRequest;
@property(nonatomic,copy)NSString *checkMoneyText;

/*
 *  @brief: 当第一个View是选择价格之类的View时候的购买类初始化方法
 *  @param: bgStyle
 *          对话背景框的颜色类型
 *  @param: beginView
 *          购买的第一个金额选择或者金额计算View，必须是继承于DialogueContentView
 *          会第一个显示在对话框上
 *  @param: requestBlock
 *          购买请求block
 *  @param: closeBlock
 *          关闭按钮回调，如果block为nil，默认点击之后执行removeFromSuperView方法。
 */
- (id)initWithBgStyle:(SNSDialogueBgStyle)bgStyle beginView:(DialogueContentView *)beginView netRequest:(NetRequestBlock)requestBlock closeBtnBlock:(DialogueCloseBtnBlock)closeBlock;
/*
 *  @brief: 直接给金钱数字信息的购买类的初始化方法
 */
- (id)initWithBgStyle:(SNSDialogueBgStyle)bgStyle moneyNum:(int)moneyNum moneyType:(MoneyType)moneyType checkMoneyText:(NSString *)checkMoneyText commodityImg:(UIImage *)comImg netRequest:(NetRequestBlock)requestBlock closeBtnBlock:(DialogueCloseBtnBlock)closeBlock;

/*
 *  @brief: 当用户在外面需要传递花钱数目的时候执行此方法就进入CheckMoneyView
 *  @param: moneyNum
 *          钱的数字
 *  @param: moneyType
 *          钱的类型，闪光？钻石？
 *  @param: img
 *          需要显示的商品图片
 */
-(void)goToCheckMoneyView:(int)moneyNum moneyType:(MoneyType)type checkMoneyText:(NSString *)checkMoneyText commodityImg:(UIImage *)img textAlign:(CSTextAlignment)align;
/*
 *  @brief: 手动跳转到默认格式的结果View
 *  @param: text
 *          结果显示的信息，CSTextView文本
 *  @param: btnTitle
 *          按钮名称
 */
-(void)goToBuyResultView:(NSString *)text btnTitle:(NSString *)btnTitle;
/*
 *  @brief: 手动跳转到提示充值的View
 *  @param: text
 *          提示充值的信息，CSTextView文本
 *  @param: btnTitle
 *          按钮名称
 *  @param: moneyType
 *          如果text==nil，则根据这个类型显示默认的提示充值信息(钻石不足，闪光不足)
 */
-(void)goToNoMoneyView:(NSString *)text btnTitle:(NSString *)btnTitle moneyType:(MoneyType)moneyType;

@end


