//
//  DialogueContentView.m
//  beatmasterSNS
//
//  Created by chengsong on 13-10-29.
//
//

#import "DialogueContentView.h"
#import "ShoppingMall_ChargeVC.h"
#import "ShoppingMallVC.h"

#pragma mark - 对话内容View基类
#pragma mark
@interface DialogueContentView()

@property(nonatomic,assign)BOOL isAppear;
@end
@implementation DialogueContentView

- (id)initWithFrame:(CGRect)frame eventKey:(NSString *)key
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self dialogueVariablesInit];
        self.eventKey = key;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc
{
    self.eventKey = nil;
    self.btnEventBlock = nil;
    [super dealloc];
    CSLog(@"%s",__FUNCTION__);
}

- (void)dialogueVariablesInit
{
    self.eventKey = nil;
    self.aniDuration = -1;
    self.btnEventBlock = nil;
    self.style = SNSDialogueBgStyleDefault;
    self.isAppear = YES;
    self.enableAppearAni = YES;
    self.enableDisappearAni = YES;
}

- (void)appearWithAni
{
    if (_enableAppearAni)
    {
        [self animationFadeTo:1.0f];
    }
    else
    {
        self.alpha = 1.0f;
    }
    self.isAppear = YES;
}
- (void)disAppearWithAni
{
    if (_enableDisappearAni)
    {
        [self animationFadeTo:0.0f];
    }
    else
    {
        self.alpha = 0.0f;
    }
    self.isAppear = NO;
}

/*
 *  @brief: 淡入淡出动画，fade是将要到达的alpha的值
 */
- (void)animationFadeTo:(CGFloat)fade
{
    if (self.aniDuration < 0)
    {
        self.aniDuration = DCVDefaultAniDuration;
    }
    
    //__block DialogueContentView *weakSelf = self;
    [UIView animateWithDuration:self.aniDuration animations:^{
        [self setAlpha:fade];
    } completion:^(BOOL finished) {
        [self animationDidEnd];
    }];
    
}

- (void)animationDidEnd
{
    if (!self.isAppear)
    {
        [self removeFromSuperview];
    }
}

+ (UIColor *)textColorFromBgStyle:(SNSDialogueBgStyle)style
{
    UIColor *textColor = [UIColor whiteColor];
    switch (style)
    {
        case SNSDialogueBgStyleBlue:
            textColor = SNSColorMake(145.0f, 206.0f, 213.0f, 1.0f);
            break;
        case SNSDialogueBgStylePurple:
            textColor = SNSColorMake(171.0f, 146.0f, 211.0f, 1.0f);
            break;
        case SNSDialogueBgStyleYellow:
            textColor = SNSColorMake(211.0f, 198.0f, 146.0f, 1.0f);
            break;
        case SNSDialogueBgStyleRed:
            textColor = SNSColorMake(208.0f, 149.0f, 160.0f, 1.0f);
            break;
        case SNSDialogueBgStyleGreen:
            textColor = SNSColorMake(141.0f, 216.0f, 186.0f, 1.0f);
            break;
        case SNSDialogueBgStyleGray:
            textColor = SNSColorMake(204.0f, 204.0f, 204.0f, 1.0f);
            break;
        default:
            textColor = SNSColorMake(0, 0, 0, 1.0f);
            break;
    }
    
    return textColor;
}

@end

#pragma mark - 弹出框式的对话内容View
#pragma mark
@interface DialogueContentPopView()

@property(nonatomic,copy)NSString *text;
@property(nonatomic,copy)NSString *lKey;
@property(nonatomic,copy)NSString *mKey;
@property(nonatomic,copy)NSString *rKey;
@end
@implementation DialogueContentPopView

- (id)initWithSpecialText:(NSString *)text leftBtnKey:(NSString *)lKey midBtnKey:(NSString *)mKey rightBtnKey:(NSString *)rKey eventKey:(NSString *)key colorStyle:(SNSDialogueBgStyle)style
{
    self = [super initWithFrame:DCVDefaultFrame eventKey:key];
    if (self) {
        // // init codes
        self.text = text;
        self.lKey = lKey;
        self.mKey = mKey;
        self.rKey = rKey;
        self.style = style;
        [self createDialogueContentPopView];
    }
    
    return self;
}

