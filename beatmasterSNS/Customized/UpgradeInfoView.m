//
//  UpgradeInfoView.m
//  beatmasterSNS
//
//  Created by 刘旺 on 13-8-13.
//
//

#import "UpgradeInfoView.h"

#import "DataManager.h"
#import "UserStaminaView.h"
#import "Math.h"    

@implementation UpgradeInfoView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame RankupLevel:(int)level withUInfo:(UpgradeInfo*)uInfo;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _level = level;
        _upgradeInfo = uInfo;
        [self initView];
        
    }
    return self;
}

#pragma mark -
#pragma mark Init View Method

- (void)initView
{
    _bgView = [[UIImageView alloc] init];
    _bgView.frame = SCREEN_FRAME;
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0.7;
    [self addSubview:_bgView];
    [_bgView release];
    [_bgView setUserInteractionEnabled:NO];
    _bgView.hidden = YES;
    
    _contentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed_New:@"UIV_contentBg.png"]];
    _contentView.frame = SNSRect(0, 0, _contentView.frame.size.width*SNS_SCALE, _contentView.frame.size.height*SNS_SCALE);
    _contentView.center = SNSPoint(_bgView.frame.size.width/2, _bgView.frame.size.height/2);
    [self addSubview:_contentView];
    [_contentView setUserInteractionEnabled:YES];
    [_contentView release];
    _contentView.hidden = YES;
    
    _closeBtn = [CustomUIButton buttonWithNormalImage:@"Com_PMV_xBtn02_1.png" highlightImage:@"Com_PMV_xBtn02_2.png" target:self action:@selector(closeBtnClicked) sound:SFX_BUTTON];
    _closeBtn.frame = SNSRect(_contentView.frame.size.width - 56.0f*SNS_SCALE, 0*SNS_SCALE, 50.0f * SNS_SCALE, 50.0f * SNS_SCALE);
    [_contentView addSubview:_closeBtn];
    
    [self creatBaseContenView:_contentView];
    [self adjustContentView:_contentView uInfo:_upgradeInfo];
    
    
    
    _titleView = [[UIView alloc] initWithFrame:SNSRect(SCREEN_WIDTH/2-175*SNS_SCALE, SCREEN_HEIGHT/2-110*SNS_SCALE, 350*SNS_SCALE, 35*SNS_SCALE)];
    [self addSubview:_titleView];
    [self createTitleText:_titleView Level:_level];
    [_titleView release];
    [_titleView setUserInteractionEnabled:YES];
    _titleView.hidden = YES;
    
    UIImage *starImage = [UIImage imageNamed_New:@"sj0001.png"];
    _starView = [[UIImageView alloc] init];
    _starView.frame = SNSRect(SCREEN_WIDTH/2- starImage.size.width*SNS_SCALE/2, SCREEN_HEIGHT/2- starImage.size.height*SNS_SCALE/2-80*SNS_SCALE, starImage.size.width*SNS_SCALE, starImage.size.height*SNS_SCALE);
    [self addSubview:_starView];
    [_starView release];
    
    NSMutableArray * animateArray = [[[NSMutableArray alloc] initWithCapacity:10] autorelease];
    for (int i = 1; i < 14; i++) {
        NSString * frameFile = [NSString stringWithFormat:@"sj00%.2d.png",i];
        [animateArray addObject:[UIImage imageNamed_New:frameFile]];
    }
    _starView.animationImages = animateArray;
    _starView.hidden = YES;
    
    [self upgradeStamina:_upgradeInfo];
    [self upgradeCoins:_upgradeInfo];
}


