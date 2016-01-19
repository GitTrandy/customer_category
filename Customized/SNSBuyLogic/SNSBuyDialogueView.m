//
//  SNSBuyDialogueView.m
//  beatmasterSNS
//
//  Created by chengsong on 13-11-4.
//
//

#import "SNSBuyDialogueView.h"

@interface SNSBuyDialogueView ()

// // 钱的数目
@property(nonatomic,assign)int moneyNum;
// // 钱的类型
@property(nonatomic,assign)MoneyType moneyType;
// // 商品图片
@property(nonatomic,retain)UIImage *comImg;
// // 主题颜色
//@property(nonatomic,assign)SNSDialogueBgStyle bgStyle;
// // 第一个处理金额的View
@property(nonatomic,retain)DialogueContentView *firstShowView;
// // 花钱确认View
@property(nonatomic,retain)DialogueContentCheckMoneyView *checkMoneyView;
// // 钱不足提示View
@property(nonatomic,retain)DialogueContentNoMoneyView *noMoneyView;
// // 购买网络等待View
@property(nonatomic,retain)DialogueContentWaitRequestView *waitView;
// // 购买请求Block
@property(nonatomic,copy)NetRequestBlock requestBlock;
@end

@implementation SNSBuyDialogueView

- (id)initWithBgStyle:(SNSDialogueBgStyle)bgStyle beginView:(DialogueContentView *)beginView netRequest:(NetRequestBlock)requestBlock closeBtnBlock:(DialogueCloseBtnBlock)closeBlock
{
    self = [super initWithBgStyle:bgStyle firstKey:nil DialogueContentSourceWithKey:nil dialogueBtnClickBlock:nil];
    if (self) {
        // // init codes
        
        [self buyDialogueVariablesInit];
        if (beginView)
        {
            self.firstShowView = beginView;
        }
        //self.bgStyle = bgStyle;
        self.requestBlock = requestBlock;
        self.dialogueCloseBtnBlock = closeBlock;
        [self createDefaultContentViews];
        [self goToFirstView];
        
    }
    
    return self;
}

- (id)initWithBgStyle:(SNSDialogueBgStyle)bgStyle moneyNum:(int)moneyNum moneyType:(MoneyType)moneyType checkMoneyText:(NSString *)checkMoneyText commodityImg:(UIImage *)comImg netRequest:(NetRequestBlock)requestBlock closeBtnBlock:(DialogueCloseBtnBlock)closeBlock
{
    self = [super initWithBgStyle:bgStyle firstKey:nil DialogueContentSourceWithKey:nil dialogueBtnClickBlock:nil];
    if (self) {
        // // init codes
        
        [self buyDialogueVariablesInit];
        //self.bgStyle = bgStyle;
        self.moneyNum = moneyNum;
        self.moneyType = moneyType;
        self.checkMoneyText = checkMoneyText;
        self.comImg = comImg;
        self.requestBlock = requestBlock;
        self.dialogueCloseBtnBlock = closeBlock;
        [self createDefaultContentViews];
        [self goToFirstView];
    }
    
    return self;
}

-(void)dealloc
{
    self.checkMoneyText = nil;
    self.comImg = nil;
    self.firstShowView = nil;
    self.checkMoneyView = nil;
    self.noMoneyView = nil;
    self.waitView = nil;
    self.requestBlock = nil;
    [super dealloc];
    CSLog(@"%s",__FUNCTION__);
}

#pragma mark - private methods
/*
 *  @brief: 初始化数据
 */
-(void)buyDialogueVariablesInit
{
    self.moneyNum = 9999999;
    self.moneyType = MoneyTypeDiamond;
    self.comImg = nil;
    //self.bgStyle = SNSDialogueBgStyleDefault;
    self.needWaitNetRequest = YES;
    self.firstShowView = nil;
    self.checkMoneyView = nil;
    self.noMoneyView = nil;
    self.waitView = nil;
    self.requestBlock = nil;
    __block typeof(self) weakSelf = self;
    self.dialogueBtnClickBlock = ^(id btn, NSString *eventKey)
    {
        if ([Key_ToChargeMoney isEqualToString:eventKey])
        {
            [weakSelf removeFromSuperview];
        }
    };
}
/*
 *  @brief: 嵌入默认的几个ContentView:花钱确认View、钱不足提示View、购买网络等待View
 */