-(void)dealloc
{
    self.contentTextView = nil;
    self.leftBtn = nil;
    self.midBtn = nil;
    self.rightBtn = nil;
    self.text = nil;
    self.lKey = nil;
    self.mKey = nil;
    self.rKey = nil;
    [super dealloc];
    CSLog(@"%s",__FUNCTION__);
}

#pragma mark- private methods
-(void)createDialogueContentPopView
{
    [self createContentTextView];
    [self createButtons];
}

/*
 *  @brief: 创建中间的文本View
 */
-(void)createContentTextView
{
    if (_contentTextView == nil)
    {
        self.contentTextView = [[[CSTextView alloc]initWithFrame:CGRectMake(50.0f*SNS_SCALE, 40.0f*SNS_SCALE, self.frame.size.width - 100.0f*SNS_SCALE, 60.0f*SNS_SCALE)]autorelease];
    }
    _contentTextView.originalString = self.text;
    _contentTextView.normalFont = [UIFont boldSystemFontOfSize:14.0f*SNS_SCALE];
    
    UIColor *textColor = [DialogueContentView textColorFromBgStyle:self.style];
    _contentTextView.normalColor = textColor;
    _contentTextView.backgroundColor = [UIColor clearColor];
    
    if ([_contentTextView doGetLinesAttrCompomentsArr].count == 1)
    {
        _contentTextView.textAlignment = CSTextAlignmentCenter;
    }
    [self addSubview:_contentTextView];
}

/*
 *  @brief: 创建左中右三个按钮，并且当对应的Key==nil的时候隐藏
 */
-(void)createButtons
{
    if (_leftBtn == nil && self.lKey != nil)
    {
        self.leftBtn = [DialogueButton DialogueButtonWithPosition:CGPointMake(35.0f*SNS_SCALE, 128.0f*SNS_SCALE) normalImg:[NSString stringWithFormat:@"Com_PMV_sBtn%02d_1.png",self.style] highlight:[NSString stringWithFormat:@"Com_PMV_sBtn%02d_2.png",self.style] eventKey:self.lKey target:self];
        [self addSubview:_leftBtn];
    }
    if (_midBtn == nil && self.mKey != nil)
    {
        self.midBtn = [DialogueButton DialogueButtonWithPosition:CGPointMake(94.0f*SNS_SCALE, 128.0f*SNS_SCALE) normalImg:[NSString stringWithFormat:@"Com_PMV_hBtn%02d_1.png",self.style] highlight:[NSString stringWithFormat:@"Com_PMV_hBtn%02d_2.png",self.style] eventKey:self.mKey target:self];
        [self addSubview:_midBtn];
    }
    if (_rightBtn == nil && self.rKey != nil)
    {
        self.rightBtn = [DialogueButton DialogueButtonWithPosition:CGPointMake(157.0f*SNS_SCALE, 128.0f*SNS_SCALE) normalImg:[NSString stringWithFormat:@"Com_PMV_hBtn%02d_1.png",self.style] highlight:[NSString stringWithFormat:@"Com_PMV_hBtn%02d_2.png",self.style] eventKey:self.rKey target:self];
        [self addSubview:_rightBtn];
    }
    
}

@end


#pragma mark - 花钱确认View
@interface DialogueContentCheckMoneyView()
@property(nonatomic,retain)CSTextView   *contentTextView;
@property(nonatomic,retain)DialogueButton   *midBtn;
@property(nonatomic,retain)UIImageView      *commdityImgView;
@property(nonatomic,copy)NetRequestBlock    requestBlock;
@property(nonatomic,copy)NSString           *checkMoneyText;
@end
@implementation DialogueContentCheckMoneyView

- (id)initWithMoney:(NSInteger)num moneyType:(MoneyType)type checkMoneyText:(NSString *)checkMoneyText CommodityImg:(UIImage *)comImg colorStyle:(SNSDialogueBgStyle)style netRequestBlock:(NetRequestBlock)requestBlock
{
    self = [super initWithFrame:DCVDefaultFrame eventKey:nil];
    if (self) {
        // // init codes
        self.moneyNum = num;
        self.moneyType = type;
        self.commodityImg = comImg;
        self.style = style;
        self.eventKey = Key_CheckMoneyContentView;
        self.requestBlock = requestBlock;
        self.checkMoneyText = checkMoneyText;
        [self createDialogueContentCheckMoneyView];
    }
    
    return self;
}