- (void)creatBaseContenView:(UIImageView*)view
{
    _itemArray = [[NSMutableArray alloc] init];
    _imageArray = [[NSMutableArray alloc] init];
    _textArray = [[NSMutableArray alloc] init];
    
    UIImage* bgImg = [UIImage imageNamed_New:@"UIV_itemBg.png"];
    
    UIImageView* item1 = [[UIImageView alloc] initWithImage:bgImg];
    item1.frame = SNSRect(30*SNS_SCALE, 35*SNS_SCALE, bgImg.size.width*SNS_SCALE, bgImg.size.height*SNS_SCALE);
    [view addSubview:item1];
    [item1 release];
    [_itemArray addObject:item1];
    
    UIImageView* imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed_New:@"UIV_shine.png"]];
    imageView1.frame = SNSRect(15*SNS_SCALE, 15*SNS_SCALE, 40*SNS_SCALE, 40*SNS_SCALE);
    imageView1.contentMode = UIViewContentModeScaleAspectFit;
    [item1 addSubview:imageView1];
    [imageView1 release];
    [_imageArray addObject:imageView1];
    
    UILabel* text1 = [[UILabel alloc] init];
    [Utils autoTextSizeLabel:text1 font:[UIFont systemFontOfSize:14*SNS_SCALE] labelAlign:AutoTextSizeLabelAlignCenter frame:SNSRect(65*SNS_SCALE, 120*SNS_SCALE, 70*SNS_SCALE, 20*SNS_SCALE) text:@"" textColor:[UIColor whiteColor]];
    [view addSubview:text1];
    [text1 release];
    [_textArray addObject:text1];
    
    UIImageView* item2 = [[UIImageView alloc] initWithImage:bgImg];
    item2.frame = SNSRect(105*SNS_SCALE, 35*SNS_SCALE, bgImg.size.width*SNS_SCALE, bgImg.size.height*SNS_SCALE);
    [view addSubview:item2];
    [item2 release];
    [_itemArray addObject:item2];
    
    UIImageView* imageView2 = [[UIImageView alloc] init];
    imageView2.frame = SNSRect(15*SNS_SCALE, 15*SNS_SCALE, 40*SNS_SCALE, 40*SNS_SCALE);
    imageView2.contentMode = UIViewContentModeScaleAspectFit;
    [item2 addSubview:imageView2];
    [imageView2 release];
    [_imageArray addObject:imageView2];
    
    UILabel* text2 = [[UILabel alloc] init];
    [view addSubview:text2];
    [text2 release];
    [_textArray addObject:text2];
    
    UIImageView* item3 = [[UIImageView alloc] initWithImage:bgImg];
    item3.frame = SNSRect(180*SNS_SCALE,35*SNS_SCALE,  bgImg.size.width*SNS_SCALE, bgImg.size.height*SNS_SCALE);
    [view addSubview:item3];
    [item3 release];
    [_itemArray addObject:item3];
    
    UIImageView* imageView3 = [[UIImageView alloc] init];
    imageView3.frame = SNSRect(15*SNS_SCALE, 15*SNS_SCALE, 40*SNS_SCALE, 40*SNS_SCALE);
    imageView3.image = [UIImage imageNamed_New:@"music_default.png"];
    imageView3.contentMode = UIViewContentModeScaleAspectFit;
    [item3 addSubview:imageView3];
    [imageView3 release];
    [_imageArray addObject:imageView3];
    
    UILabel* text3 = [[UILabel alloc] init];
    [view addSubview:text3];
    [text3 release];
    [_textArray addObject:text3];
    
    
    UIImageView* item4 = [[UIImageView alloc] initWithImage:bgImg];
    item4.frame = SNSRect(255*SNS_SCALE, 35*SNS_SCALE, bgImg.size.width*SNS_SCALE, bgImg.size.height*SNS_SCALE);
    [view addSubview:item4];
    [item4 release];
    [_itemArray addObject:item4];
    
    UIImageView* imageView4 = [[UIImageView alloc] init];
    imageView4.frame = SNSRect(15*SNS_SCALE, 15*SNS_SCALE, 40*SNS_SCALE, 40*SNS_SCALE);
    imageView4.image = [UIImage imageNamed_New:@"music_default.png"];
    imageView4.contentMode = UIViewContentModeScaleAspectFit;
    [item4 addSubview:imageView4];
    [imageView4 release];
    [_imageArray addObject:imageView4];
    
    UILabel* text4 = [[UILabel alloc] init];
    [view addSubview:text4];
    [text4 release];
    [_textArray addObject:text4];

}