-(void)createDefaultContentViews
{
    // //花钱确认View
    //self.checkMoneyView = [[[DialogueContentCheckMoneyView alloc]initWithMoney:_moneyNum moneyType:_moneyType CommodityImg:_comImg colorStyle:_bgStyle]autorelease];
    
    // //钱不足提示View
    //NSString *askStr = _moneyType == MoneyTypeDiamond ? @"钻石不足" : @"闪光不足";
    //self.noMoneyView = [DialogueContentNoMoneyView DialogueWithText:askStr btnTitle:@"补充" colorStyle:self.dialogueBgStyle];
    
    // //购买网络等待View
    UIColor *activityColor = [DialogueContentView textColorFromBgStyle:self.dialogueBgStyle];
    self.waitView = [[[DialogueContentWaitRequestView alloc]initWithActivityViewColor:activityColor]autorelease];
    
    //[self.dialogueContentViewPool setObject:self.noMoneyView forKey:self.noMoneyView.eventKey];
    [self.dialogueContentViewPool setObject:self.waitView forKey:self.waitView.eventKey];
}
/*
 *  @brief: 显示第一个对话View
 *          如果用户提供了第一个View就用用户提供的，没有的话就直接跳到CheckMoneyView
 */
-(void)goToFirstView
{
    if (self.firstShowView)
    {
        [self goNextDialogueContentViewWithContentView:self.firstShowView];
        if (self.firstShowView.eventKey != nil)
        {
            [self.dialogueContentViewPool setObject:self.firstShowView forKey:self.firstShowView.eventKey];
        }
    }
    else
    {
        // //花钱确认View
        [self goToCheckMoneyView:_moneyNum moneyType:_moneyType checkMoneyText:self.checkMoneyText commodityImg:_comImg textAlign:CSTextAlignmentCenter];
    }
}

#pragma mark - public methods
/*
 *  @brief: 花钱确认View跳转
 */
-(void)goToCheckMoneyView:(int)moneyNum moneyType:(MoneyType)type checkMoneyText:(NSString *)checkMoneyText commodityImg:(UIImage *)img textAlign:(CSTextAlignment)align
{
    self.moneyNum = moneyNum;
    self.moneyType = type;
    self.comImg = img;
    self.checkMoneyView = [[[DialogueContentCheckMoneyView alloc]initWithMoney:moneyNum moneyType:type checkMoneyText:checkMoneyText CommodityImg:img colorStyle:self.dialogueBgStyle netRequestBlock:self.requestBlock]autorelease];
    self.checkMoneyView.contentTextView.textAlignment = align;
    [self.dialogueContentViewPool setObject:self.checkMoneyView forKey:self.checkMoneyView.eventKey];
    
    // //钱不足提示View
    NSString *askStr = _moneyType == MoneyTypeDiamond ? @"钻石不足" : @"闪光不足";
    self.noMoneyView = [DialogueContentNoMoneyView DialogueWithText:askStr btnTitle:@"补充" colorStyle:self.dialogueBgStyle moneyType:_moneyType];
    [self.dialogueContentViewPool setObject:self.noMoneyView forKey:self.noMoneyView.eventKey];
    
    [self goNextDialogueContentViewWithContentView:self.checkMoneyView];
}

/*
 *  @brief: 跳转到默认都购买之后的结果view
 */
-(void)goToBuyResultView:(NSString *)text btnTitle:(NSString *)btnTitle
{
    DialogueContentPopView *resultView = [[[DialogueContentPopView alloc]initWithSpecialText:text leftBtnKey:nil midBtnKey:Key_ToCloseView rightBtnKey:nil eventKey:nil colorStyle:self.dialogueBgStyle]autorelease];
    [resultView.midBtn setTitle:btnTitle forState:UIControlStateNormal];
    [self goNextDialogueContentViewWithContentView:resultView];
}

-(void)goToNoMoneyView:(NSString *)text btnTitle:(NSString *)btnTitle moneyType:(MoneyType)moneyType
{
    // //钱不足提示View
    NSString *askStr = nil;
    self.moneyType = moneyType;
    if (text == nil)
    {
        askStr = (_moneyType == MoneyTypeDiamond ? @"钻石不足" : @"闪光不足");
    }
    else
    {
        askStr = text;
    }
    
    self.noMoneyView = [DialogueContentNoMoneyView DialogueWithText:askStr btnTitle:btnTitle colorStyle:self.dialogueBgStyle moneyType:_moneyType];
    [self.dialogueContentViewPool setObject:self.noMoneyView forKey:self.noMoneyView.eventKey];
    [self goNextDialogueContentViewWithContentView:self.noMoneyView];
}

@end