-(void)dealloc
{
    self.commodityImg = nil;
    self.contentTextView = nil;
    self.midBtn = nil;
    self.requestBlock = nil;
    self.commdityImgView = nil;
    self.info = nil;
    self.checkMoneyText = nil;
    
    [super dealloc];
    CSLog(@"%s",__FUNCTION__);
}

#pragma mark- private methods
-(void)createDialogueContentCheckMoneyView
{
    [self createContentTextView];
    [self createButtons];
    [self createCommodityView];
}

/*
 *  @brief: 创建中间的文本View
 */
-(void)createContentTextView
{
    if (_contentTextView == nil)
    {
        self.contentTextView = [[[CSTextView alloc]initWithFrame:CGRectMake(50.0f*SNS_SCALE, 40.0f*SNS_SCALE, self.frame.size.width - 100.0f*SNS_SCALE, 60.0f*SNS_SCALE)]autorelease];
    }
    
    if (self.checkMoneyText != nil)
    {
        _contentTextView.originalString = self.checkMoneyText;
    }
    else
    {
        NSString *moneyImgStr = (self.moneyType == MoneyTypeCoin ? @"Com_Light.png" : @"Com_Diamond.png");
        NSString *showStr = [NSString stringWithFormat:@"是否真的花费%d{<type=img,margin=4.0>%@}购买",self.moneyNum,moneyImgStr];
        _contentTextView.originalString = showStr;
    }
    
    _contentTextView.normalFont = [UIFont boldSystemFontOfSize:14.0f*SNS_SCALE];
    _contentTextView.textAlignment = CSTextAlignmentCenter;
    UIColor *textColor = [DialogueContentView textColorFromBgStyle:self.style];
    _contentTextView.normalColor = textColor;
    _contentTextView.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentTextView];
}

/*
 *  @brief: 中间确定按钮
 */
-(void)createButtons
{
    
    if (_midBtn == nil)
    {
        self.midBtn = [DialogueButton DialogueButtonWithPosition:CGPointMake(94.0f*SNS_SCALE, 128.0f*SNS_SCALE) normalImg:[NSString stringWithFormat:@"Com_PMV_hBtn%02d_1.png",self.style] highlight:[NSString stringWithFormat:@"Com_PMV_hBtn%02d_2.png",self.style] eventKey:nil target:self action:@selector(midBtnClicked:)];
        [_midBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self addSubview:_midBtn];
    }
    
    
}

/*
 *  @brief: 中间商品图片View
 */
-(void)createCommodityView
{
    CGSize imgSize = self.commodityImg.size;
    self.commdityImgView = [[[UIImageView alloc]initWithFrame:SNSRect(0, 0, imgSize.width*SNS_SCALE, imgSize.height*SNS_SCALE)]autorelease];
    self.commdityImgView.center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    if (self.commodityImg)
    {
        self.commdityImgView.image = self.commodityImg;
    }
    [self addSubview:self.commdityImgView];
}

/*
 *  @brief: 中间按钮事件
 */
-(void)midBtnClicked:(id)sender
{
    int haveMoneyNum = 0;
    switch (self.moneyType)
    {
        case MoneyTypeCoin:
            // // 闪光
            haveMoneyNum = [DataManager shareDataManager].self_UserInfo.goldCoin;
            break;
        case MoneyTypeDiamond:
            // // 钻石
            haveMoneyNum = [DataManager shareDataManager].self_UserInfo.diamond;
            break;
            
        default:
            break;
    }
    
    NSString *eventKey = Key_ToNotEnoughMoneyView;
    if (haveMoneyNum >= self.moneyNum)
    {
        eventKey = Key_ToWaitNetRequestView;
        self.requestBlock(self.info);
    }
    
    self.midBtn.eventKey = eventKey;
    self.btnEventBlock(self.midBtn);
    
}