- (void)adjustContentView:(UIImageView*)view uInfo:(UpgradeInfo*)uInfo
{
    int allItemCount = 0;
    
    UIImageView     *currentItem = _itemArray[allItemCount];
    UIImageView     *currentImg = _imageArray[allItemCount];
    UILabel         *currentText = _textArray[allItemCount];

    //item1
    [Utils autoTextSizeLabel:currentText font:[UIFont systemFontOfSize:14*SNS_SCALE] labelAlign:AutoTextSizeLabelAlignCenter frame:SNSRect(65*SNS_SCALE, 120*SNS_SCALE, 70*SNS_SCALE, 20*SNS_SCALE) text:[NSString stringWithFormat:@"+%d",uInfo.coinNum] textColor:[UIColor whiteColor]];

    allItemCount = 1;
    currentItem = _itemArray[allItemCount];
    currentImg = _imageArray[allItemCount];
    currentText = _textArray[allItemCount];
    
    //item2
    int unlockMusicNum = 0;
    NSArray *unlockMusics; 
    if (![uInfo.unlockMusicID isEqual:@""] && uInfo.unlockMusicID != nil && ![uInfo.unlockMusicID isEqual:@" "]) {
        unlockMusics = [uInfo.unlockMusicID componentsSeparatedByString:@","];
        unlockMusicNum = [unlockMusics count];
    }else
    {
        unlockMusicNum = 0;
    }
    //歌曲解锁奖励  如果存在歌曲解锁
    if (unlockMusicNum >= 1) {
        NSString* url = [[DataManager shareDataManager].localFileManager getFilePathByFileName:FILEPATH_SINGER_HEADICON fileName:[NSString stringWithFormat:@"/commonres/singerHeadIcon/%@_mini.png",unlockMusics[0]]];
        if ([Math isFileExist:url]) {
            currentImg.image = [UIImage imageWithContentsOfFile_New:url];
        }else
        {
            currentImg.image = [UIImage imageNamed_New:@"music_default.png"];
        }
        
        [Utils autoTextSizeLabel:currentText font:[UIFont systemFontOfSize:14*SNS_SCALE] labelAlign:AutoTextSizeLabelAlignCenter frame:SNSRect(140*SNS_SCALE, 120*SNS_SCALE, 70*SNS_SCALE, 20*SNS_SCALE) text:MultiLanguage(ugivLMusicUnlock) textColor:[UIColor whiteColor]];
        allItemCount = 2;
    }
    
    //如果歌曲解锁数量为2 
    if (unlockMusicNum == 2) {
        allItemCount = 2;
        currentItem = _itemArray[allItemCount];
        currentImg = _imageArray[allItemCount];
        currentText = _textArray[allItemCount];
        
        NSString* url = [[DataManager shareDataManager].localFileManager getFilePathByFileName:FILEPATH_SINGER_HEADICON fileName:[NSString stringWithFormat:@"/commonres/singerHeadIcon/%@_mini.png",unlockMusics[1]]];
        if ([Math isFileExist:url]) {
            currentImg.image = [UIImage imageWithContentsOfFile_New:url];
        }else
        {
            currentImg.image = [UIImage imageNamed_New:@"music_default.png"];
        }
        [Utils autoTextSizeLabel:currentText font:[UIFont systemFontOfSize:14*SNS_SCALE] labelAlign:AutoTextSizeLabelAlignCenter frame:SNSRect(215*SNS_SCALE, 120*SNS_SCALE, 70*SNS_SCALE, 20*SNS_SCALE) text:@"歌曲解锁" textColor:[UIColor whiteColor]];
        
        allItemCount = 3;
        
    }
    
    //服饰奖励
    NSArray *genderArr;
    NSArray *manClothArr;
    NSArray *womanClothArr;
    NSArray *useArr;
    //如果有服饰奖励
    if (![uInfo.clothIDOne isEqual:@""] && uInfo.clothIDOne != nil && ![uInfo.clothIDOne isEqual:@" "])
    {
        genderArr = [uInfo.clothIDOne componentsSeparatedByString:@";"];
        //如果分组后的数据不为2 则表示数据错误 不予以显示
        if ([genderArr count] != 2) {
            [self adjustCommodityPosition:allItemCount view:view];
            return;
        }
        manClothArr = [genderArr[0] componentsSeparatedByString:@","];
        womanClothArr = [genderArr[1] componentsSeparatedByString:@","];
    }else
    {
        //无服饰奖励
        [self adjustCommodityPosition:allItemCount view:view];
        return;
    }
    
    
    //如果有服饰奖励
    //假抽奖方式 uid对数量取模
    //如果是女
    if([DataManager shareDataManager].self_UserInfo.gender == 0)
    {
        useArr = womanClothArr;
    }else
    {
        useArr = manClothArr;
    }
    int uidNum = [Math findNumFromStr:[DataManager shareDataManager].self_UserInfo.userID];
    NSString* selectClothID = useArr[uidNum%[useArr count]] ;
    CommodityInfo *cInfo = ([DataManager shareDataManager].shop_CommodityInfo_Dic)[selectClothID];
    //商品是否存在
    BOOL isCommodityExists = YES;
    if (cInfo == nil || [cInfo isEqual:[NSNull null]]) {
        isCommodityExists = NO;
    }
    if (uInfo.clothIDOne != nil && ![uInfo.clothIDOne isEqualToString:@""] && ![uInfo.clothIDOne isEqualToString:@" "])
    {
        if (unlockMusicNum>=3) {
            [self adjustCommodityPosition:allItemCount view:view];
            return;
        }
        currentItem = _itemArray[allItemCount];
        currentImg = _imageArray[allItemCount];
        currentText = _textArray[allItemCount];
        CGRect textRect;
        if (allItemCount == 1) {
            textRect = SNSRect(140*SNS_SCALE, 120*SNS_SCALE, 70*SNS_SCALE, 20*SNS_SCALE);
        }else if (allItemCount == 2)
        {
            textRect = SNSRect(215*SNS_SCALE, 120*SNS_SCALE, 70*SNS_SCALE, 20*SNS_SCALE);
        }else if (allItemCount == 3)
        {
            textRect = SNSRect(290*SNS_SCALE, 120*SNS_SCALE, 70*SNS_SCALE, 20*SNS_SCALE);
        }
        //商品图片路径
        NSString* iconFilePath = [[DataManager shareDataManager] getCertainUsershow_Path_Icon:cInfo];
        if (isCommodityExists && [Math isFileExist:iconFilePath]) {
            currentImg.image = [UIImage imageWithContentsOfFile:iconFilePath];
        }else
        {
            currentImg.image = [UIImage imageNamed_New:@"UIV_commodityDefault.png"];
        }
        
        [Utils autoTextSizeLabel:currentText font:[UIFont systemFontOfSize:14*SNS_SCALE] labelAlign:AutoTextSizeLabelAlignCenter frame:textRect text:[self getCommodityName:cInfo.firstType] textColor:[UIColor whiteColor]];
        allItemCount++;
    }
    
    if (allItemCount>=4) {
        [self adjustCommodityPosition:allItemCount view:view];
        return;
    }
    
    //如果有两件服饰
    NSArray *genderArrTwo;
    NSArray *manClothArrTwo;
    NSArray *womanClothArrTwo;
    NSArray *useArrTwo;
    //如果有服饰奖励
    if (![uInfo.clothIDTwo isEqual:@""] && uInfo.clothIDTwo != nil && ![uInfo.clothIDTwo isEqual:@" "])
    {
        genderArrTwo = [uInfo.clothIDTwo componentsSeparatedByString:@";"];
        //如果分组后的数据不为2 则表示数据错误 不予以显示
        if ([genderArrTwo count] != 2) {
            [self adjustCommodityPosition:allItemCount view:view];
            return;
        }
        manClothArrTwo = [genderArrTwo[0] componentsSeparatedByString:@","];
        womanClothArrTwo = [genderArrTwo[1] componentsSeparatedByString:@","];
    }else
    {
        //无服饰奖励
        [self adjustCommodityPosition:allItemCount view:view];
        return;
    }
    
    //如果有第二件服饰奖励
    //假抽奖方式 uid对数量取模
    //如果是女
    if([DataManager shareDataManager].self_UserInfo.gender == 0)
    {
        useArrTwo = womanClothArrTwo;
    }else
    {
        useArrTwo = manClothArrTwo;
    }
    NSString* selectClothIDTwo = useArrTwo[uidNum%[useArrTwo count]] ;
    CommodityInfo *cInfoTwo = ([DataManager shareDataManager].shop_CommodityInfo_Dic)[selectClothIDTwo];
    //商品是否存在
    BOOL isCommodityExistsTwo = YES;
    if (cInfoTwo == nil || [cInfoTwo isEqual:[NSNull null]]) {
        isCommodityExistsTwo = NO;
    }
    if (uInfo.clothIDTwo != nil && ![uInfo.clothIDTwo isEqualToString:@""] && ![uInfo.clothIDTwo isEqualToString:@" "])
    {
        if (allItemCount>=4) {
            [self adjustCommodityPosition:allItemCount view:view];
            return;
        }
        currentItem = _itemArray[allItemCount];
        currentImg = _imageArray[allItemCount];
        currentText = _textArray[allItemCount];
        CGRect         textRect = SNSRect(290*SNS_SCALE, 120*SNS_SCALE, 70*SNS_SCALE, 20*SNS_SCALE);
        if (allItemCount == 2) {
            textRect = SNSRect(215*SNS_SCALE, 120*SNS_SCALE, 70*SNS_SCALE, 20*SNS_SCALE);
        }else if (allItemCount == 3) {
            textRect = SNSRect(290*SNS_SCALE, 120*SNS_SCALE, 70*SNS_SCALE, 20*SNS_SCALE);
        }
        //商品图片路径
        NSString* iconFilePath = [[DataManager shareDataManager] getCertainUsershow_Path_Icon:cInfoTwo];
        if (isCommodityExists && [Math isFileExist:iconFilePath]) {
            currentImg.image = [UIImage imageWithContentsOfFile:iconFilePath];
        }else
        {
            currentImg.image = [UIImage imageNamed_New:@"UIV_commodityDefault.png"];
        }
        [Utils autoTextSizeLabel:currentText font:[UIFont systemFontOfSize:14*SNS_SCALE] labelAlign:AutoTextSizeLabelAlignCenter frame:textRect text:[self getCommodityName:cInfoTwo.firstType] textColor:[UIColor whiteColor]];
        allItemCount++;
    }else
    {
        [self adjustCommodityPosition:allItemCount view:view];
    }
    
    //如果有三件服饰
    NSArray *genderArrThree;
    NSArray *manClothArrThree;
    NSArray *womanClothArrThree;
    NSArray *useArrThree;
    //如果有服饰奖励
    if (![uInfo.clothIDThree isEqual:@""] && uInfo.clothIDThree != nil && ![uInfo.clothIDThree isEqual:@" "])
    {
        genderArrThree = [uInfo.clothIDThree componentsSeparatedByString:@";"];
        //如果分组后的数据不为2 则表示数据错误 不予以显示
        if ([genderArrThree count] != 2) {
            [self adjustCommodityPosition:allItemCount view:view];
            return;
        }
        manClothArrThree = [genderArrThree[0] componentsSeparatedByString:@","];
        womanClothArrThree = [genderArrThree[1] componentsSeparatedByString:@","];
        
    }else
    {
        //无服饰奖励
        [self adjustCommodityPosition:allItemCount view:view];
        return;
    }
    
    //如果有第三件服饰奖励
    //假抽奖方式 uid对数量取模
    //如果是女
    if([DataManager shareDataManager].self_UserInfo.gender == 0)
    {
        useArrThree = womanClothArrThree;
    }else
    {
        useArrThree = manClothArrThree;
    }
    NSString* selectClothIDThree = useArrThree[uidNum%[useArrThree count]] ;
    CommodityInfo *cInfoThree = ([DataManager shareDataManager].shop_CommodityInfo_Dic)[selectClothIDThree];
    //商品是否存在
    BOOL isCommodityExistsThree = YES;
    if (cInfoThree == nil || [cInfoThree isEqual:[NSNull null]]) {
        isCommodityExistsThree = NO;
    }
    if (uInfo.clothIDThree != nil && ![uInfo.clothIDThree isEqualToString:@""] && ![uInfo.clothIDThree isEqualToString:@" "])
    {
        if (allItemCount>=4) {
            [self adjustCommodityPosition:allItemCount view:view];
            return;
        }
        currentItem = _itemArray[allItemCount];
        currentImg = _imageArray[allItemCount];
        currentText = _textArray[allItemCount];
        CGRect         textRect = SNSRect(290*SNS_SCALE, 120*SNS_SCALE, 70*SNS_SCALE, 20*SNS_SCALE);
        if (allItemCount == 3) {
            textRect = SNSRect(290*SNS_SCALE, 120*SNS_SCALE, 70*SNS_SCALE, 20*SNS_SCALE);
        }
        //商品图片路径
        NSString* iconFilePath = [[DataManager shareDataManager] getCertainUsershow_Path_Icon:cInfoThree];
        if (isCommodityExists && [Math isFileExist:iconFilePath]) {
            currentImg.image = [UIImage imageWithContentsOfFile:iconFilePath];
        }else
        {
            currentImg.image = [UIImage imageNamed_New:@"UIV_commodityDefault.png"];
        }
        [Utils autoTextSizeLabel:currentText font:[UIFont systemFontOfSize:14*SNS_SCALE] labelAlign:AutoTextSizeLabelAlignCenter frame:textRect text:[self getCommodityName:cInfoThree.firstType] textColor:[UIColor whiteColor]];
        allItemCount ++;
    }
    
    [self adjustCommodityPosition:allItemCount view:view];
    
    
}

