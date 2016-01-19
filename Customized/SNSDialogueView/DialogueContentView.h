//
//  DialogueContentView.h
//  beatmasterSNS
//
//  Created by chengsong on 13-10-29.
//
//

#import <UIKit/UIKit.h>
#import "CSTextView.h"
#import "DialogueButton.h"
#import "SNSDialogueCommon.h"

#define DCVDefaultAniDuration   0.5f // // 动画默认的持续时间
#define DCVDefaultFrame SNSRect(10.0f*SNS_SCALE,16.0f*SNS_SCALE,285.0f*SNS_SCALE,170.0f*SNS_SCALE)

#define Key_CheckMoneyContentView   Key_ToCheckMoneyContentView     // // 检查金额是否充足View
#define Key_NotEnoughMoneyView      Key_ToNotEnoughMoneyView        // // 金额不足View
//#define Key_BuyRequestView          Key_ToBuyRequestView
#define Key_WaitNetRequestView      Key_ToWaitNetRequestView        // // 网络等待View
#define Key_PetFoodMoneyView        Key_ToPetFoodMoneyView          // // 宠物食物个数选择View

#pragma mark - 对话内容View基类
//*******************************//
//         对话内容View基类        //
// 描述：用于SNSDialogueView中展示的//
//      对话内容和UI               //
//*******************************//
typedef void (^BtnEventBlock)(id sender);
@interface DialogueContentView : UIView

// // 对话内容View的标识Key，表示当是eventKey的时候显示此对话内容
@property(nonatomic,copy)NSString *eventKey;
// // 动画持续时间 默认是
@property(nonatomic,assign) CGFloat aniDuration;
// // 所有DialogueButton按钮触发事件响应Block
@property(nonatomic,copy)BtnEventBlock  btnEventBlock;
// // 颜色主题
@property(nonatomic,assign)SNSDialogueBgStyle style;
// // 显示动画开关
@property(nonatomic,assign)BOOL enableAppearAni;
// // 消失动画开关
@property(nonatomic,assign)BOOL enableDisappearAni;

- (id)initWithFrame:(CGRect)frame eventKey:(NSString *)key;

/*
 *  @brief: 对话内容View显示
 *
 */
- (void)appearWithAni;
/*
 *  @brief: 对话内容View消失
 *
 */
- (void)disAppearWithAni;

+ (UIColor *)textColorFromBgStyle:(SNSDialogueBgStyle)style;
@end



#pragma mark - 弹出框式的对话内容View
//*********************************//
//       弹出框式的对话内容View       //
// 样式：中间一个文本信息，底部1-3个按钮 //
//*********************************//
@interface DialogueContentPopView : DialogueContentView

// // 显示文本信息的一个富文本内容
@property(nonatomic,retain)CSTextView *contentTextView;
// // 左、中、右三个按钮，推荐设置每个按钮的eventKey属性，
// // 因为eventKey对应的是定位下一个要展示对话内容的Key。
@property(nonatomic,retain)DialogueButton *leftBtn;
@property(nonatomic,retain)DialogueButton *midBtn;
@property(nonatomic,retain)DialogueButton *rightBtn;

- (id)initWithSpecialText:(NSString *)text leftBtnKey:(NSString *)lKey midBtnKey:(NSString *)mKey rightBtnKey:(NSString *)rKey eventKey:(NSString *)key colorStyle:(SNSDialogueBgStyle)style;

@end



#pragma mark - 花钱确认View
typedef void (^NetRequestBlock)(NSDictionary *info);
//*********************//
//     花钱确认View     //
@interface DialogueContentCheckMoneyView : DialogueContentView

@property(nonatomic,assign)NSInteger    moneyNum;
@property(nonatomic,assign)MoneyType    moneyType;
@property(nonatomic,retain)UIImage      *commodityImg;
@property(nonatomic,readonly)CSTextView *contentTextView;
@property(nonatomic,readonly)DialogueButton   *midBtn;
@property(nonatomic,retain)NSDictionary *info;

- (id)initWithMoney:(NSInteger)num moneyType:(MoneyType)type checkMoneyText:(NSString *)checkMoneyText CommodityImg:(UIImage *)comImg colorStyle:(SNSDialogueBgStyle)style netRequestBlock:(NetRequestBlock)requestBlock;
@end

#pragma mark - 钱不够充值View
//********************//
//      钱不够充值     //
@interface DialogueContentNoMoneyView : DialogueContentView

+ (id)DialogueWithText:(NSString *)text btnTitle:(NSString *)title colorStyle:(SNSDialogueBgStyle)style moneyType:(MoneyType)moneyType;
@end

#pragma mark - 等待网络请求View
//*********************//
//      等待网络请求     //
@interface DialogueContentWaitRequestView : DialogueContentView

/**
 *  @brief: 以菊花颜色初始化等待网络请求View
 *  @param: color
 *          菊花颜色
 */
- (id)initWithActivityViewColor:(UIColor *)color;
@end

#pragma mark - 购买物品数量可选择View
//***************************//
//    购买物品数量选择View     //

typedef enum
{
    CalcBtnTagFastReduce = 0, // // "<<"
    CalcBtnTagReduce,         // // "-"
    CalcBtnTagAdd,            // // "+"
    CalcBtnTagFastAdd         // // ">>"
}CalcBtnTag;
@interface DialogueContentGoodsNumSelectView : DialogueContentView

// // 最后花钱总数
@property(nonatomic,assign)int          moneyTotal;
// // 购买的商品价格
@property(nonatomic,assign,readonly)int          price;
// // 价格类型 闪光 钻石
@property(nonatomic,assign,readonly)MoneyType    moneyType;
// // 最后商品购买的数量
@property(nonatomic,assign,readonly)int          goodsTotal;
// // 确定按钮
@property(nonatomic,retain)DialogueButton  *sureBtn;
// // 购买的东西图片
@property(nonatomic,readonly)UIImageView  *goodsImgView;
// // 提示钱多少的View
@property(nonatomic,readonly)CSTextView     *textView;
// // 提示买多少个的View
@property(nonatomic,readonly)CSTextView   *numView;

/**
 *  @brief: 初始化函数
 *  @param: price priceType
 *          物品单价 价格类型
 *  @param: maxNum
 *          最多可买个数
 *  @param: fastOffset
 *          快速增减按钮的跳跃大小
 *  @param: goodsImgName
 *          商品图片名称，当是nil的时候就不显示商品图片
 *  @param: style
 *          背景色类型
 *  @param: eventKey
 *          本对话框所代表的event的DialogueContentView
 */
-(id)initWithGoodsPrice:(int)price
              priceType:(MoneyType)priceType
                 maxNum:(int)maxNum
     fastAddOrReduceNum:(int)fastOffset
           goodsImgName:(NSString *)goodsImgName
             colorStyle:(SNSDialogueBgStyle)style
               eventKey:(NSString *)eventKey;

/**
 *  @brief: 计算钱的展示文字条,如果不用默认的显示方式，可以重写，只对self.textView做更改
 */
-(void)textViewSetText;
/**
 *  @brief: 购买的商品的个数,如果不用默认的显示方式，可以重写，只对self.numView做更改
 */
-(void)numViewSetText;

/**
 *  @brief: 根据给定数量重新设置食物金额显示
 */
- (void)resetgoodsMoneyView:(int)goodsNum;
@end