@end

#pragma mark - 钱不够充值View

@implementation DialogueContentNoMoneyView

+ (id)DialogueWithText:(NSString *)text btnTitle:(NSString *)title colorStyle:(SNSDialogueBgStyle)style moneyType:(MoneyType)moneyType
{
    DialogueContentPopView *popView = [[DialogueContentPopView alloc]initWithSpecialText:text leftBtnKey:nil midBtnKey:Key_ToChargeMoney rightBtnKey:nil eventKey:Key_NotEnoughMoneyView colorStyle:style];
    [popView.midBtn setTitle:title forState:UIControlStateNormal];
    popView.btnEventBlock = ^(id sender){
        // // 进入充值view
        UINavigationController * nav = (UINavigationController *)[[[UIApplication sharedApplication] delegate]window].rootViewController;
        UIViewController *topController = [nav topViewController];
        
        ChargeStyle chargeStyle = moneyType == MoneyTypeCoin ? ChargeStyleCoin : ChargeStyleDiamond;
        
        if ([topController isKindOfClass:[ShoppingMall_ChargeVC class]])
        {
            // // 如果当前就在充值VC，就直接切换充值栏
            [((ShoppingMall_ChargeVC *)topController) exchangeViewWithChargeStyle:chargeStyle];
        }
        else if ([topController isKindOfClass:[ShoppingMallVC class]] && [[(ShoppingMallVC *)topController curSelectVC] isKindOfClass:[ShoppingMall_ChargeVC class]])
        {
            // // 如果当前就在商城的充值VC，就直接切换充值栏
            [((ShoppingMall_ChargeVC *)[(ShoppingMallVC *)topController curSelectVC]) exchangeViewWithChargeStyle:chargeStyle];
            
        }
        else
        {
            // // 如果当前不是充值VC，跳转到充值VC，并切换到相应的栏
            ShoppingMall_ChargeVC *mallVC = [[[ShoppingMall_ChargeVC alloc] init_ChargeVCWithChargeStyle:chargeStyle] autorelease];
            [nav pushViewControllerAnimatedWithFIFO:mallVC];
        }
    };
    
    return [popView autorelease];
}

@end

#pragma mark - 等待网络请求View

@interface DialogueContentWaitRequestView ()

@property(nonatomic,retain)UIActivityIndicatorView  *activityView;
@property(nonatomic,retain)UIColor  *color;

@end
@implementation DialogueContentWaitRequestView

- (id)initWithActivityViewColor:(UIColor *)color
{
    self = [super initWithFrame:DCVDefaultFrame eventKey:Key_WaitNetRequestView];
    if (self) {
        // // init codes
        
        self.color = color == nil ? [UIColor whiteColor] : color;
        [self createActivityViewWithColor:self.color];
        
        self.enableAppearAni = NO;
        self.enableDisappearAni = NO;
        
    }
    return self;
}

-(void)dealloc
{
    self.activityView = nil;
    self.color = nil;
    [super dealloc];
    CSLog(@"%s",__FUNCTION__);
}

#pragma mark - private methods
/*
 *  @brief: 转圈动画
 */
-(void)createActivityViewWithColor:(UIColor *)color
{
    if (self.activityView == nil)
    {
        self.activityView = [[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]autorelease];
        self.activityView.color = color;
        self.activityView.center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f-15.0f*SNS_SCALE);
        [self addSubview:self.activityView];
    }
}

#pragma mark - override super methods
-(void)appearWithAni
{
    [super appearWithAni];
    if (self.activityView)
    {
        [self.activityView startAnimating];
    }
}
-(void)disAppearWithAni
{
    [super disAppearWithAni];
    if (self.activityView)
    {
        [self.activityView stopAnimating];
    }
}

@end

#pragma mark - 购买物品数量可选择View

@interface DialogueContentGoodsNumSelectView ()
{
    BOOL longPress;
    NSTimeInterval _moneyChangeDuration;
    CalcBtnTag currentMoneyChangeType;
}

// // 钱包
@property(nonatomic,retain)UILabel      *coinLabel;
@property(nonatomic,retain)UILabel      *diamondLabel;