-(void)adjustCommodityPosition:(int) allItemCount view:(UIImageView*)view
{
    switch (allItemCount) {
        case 1:
        {
            UIImageView* item1 =_itemArray[0];
            item1.frame = SNSRect(147*SNS_SCALE, 35*SNS_SCALE, 70*SNS_SCALE, 70*SNS_SCALE);
            [_itemArray[1] removeFromSuperview];
            [_itemArray[2] removeFromSuperview];
            [_itemArray[3] removeFromSuperview];
            
            UILabel* text1 = (UILabel*)_textArray[0];
            [Utils autoTextSizeLabel:text1 font:[UIFont systemFontOfSize:14*SNS_SCALE] labelAlign:AutoTextSizeLabelAlignCenter frame:SNSRect(182*SNS_SCALE, 115*SNS_SCALE, 70*SNS_SCALE, 20*SNS_SCALE) text:text1.text textColor:[UIColor whiteColor]];
        }
            break;
        case 2:
        {            
            [_itemArray[2] removeFromSuperview];
            [_itemArray[3] removeFromSuperview];
            UIImageView* item1 =_itemArray[0];
            item1.frame = SNSRect(72*SNS_SCALE, 35*SNS_SCALE, 70*SNS_SCALE, 70*SNS_SCALE);
            UIImageView* item2 =_itemArray[1];
            item2.frame = SNSRect(205*SNS_SCALE, 35*SNS_SCALE, 70*SNS_SCALE, 70*SNS_SCALE);
            
            UILabel* text1 = (UILabel*)_textArray[0];
            [Utils autoTextSizeLabel:text1 font:[UIFont systemFontOfSize:14*SNS_SCALE] labelAlign:AutoTextSizeLabelAlignCenter frame:SNSRect(107*SNS_SCALE, 115*SNS_SCALE, 70*SNS_SCALE, 20*SNS_SCALE) text:text1.text textColor:[UIColor whiteColor]];
            UILabel* text2 = (UILabel*)_textArray[1];
            [Utils autoTextSizeLabel:text2 font:[UIFont systemFontOfSize:14*SNS_SCALE] labelAlign:AutoTextSizeLabelAlignCenter frame:SNSRect(240*SNS_SCALE, 115*SNS_SCALE, 70*SNS_SCALE, 20*SNS_SCALE) text:text2.text textColor:[UIColor whiteColor]];
        }
            break;
        case 3:
        {
            [_itemArray[3] removeFromSuperview];
            UIImageView* item1 =_itemArray[0];
            item1.frame = SNSRect(39*SNS_SCALE, 35*SNS_SCALE, 70*SNS_SCALE, 70*SNS_SCALE);
            UIImageView* item2 =_itemArray[1];
            item2.frame = SNSRect(139*SNS_SCALE, 35*SNS_SCALE, 70*SNS_SCALE, 70*SNS_SCALE);
            UIImageView* item3 =_itemArray[2];
            item3.frame = SNSRect(239*SNS_SCALE, 35*SNS_SCALE, 70*SNS_SCALE, 70*SNS_SCALE);

            UILabel* text1 = (UILabel*)_textArray[0];
            [Utils autoTextSizeLabel:text1 font:[UIFont systemFontOfSize:14*SNS_SCALE] labelAlign:AutoTextSizeLabelAlignCenter frame:SNSRect(74*SNS_SCALE, 115*SNS_SCALE, 70*SNS_SCALE, 20*SNS_SCALE) text:text1.text textColor:[UIColor whiteColor]];
            UILabel* text2 = (UILabel*)_textArray[1];
            [Utils autoTextSizeLabel:text2 font:[UIFont systemFontOfSize:14*SNS_SCALE] labelAlign:AutoTextSizeLabelAlignCenter frame:SNSRect(174*SNS_SCALE, 115*SNS_SCALE, 70*SNS_SCALE, 20*SNS_SCALE) text:text2.text textColor:[UIColor whiteColor]];
            UILabel* text3 = (UILabel*)_textArray[2];
            [Utils autoTextSizeLabel:text3 font:[UIFont systemFontOfSize:14*SNS_SCALE] labelAlign:AutoTextSizeLabelAlignCenter frame:SNSRect(274*SNS_SCALE, 115*SNS_SCALE, 70*SNS_SCALE, 20*SNS_SCALE) text:text3.text textColor:[UIColor whiteColor]];
        }
            break;
        case 4:
        {
            UIImageView* item1 =_itemArray[0];
            item1.frame = SNSRect(28*SNS_SCALE, 35*SNS_SCALE, 70*SNS_SCALE, 70*SNS_SCALE);
            UIImageView* item2 =_itemArray[1];
            item2.frame = SNSRect(103*SNS_SCALE, 35*SNS_SCALE, 70*SNS_SCALE, 70*SNS_SCALE);
            UIImageView* item3 =_itemArray[2];
            item3.frame = SNSRect(178*SNS_SCALE, 35*SNS_SCALE, 70*SNS_SCALE, 70*SNS_SCALE);
            UIImageView* item4 =_itemArray[3];
            item4.frame = SNSRect(253*SNS_SCALE, 35*SNS_SCALE, 70*SNS_SCALE, 70*SNS_SCALE);
            
            UILabel* text1 = (UILabel*)_textArray[0];
            [Utils autoTextSizeLabel:text1 font:[UIFont systemFontOfSize:14*SNS_SCALE] labelAlign:AutoTextSizeLabelAlignCenter frame:SNSRect(63*SNS_SCALE, 115*SNS_SCALE, 70*SNS_SCALE, 20*SNS_SCALE) text:text1.text textColor:[UIColor whiteColor]];
            UILabel* text2 = (UILabel*)_textArray[1];
            [Utils autoTextSizeLabel:text2 font:[UIFont systemFontOfSize:14*SNS_SCALE] labelAlign:AutoTextSizeLabelAlignCenter frame:SNSRect(138*SNS_SCALE, 115*SNS_SCALE, 70*SNS_SCALE, 20*SNS_SCALE) text:text2.text textColor:[UIColor whiteColor]];
            UILabel* text3 = (UILabel*)_textArray[2];
            [Utils autoTextSizeLabel:text3 font:[UIFont systemFontOfSize:14*SNS_SCALE] labelAlign:AutoTextSizeLabelAlignCenter frame:SNSRect(213*SNS_SCALE, 115*SNS_SCALE, 70*SNS_SCALE, 20*SNS_SCALE) text:text3.text textColor:[UIColor whiteColor]];
            UILabel* text4 = (UILabel*)_textArray[3];
            [Utils autoTextSizeLabel:text4 font:[UIFont systemFontOfSize:14*SNS_SCALE] labelAlign:AutoTextSizeLabelAlignCenter frame:SNSRect(287*SNS_SCALE, 115*SNS_SCALE, 70*SNS_SCALE, 20*SNS_SCALE) text:text4.text textColor:[UIColor whiteColor]];
            
        }
            break;
        default:
        {
            UIImageView* item1 =_itemArray[0];
            item1.frame = SNSRect(28*SNS_SCALE, 35*SNS_SCALE, 70*SNS_SCALE, 70*SNS_SCALE);
            UIImageView* item2 =_itemArray[1];
            item2.frame = SNSRect(103*SNS_SCALE, 35*SNS_SCALE, 70*SNS_SCALE, 70*SNS_SCALE);
            UIImageView* item3 =_itemArray[2];
            item3.frame = SNSRect(178*SNS_SCALE, 35*SNS_SCALE, 70*SNS_SCALE, 70*SNS_SCALE);
            UIImageView* item4 =_itemArray[3];
            item4.frame = SNSRect(253*SNS_SCALE, 35*SNS_SCALE, 70*SNS_SCALE, 70*SNS_SCALE);
            
            UILabel* text1 = (UILabel*)_textArray[0];
            [Utils autoTextSizeLabel:text1 font:[UIFont systemFontOfSize:14*SNS_SCALE] labelAlign:AutoTextSizeLabelAlignCenter frame:SNSRect(63*SNS_SCALE, 115*SNS_SCALE, 70*SNS_SCALE, 20*SNS_SCALE) text:text1.text textColor:[UIColor whiteColor]];
            UILabel* text2 = (UILabel*)_textArray[1];
            [Utils autoTextSizeLabel:text2 font:[UIFont systemFontOfSize:14*SNS_SCALE] labelAlign:AutoTextSizeLabelAlignCenter frame:SNSRect(138*SNS_SCALE, 115*SNS_SCALE, 70*SNS_SCALE, 20*SNS_SCALE) text:text2.text textColor:[UIColor whiteColor]];
            UILabel* text3 = (UILabel*)_textArray[2];
            [Utils autoTextSizeLabel:text3 font:[UIFont systemFontOfSize:14*SNS_SCALE] labelAlign:AutoTextSizeLabelAlignCenter frame:SNSRect(213*SNS_SCALE, 115*SNS_SCALE, 70*SNS_SCALE, 20*SNS_SCALE) text:text3.text textColor:[UIColor whiteColor]];
            UILabel* text4 = (UILabel*)_textArray[3];
            [Utils autoTextSizeLabel:text4 font:[UIFont systemFontOfSize:14*SNS_SCALE] labelAlign:AutoTextSizeLabelAlignCenter frame:SNSRect(287*SNS_SCALE, 115*SNS_SCALE, 70*SNS_SCALE, 20*SNS_SCALE) text:text4.text textColor:[UIColor whiteColor]];
            
        }
            break;
    }
}