// // 购买的东西图片
@property(nonatomic,retain)UIImageView  *goodsImgView;
// // 提示钱多少的View
@property(nonatomic,retain)CSTextView   *textView;
// // 提示买多少个的View
@property(nonatomic,retain)CSTextView   *numView;
// // 依次代表 "<<"  "-"  "+"  ">>"
@property(nonatomic,retain)UIButton     *btn_fastReduce;
@property(nonatomic,retain)UIButton     *btn_reduce;
@property(nonatomic,retain)UIButton     *btn_add;
@property(nonatomic,retain)UIButton     *btn_fastAdd;

// // 购买的商品图片名称
@property(nonatomic,copy)NSString     *goodsImgName;
// // 购买的商品价格
@property(nonatomic,assign)int          price;
// // 做多可以购买的商品数量
@property(nonatomic,assign)int          maxNum;
//// // 最后花钱总数
//@property(nonatomic,assign)int          moneyTotal;
// // 价格类型 闪光 钻石
@property(nonatomic,assign)MoneyType    moneyType;
// // 最后商品购买的数量
@property(nonatomic,assign)int          goodsTotal;
// // 快速加减的数目
@property(nonatomic,assign)int      fastAddOrReduceNum;

@end

@implementation DialogueContentGoodsNumSelectView

-(id)initWithGoodsPrice:(int)price priceType:(MoneyType)priceType maxNum:(int)maxNum fastAddOrReduceNum:(int)fastOffset goodsImgName:(NSString *)goodsImgName colorStyle:(SNSDialogueBgStyle)style eventKey:(NSString *)eventKey
{
    self = [super initWithFrame:DCVDefaultFrame eventKey:eventKey];
    if (self)
    {
        [self goodsNumSelectViewVariablesInit];
        self.price = price;
        self.moneyType = priceType;
        self.maxNum = maxNum;
        self.fastAddOrReduceNum = fastOffset;
        self.goodsImgName = goodsImgName;
        self.style = style;
        self.eventKey = eventKey;
        
        [self createGoodsNumSelectView];
        [self refreshButtonStatus];
    }
    
    return self;
}

-(void)dealloc
{
    self.coinLabel = nil;
    self.diamondLabel = nil;
    self.goodsImgView = nil;
    self.textView = nil;
    self.numView = nil;
    self.btn_add = nil;
    self.btn_fastAdd = nil;
    self.btn_fastReduce = nil;
    self.btn_reduce = nil;
    self.sureBtn = nil;
    self.goodsImgName = nil;
    [super dealloc];
}

#pragma mark - private methods
-(void)goodsNumSelectViewVariablesInit
{
    self.goodsTotal = 1;
    self.moneyTotal = 0;
    _moneyChangeDuration = 0.1f;
}
-(void)createGoodsNumSelectView
{
    // // 钱包
    UIImageView *coinSign = [[[UIImageView alloc]initWithFrame:SNSRect(56.0f*SNS_SCALE, 10.0f*SNS_SCALE, 21.0f*SNS_SCALE, 18.0f*SNS_SCALE)]autorelease];
    coinSign.image = [UIImage imageNamed_New:@"Com_Light.png"];
    [self addSubview:coinSign];
    
    self.coinLabel = [[[UILabel alloc]initWithFrame:SNSRect(76*SNS_SCALE, 9.0f*SNS_SCALE, 80.0f*SNS_SCALE, 20.0f*SNS_SCALE)]autorelease];
    _coinLabel.textAlignment = NSTextAlignmentLeft;
    _coinLabel.textColor = [UIColor whiteColor];
    _coinLabel.font = [UIFont boldSystemFontOfSize:15.0f*SNS_SCALE];
    _coinLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_coinLabel];
    
    UIImageView *diamondSign = [[[UIImageView alloc]initWithFrame:SNSRect(166.0f*SNS_SCALE, 10.0f*SNS_SCALE, 21.0f*SNS_SCALE, 18.0f*SNS_SCALE)]autorelease];
    diamondSign.image = [UIImage imageNamed_New:@"Com_Diamond.png"];
    [self addSubview:diamondSign];
    
    self.diamondLabel = [[[UILabel alloc]initWithFrame:SNSRect(187.0f*SNS_SCALE, 9.0f*SNS_SCALE, 80.0f*SNS_SCALE, 20.0f*SNS_SCALE)]autorelease];
    _diamondLabel.textAlignment = NSTextAlignmentLeft;
    _diamondLabel.textColor = [UIColor whiteColor];
    _diamondLabel.font = [UIFont boldSystemFontOfSize:15.0f*SNS_SCALE];
    _diamondLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_diamondLabel];
    [self moneyLabelsUpdate];
    
    // // 线  line
    UIImage *lineImg = [UIImage imageNamed_New:[NSString stringWithFormat:@"GSVR_Line_%02d.png",self.style]];
    UIImageView *lineView = [[[UIImageView alloc]initWithImage:lineImg]autorelease];
    lineView.frame = SNSRect(0, 0, lineImg.size.width*SNS_SCALE, lineImg.size.height*SNS_SCALE);
    lineView.center = CGPointMake(self.frame.size.width/2.0f, 32.0f*SNS_SCALE);
    [self addSubview:lineView];
    
    // // 购买的物品展示
    UIImage *goodsImg = [UIImage imageNamed_New:self.goodsImgName];
    if (goodsImg)
    {
        self.goodsImgView = [[UIImageView alloc]initWithImage:goodsImg];
        self.goodsImgView.frame = SNSRect(0, 0, goodsImg.size.width*SNS_SCALE, goodsImg.size.height*SNS_SCALE);
        self.goodsImgView.center = CGPointMake(75.0f*SNS_SCALE, 54.0f*SNS_SCALE);
        [self addSubview:self.goodsImgView];
    }
    
    // // 钱总数显示View
    self.textView = [[CSTextView alloc]initWithFrame:SNSRect(0, 0, 200.0f*SNS_SCALE, 18.0f*SNS_SCALE)];
    self.textView.normalColor = [DialogueContentView textColorFromBgStyle:self.style];
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.normalFont = [UIFont boldSystemFontOfSize:14*SNS_SCALE];
    self.textView.textAlignment =CSTextAlignmentLeft;
    [self textViewSetText];
    CGPoint textViewCenter = CGPointZero;
    if (self.goodsImgView)
    {
        textViewCenter = CGPointMake(self.goodsImgView.center.x + self.goodsImgView.frame.size.width/2.0f + self.textView.frame.size.width/2.0f+8.0f*SNS_SCALE, 54.0f*SNS_SCALE);
    }
    else
    {
        textViewCenter = CGPointMake(110.0f*SNS_SCALE + self.textView.frame.size.width/2.0f, 53.0f*SNS_SCALE);
    }
    self.textView.center = textViewCenter;
    [self addSubview:_textView];
    
    // // 商品个数View
    self.numView = [[CSTextView alloc]initWithFrame:SNSRect(0, 0, self.bounds.size.width, 30.0f*SNS_SCALE)];
    self.numView.normalColor = [DialogueContentView textColorFromBgStyle:self.style];
    self.numView.backgroundColor = [UIColor clearColor];
    self.numView.normalFont = [UIFont boldSystemFontOfSize:14*SNS_SCALE];
    self.numView.textAlignment =CSTextAlignmentCenter;
    [self numViewSetText];
    self.numView.center = CGPointMake(self.bounds.size.width/2.0f, 100.0f*SNS_SCALE);
    [self addSubview:_numView];
    
    // //  "<<" "-" "+" ">>"
    self.btn_fastReduce = [UIButton buttonWithType:UIButtonTypeCustom];
    [self doSetBtnWithCenterPos:CGPointMake(50.0f*SNS_SCALE, 93.5f*SNS_SCALE) norImgName:[NSString stringWithFormat:@"GSVR_ReduceMoreBtn%02d_01.png",self.style] highLightName:[NSString stringWithFormat:@"GSVR_ReduceMoreBtn%02d_02.png",self.style] targetBtn:self.btn_fastReduce tag:CalcBtnTagFastReduce];
    
    [self addSubview:self.btn_fastReduce];
    [_btn_fastReduce addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressSubMore:)]];
    
    self.btn_reduce = [UIButton buttonWithType:UIButtonTypeCustom];
    [self doSetBtnWithCenterPos:CGPointMake(100.0f*SNS_SCALE, 93.5f*SNS_SCALE) norImgName:[NSString stringWithFormat:@"GSVR_ReduceBtn%02d_01.png",self.style] highLightName:[NSString stringWithFormat:@"GSVR_ReduceBtn%02d_02.png",self.style] targetBtn:self.btn_reduce tag:CalcBtnTagReduce];
    
    [self addSubview:self.btn_reduce];
    [_btn_reduce addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressSubOne:)]];
    
    self.btn_add = [UIButton buttonWithType:UIButtonTypeCustom];
    [self doSetBtnWithCenterPos:CGPointMake(185.0f*SNS_SCALE, 93.5f*SNS_SCALE) norImgName:[NSString stringWithFormat:@"GSVR_AddBtn%02d_01.png",self.style] highLightName:[NSString stringWithFormat:@"GSVR_AddBtn%02d_02.png",self.style] targetBtn:self.btn_add tag:CalcBtnTagAdd];
    
    [self addSubview:self.btn_add];
    [_btn_add addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAddOne:)]];
    
    self.btn_fastAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    [self doSetBtnWithCenterPos:CGPointMake(235.0f*SNS_SCALE, 93.5f*SNS_SCALE) norImgName:[NSString stringWithFormat:@"GSVR_AddMoreBtn%02d_01.png",self.style] highLightName:[NSString stringWithFormat:@"GSVR_AddMoreBtn%02d_02.png",self.style] targetBtn:self.btn_fastAdd tag:CalcBtnTagFastAdd];
    
    [self addSubview:self.btn_fastAdd];
    [_btn_fastAdd addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAddMore:)]];
    
    // // 确定按钮
    self.sureBtn = [DialogueButton DialogueButtonWithPosition:CGPointMake(94.0f*SNS_SCALE, 128.0f*SNS_SCALE) normalImg:[NSString stringWithFormat:@"Com_PMV_hBtn%02d_1.png",self.style] highlight:[NSString stringWithFormat:@"Com_PMV_hBtn%02d_2.png",self.style] eventKey:nil target:self];
    [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self addSubview:self.sureBtn];
    
}