-(NSString* )getCommodityName:(ECommodityType) type
{
//    ECT_HAIR = 0,
//    ECT_FACE,
//    ECT_COAT,
//    ECT_TROUSER,
//    ECT_SUIT,
//    ECT_SHOE,
//    ECT_SNOOPY, // 0:项链 1:戒指 2:羽翼 3:眼镜 4:耳环 5:头饰 6:手持 7:徽章 8:背包 9:手镯
//    ECT_DOLLS,  // 0:抱腿玩偶 1:环绕玩偶 2:站立玩偶 3:背后玩偶
//    ECT_PK_SUIT = 8,
//    ECT_GIFT = 9
    NSString* resultStr = MultiLanguage(ugivLCommodity);
    switch (type) {
        case ECT_HAIR:
            resultStr = MultiLanguage(ugivLHair);
            break;
        case ECT_FACE:
            resultStr = MultiLanguage(ugivLFace);
            break;
        case ECT_COAT:
            resultStr = MultiLanguage(ugivLCoat);
            break;
        case ECT_TROUSER:
            resultStr = MultiLanguage(ugivLTrouser);
            break;
        case ECT_SUIT:
            resultStr = MultiLanguage(ugivLSuit);
            break;
        case ECT_SHOE:
            resultStr = MultiLanguage(ugivLShoe);
            break;
        case ECT_SNOOPY:
            resultStr = MultiLanguage(ugivLSnoopy);
            break;
        case ECT_DOLLS:
            resultStr = MultiLanguage(ugivLDolls);
            break;
        case ECT_PK_SUIT:
            resultStr = @"";
            break;
        case ECT_GIFT:
            resultStr = @"";
            break;            
        default:
            break;
    }
    return resultStr;
}