/**
 *  @brief: 设置钱包的数字
 */
-(void)moneyLabelsUpdate
{
    UserInfoOC *infoSelf = [DataManager shareDataManager].self_UserInfo;
    if (_coinLabel)
    {
        _coinLabel.text = [NSString stringWithFormat:@"%d",infoSelf.goldCoin];
    }
    if (_diamondLabel)
    {
        _diamondLabel.text = [NSString stringWithFormat:@"%d",infoSelf.diamond];
    }
}

/*
 *  @brief: 计算钱的展示文字条
 */
-(void)textViewSetText
{
    if (self.textView == nil)
    {
        return;
    }
    
    self.moneyTotal = self.price * self.goodsTotal;
    
    NSString *moneyImgName = self.moneyType == MoneyTypeCoin ? @"Com_Light.png" : @"Com_Diamond.png";
    NSString *textViewStr = @"";
    CGRect textViewRect = self.textView.bounds;
    
    textViewStr = [NSString stringWithFormat:@"花费 %d{<type=img,margin=4>%@}",self.moneyTotal,moneyImgName];
    textViewRect.size.height = 18*SNS_SCALE;
    
    self.textView.bounds = textViewRect;
    self.textView.originalString = textViewStr;
}
/*
 *  @brief: 购买的商品的个数
 */
-(void)numViewSetText
{
    if (self.numView == nil)
    {
        return;
    }
    NSString *numViewStr = [NSString stringWithFormat:@"%d个",self.goodsTotal];
    self.numView.originalString = numViewStr;
}

/*
 *  @brief: 设置那几个算钱按钮的属性
 */