- (void)createTitleText:(UIView*) view Level:(int) level
{
    int textLength = 0;
    
    UIImageView* imgFront = [[UIImageView alloc] initWithImage:[UIImage imageNamed_New:@"UIV_textFront.png"]];
    imgFront.frame = SNSRect(0, 0, imgFront.frame.size.width*SNS_SCALE, imgFront.frame.size.height*SNS_SCALE);
    [view addSubview:imgFront];
    [imgFront release];
    
    textLength = imgFront.frame.size.width*SNS_SCALE;
    
    if (level<10) {
        NSString *numStr = [NSString stringWithFormat:@"UIV_levelnum_%d.png",level];
        UIImageView* num = [[UIImageView alloc] initWithImage:[UIImage imageNamed_New:numStr]];
        num.frame = SNSRect(57*SNS_SCALE, 0, num.frame.size.width*SNS_SCALE, num.frame.size.height*SNS_SCALE);
        [view addSubview:num];
        [num release];
        textLength = 57*SNS_SCALE+num.frame.size.width;
    }else if (level <100)
    {
        NSString *numStr = [NSString stringWithFormat:@"UIV_levelnum_%d.png",level/10];
        UIImageView* num1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed_New:numStr]];
        num1.frame = SNSRect(54*SNS_SCALE, 0, num1.frame.size.width*SNS_SCALE, num1.frame.size.height*SNS_SCALE);
        [view addSubview:num1];
        [num1 release];
        
        numStr = [NSString stringWithFormat:@"UIV_levelnum_%d.png",level%10];
        UIImageView* num2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed_New:numStr]];
        num2.frame = SNSRect(54*SNS_SCALE+num1.frame.size.width-6*SNS_SCALE, 0, num2.frame.size.width*SNS_SCALE, num2.frame.size.height*SNS_SCALE);
        [view addSubview:num2];
        [num2 release];
        
        textLength = 54*SNS_SCALE+num1.frame.size.width*2-6*SNS_SCALE;
    }else
    {
        NSString *numStr = [NSString stringWithFormat:@"UIV_levelnum_%d.png",level/100];
        UIImageView* num1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed_New:numStr]];
        num1.frame = SNSRect(54*SNS_SCALE, 0, num1.frame.size.width*SNS_SCALE, num1.frame.size.height*SNS_SCALE);
        [view addSubview:num1];
        [num1 release];
        
        numStr = [NSString stringWithFormat:@"UIV_levelnum_%d.png",(level%100)/10];
        UIImageView* num2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed_New:numStr]];
        num2.frame = SNSRect(54*SNS_SCALE+num1.frame.size.width-6*SNS_SCALE, 0, num2.frame.size.width*SNS_SCALE, num2.frame.size.height*SNS_SCALE);
        [view addSubview:num2];
        [num2 release];
        
        numStr = [NSString stringWithFormat:@"UIV_levelnum_%d.png",level%10];
        UIImageView* num3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed_New:numStr]];
        num3.frame = SNSRect(54*SNS_SCALE+num1.frame.size.width*2-12*SNS_SCALE, 0, num3.frame.size.width*SNS_SCALE, num3.frame.size.height*SNS_SCALE);
        [view addSubview:num3];
        [num3 release];
        
        textLength = 54*SNS_SCALE+num1.frame.size.width*3-12*SNS_SCALE;
    }
    
    UIImageView* imgMiddle = [[UIImageView alloc] initWithImage:[UIImage imageNamed_New:@"UIV_textMiddle.png"]];
    imgMiddle.frame = SNSRect(textLength, 0, imgMiddle.frame.size.width*SNS_SCALE, imgMiddle.frame.size.height*SNS_SCALE);
    [view addSubview:imgMiddle];
    [imgMiddle release];
    
    textLength += imgMiddle.frame.size.width;
    
    NSString* title = [[DataManager shareDataManager].localDBManager selectData_TitleInfo_Table_OneInfo:_level];
    CGRect titleRect = SNSRect(textLength, 5*SNS_SCALE, 300*SNS_SCALE, 30*SNS_SCALE);
    UILabel* levelTitle = [[UILabel alloc] init];
    [Utils autoTextSizeLabel:levelTitle font:[UIFont boldSystemFontOfSize:22*SNS_SCALE] labelAlign:AutoTextSizeLabelAlignLeft frame:titleRect text:title textColor:[UIColor whiteColor]];
    [view addSubview:levelTitle];
    [levelTitle release];
    
    textLength += levelTitle.frame.size.width;
    
    UIImageView* imgBehind = [[UIImageView alloc] initWithImage:[UIImage imageNamed_New:@"UIV_textBehind.png"]];
    imgBehind.frame = SNSRect(textLength, 0, imgBehind.frame.size.width*SNS_SCALE, imgBehind.frame.size.height*SNS_SCALE);
    [view addSubview:imgBehind];
    [imgBehind release];
    
    textLength += imgBehind.frame.size.width;
    
    
    CGRect oldRect = view.frame;
    //根据实际的长度计算放大时的锚点，确保锚点位于文字的中心
    [view.layer setAnchorPoint:CGPointMake((textLength/2)/view.frame.size.width, 0.5)];
    //调整过锚点后，view的坐标会发生变化，重置为之前的位置
    view.frame = oldRect;
    //根据实际的长度移动view位于屏幕中央
    view.frame = SNSRect(view.frame.origin.x+view.frame.size.width/2-textLength/2, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
}