-(void)doSetBtnWithCenterPos:(CGPoint)point norImgName:(NSString *)norName highLightName:(NSString *)highLightName targetBtn:(UIButton *)btn tag:(CalcBtnTag)tag
{
    if (btn == nil)
    {
        return;
    }
    UIImage *norImg = [UIImage imageNamed_New:norName];
    UIImage *highImg = [UIImage imageNamed_New:highLightName];
    if (norImg)
    {
        [btn setBackgroundImage:norImg forState:UIControlStateNormal];
    }
    if (highImg)
    {
        [btn setBackgroundImage:highImg forState:UIControlStateHighlighted];
        [btn setBackgroundImage:highImg forState:UIControlStateSelected];
    }
    btn.frame = SNSRect(0, 0, norImg.size.width*SNS_SCALE, norImg.size.height*SNS_SCALE);
    btn.center = point;
    btn.tag = tag;
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        longPress = YES;
        [self beginChangeMoney];
    }
    
    else if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        longPress = NO;
    }
}

- (void)beginChangeMoney
{
    [self refreshMoneyView];
    if (longPress)
    {
        [self performSelector:@selector(beginChangeMoney) withObject:nil afterDelay:_moneyChangeDuration];
        _moneyChangeDuration -= _moneyChangeDuration * _moneyChangeDuration * 0.1;
    }
    else
    {
        _moneyChangeDuration = 0.1f;
    }
}

- (void)longPressAddOne:(UILongPressGestureRecognizer *)gestureRecognizer
{
    currentMoneyChangeType = CalcBtnTagAdd;
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        longPress = YES;
        [self beginChangeMoney];
    }
    
    else if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        longPress = NO;
    }
    _btn_add.selected = longPress;
}

- (void)longPressAddMore:(UILongPressGestureRecognizer *)gestureRecognizer
{
    currentMoneyChangeType = CalcBtnTagFastAdd;
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        longPress = YES;
        [self beginChangeMoney];
    }
    
    else if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        longPress = NO;
    }
    _btn_fastAdd.selected = longPress;
}

- (void)longPressSubOne:(UILongPressGestureRecognizer *)gestureRecognizer
{
    currentMoneyChangeType = CalcBtnTagReduce;
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        longPress = YES;
        [self beginChangeMoney];
    }
    
    else if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        longPress = NO;
    }
    _btn_reduce.selected = longPress;
}

- (void)longPressSubMore:(UILongPressGestureRecognizer *)gestureRecognizer
{
    currentMoneyChangeType = CalcBtnTagFastReduce;
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        longPress = YES;
        [self beginChangeMoney];
    }
    
    else if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        longPress = NO;
    }
    _btn_fastReduce.selected = longPress;
}

/*
 *  @brief: 算钱按钮点击事件
 */
-(void)btnClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    currentMoneyChangeType = btn.tag;
    [self refreshMoneyView];
}

- (void)refreshMoneyView
{
    switch (currentMoneyChangeType)
    {
        case CalcBtnTagFastReduce:
            // //
            _goodsTotal -= _fastAddOrReduceNum;
            break;
        case CalcBtnTagReduce:
            _goodsTotal --;
            break;
        case CalcBtnTagAdd:
            _goodsTotal ++;
            break;
        case CalcBtnTagFastAdd:
            _goodsTotal += _fastAddOrReduceNum;
            break;
            
        default:
            break;
    }
    
    [self restrictFoodTotalCount];
    [self refreshButtonStatus];
    [self textViewSetText];
    [self numViewSetText];
}

- (void)restrictFoodTotalCount
{
    if (_goodsTotal < 1)
    {
        _goodsTotal = 1;
    }
    if (_goodsTotal > _maxNum)
    {
        _goodsTotal = _maxNum;
    }
}

- (void)refreshButtonStatus
{
    _btn_add.enabled = _goodsTotal < _maxNum;
    _btn_fastAdd.enabled = _goodsTotal <= _maxNum - _fastAddOrReduceNum;
    _btn_reduce.enabled = _goodsTotal > 1;
    _btn_fastReduce.enabled = _goodsTotal > _fastAddOrReduceNum;
}

#pragma mark - publick methods
-(void)resetgoodsMoneyView:(int)goodsNum
{
    _maxNum -= _goodsTotal;
    self.goodsTotal = _maxNum<goodsNum ? _maxNum : goodsNum;
    [self refreshButtonStatus];
    [self textViewSetText];
    [self numViewSetText];
    [self moneyLabelsUpdate];
    
}

@end