#pragma mark -
#pragma mark Init Animation Method

-(void)beginAnimation
{
    [self performSelector:@selector(beginContentAnimation) withObject:self afterDelay:0.f];
    [self performSelector:@selector(beginBgViewAnimation) withObject:self afterDelay:0.2f];
    [self performSelector:@selector(beginStarAnimation) withObject:self afterDelay:0.4f];
    [self performSelector:@selector(beginTextAnimation) withObject:self afterDelay:0.4f];
}


-(void)beginContentAnimation
{
    _contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.2, 0.2);
    _contentView.hidden = NO;
    [UIView beginAnimations:@"contentAni" context:nil];
    [UIView setAnimationDuration:0.2];//动画持续时间
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];//动画速度
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationTransition: UIViewAnimationTransitionNone//类型
                           forView:_contentView
                             cache:NO];
    _contentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    [UIView setAnimationDelegate:self];//添加委托
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];// 实现回调
    [UIView commitAnimations];
    
}

-(void)beginBgViewAnimation
{
    _bgView.alpha = 0;
    _bgView.hidden = NO;
    [UIView beginAnimations:@"bgviewAni" context:nil];
    [UIView setAnimationDuration:0.2];//动画持续时间
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];//动画速度
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationTransition: UIViewAnimationTransitionNone//类型
                           forView:_bgView
                             cache:NO];
    _bgView.alpha = 0.7;
    [UIView setAnimationDelegate:self];//添加委托
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];// 实现回调
    [UIView commitAnimations];
    
}

- (void)beginStarAnimation
{
    _starView.hidden = NO;
    _starView.animationDuration = 0.6;
    _starView.animationRepeatCount = 1;
    [_starView startAnimating];
}

- (void)beginTextAnimation
{
    _titleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.2, 0.2);
    _titleView.hidden = NO;
    [UIView beginAnimations:@"textAni" context:nil];
    [UIView setAnimationDuration:0.3];//动画持续时间
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];//动画速度
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationTransition: UIViewAnimationTransitionNone//类型
                           forView:_titleView
                             cache:NO];
    _titleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    [UIView setAnimationDelegate:self];//添加委托
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];// 实现回调
    [UIView commitAnimations];
}

- (CGAffineTransform)transformForOrientation
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation(M_PI*1.5);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation(M_PI/2);
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return CGAffineTransformMakeRotation(-M_PI);
    } else {
        return CGAffineTransformIdentity;
    }
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag context:(void *)context
{
//    _closeBtn.enabled = YES;
}

-(void)closeBtnClicked
{
    [_delegate closeClicked];
    [self removeFromSuperview];
}

#pragma mark -
#pragma mark Data Operation Method

-(void)upgradeStamina:(UpgradeInfo*) uInfo
{
    [UserStaminaView staminaChangedForLvUp:uInfo.currentLevel+1];
}

-(void)upgradeCoins:(UpgradeInfo*) uInfo
{
    UserInfoOC* selfUserInfo = [DataManager shareDataManager].self_UserInfo;
    selfUserInfo.goldCoin += uInfo.coinNum;
    [[DataManager shareDataManager].localDBManager updateData_UserInfo_Table:selfUserInfo tablename:@"userinfo3" operation:NO];
}

-(void)upgradeMusic:(UpgradeInfo*) uInfo
{
//    MusicInfoOC* info = [[DataManager shareDataManager].musicInfo_Dic objectForKey:uInfo.unlockMusicID];
//    if (info!= [NSNull] && info != nil) {
//        info.unlockLevel
//    }
}




- (void)dealloc
{
    self.delegate = nil;
    [_imageArray removeAllObjects];
    [_imageArray release];
    
    [_textArray removeAllObjects];
    [_textArray release];
    
    [_itemArray removeAllObjects];
    [_itemArray release];
    
    
    
    SNSLogFunction;
    [super dealloc];
}

@end
