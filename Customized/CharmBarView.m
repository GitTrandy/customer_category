//
//  CharmBarView.m
//  beatmasterSNS
//
//  Created by 刘旺 on 12-12-20.
//
//

#import "CharmBarView.h"
#import "MacroBMSns.h"
#import "Math.h"
#import "UserInfoOC.h"
#import "DataManager.h"


@implementation CharmBarView



@synthesize charmValueLabel = _charmValueLabel;
-(id)initWithFrame:(CGRect)frame withCharmViewType:(CharmViewType)type withCharmValue:(int)charmValue
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSString* bgImgName = @"";
        NSString* bgExName = @"";
        NSString* exName = @"";
        _wordColor = [UIColor colorWithRed:255.0f green:255.0f blue:204/255.0f alpha:255];
        _popularColor = [UIColor colorWithRed:255 green:102/255.0f blue:133/255.0f alpha:255];
        bgExName = @"Shop_charmExBg.png";
        exName = @"Shop_charmEx.png";
        switch (type) {
            case CharmView_ProFileType:
            {
                bgImgName = @"Profile_charmBar.png";
//                bgExName = @"Profile_charmExBg.png";
//                exName = @"Profile_charmEx.png";
//                _wordColor = [UIColor yellowColor];
//                _popularColor = [UIColor yellowColor];
            }
                break;
            case CharmView_ShopMailType:
            {
                bgImgName = @"Shop_charmBar.png";
                //                bgExName = @"Shop_charmExBg.png";
                //                exName = @"Shop_charmEx.png";
                //                _wordColor = [UIColor redColor];
                //                _wordColor = [UIColor colorWithRed:255.0f green:255.0f blue:204/255.0f alpha:255];
                //                _popularColor = [UIColor colorWithRed:255 green:102/255.0f blue:133/255.0f alpha:255];
            }
                break;
            case CharmView_PetType:
            {
                bgImgName = @"Pet_charmBar.png";
            }
                break;
            default:
                break;
        }
        _type = type;
        _bgView= [[UIImageView alloc] initWithImage:[UIImage imageNamed_New:bgImgName]];
        _bgView.frame = SNSRect(0, 0, _bgView.image.size.width*SNS_SCALE, _bgView.image.size.height*SNS_SCALE);
        [self addSubview:_bgView];
        
        _originCharmValue = charmValue;
        
        
        UserInfoOC* selfUserInfo = [DataManager shareDataManager].self_UserInfo;
        int flowersNum = MakeUnsignedInt(selfUserInfo.flowersNum);
        int eggsNum = MakeUnsignedInt(selfUserInfo.eggsNum);
        int popularInt = flowersNum - eggsNum;
//        int popularLV = [[Math sharedMath] calculatePopularLv:popularInt];
        int popularLV = [[Math sharedMath] calculateLevel:[Math sharedMath].array_popularitySumLV Value:popularInt];
        float popularAddition = [[Math sharedMath] calculateValue:[Math sharedMath].array_popularityAdditionLV Level:popularLV];
        int showPopularAddition = popularAddition*100-100;
        
        _showCharmValue = _originCharmValue*popularAddition;
        _popularLabel = [[UILabel alloc] init];
        [Utils autoTextSizeLabel:_popularLabel font:[UIFont boldSystemFontOfSize:10*SNS_SCALE]  labelAlign:AutoTextSizeLabelAlignCenter frame:SNSRect(60*SNS_SCALE, 31*SNS_SCALE , 50*SNS_SCALE, 10*SNS_SCALE) text:[NSString stringWithFormat:@"+%d%%",showPopularAddition] textColor:[UIColor colorWithRed:255 green:102/255.0f blue:133/255.0f alpha:255]];
        [self addSubview:_popularLabel];
        
        
        _exBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed_New:bgExName]];
        _exBgView.frame = SNSRect(24*SNS_SCALE, 16*SNS_SCALE, _exBgView.image.size.width*SNS_SCALE, _exBgView.image.size.height*SNS_SCALE);
        [self addSubview:_exBgView];
        
        CharmStruct* result = [self workOutCharmPercent:_showCharmValue withAdd:0];
        
        _exView = [[UIImageView alloc] initWithImage:[UIImage imageNamed_New:exName]];
        _exView.frame = SNSRect(24*SNS_SCALE, 16*SNS_SCALE, _exView.image.size.width*SNS_SCALE*result.charmPercent, _exView.image.size.height*SNS_SCALE);
        [self addSubview:_exView];
        
        
        int rankUpNum = 999999;
        for (int i = 0; i<[[Math sharedMath].array_charmLV count]; i++) {
            int rankUpInt = [([Math sharedMath].array_charmSumLV)[i] intValue];
            if (rankUpInt > _showCharmValue) {
                rankUpNum = rankUpInt;
                break;
            }
        }
        
        _charmValueLabel = [[UILabel alloc] init];
        NSString* _charmValueStr = nil;
        if (rankUpNum == 999999) {
            _charmValueStr = [NSString stringWithFormat:@"%d",_showCharmValue];
            _exBgView.hidden = YES;
            _exView.hidden = YES;
        }else
        {
            _charmValueStr = [NSString stringWithFormat:@"%d/%d",_showCharmValue,rankUpNum];
            _exBgView.hidden = NO;
            _exView.hidden = NO;
        }
        [Utils autoTextSizeLabel:_charmValueLabel font:[UIFont boldSystemFontOfSize:10*SNS_SCALE]  labelAlign:AutoTextSizeLabelAlignLeft frame:SNSRect(28*SNS_SCALE, 4*SNS_SCALE, 120*SNS_SCALE, 10*SNS_SCALE) text:_charmValueStr textColor:_popularColor];
        [self addSubview:_charmValueLabel];
        
        
        
        _lvLabel = [[UILabel alloc] init];
        [Utils autoTextSizeLabel:_lvLabel font:[UIFont systemFontOfSize:10*SNS_SCALE] labelAlign:AutoTextSizeLabelAlignCenter frame:SNSRect(12*SNS_SCALE, 10*SNS_SCALE, 10*SNS_SCALE, 10*SNS_SCALE) text:[NSString stringWithFormat:@"%d",result.charmLV] textColor:[UIColor whiteColor]];
        [self addSubview:_lvLabel];
        
        UILabel* popularWord = [[UILabel alloc] init];
        popularWord.frame = SNSRect(6*SNS_SCALE, 21*SNS_SCALE, 100*SNS_SCALE, 20*SNS_SCALE);
        popularWord.text = MultiLanguage(cbvLPopularAddition);
        popularWord.font = [UIFont boldSystemFontOfSize:8*SNS_SCALE];
        popularWord.backgroundColor = [UIColor clearColor];
        popularWord.textAlignment = UITextAlignmentLeft;
        popularWord.textColor = [UIColor whiteColor];
        [self addSubview:popularWord];
        [popularWord release];
        
        
        _directionView = [[UIImageView alloc] initWithImage:[UIImage imageNamed_New:@"Profile_charmUp.png"]];
        _directionView.frame = SNSRect(95*SNS_SCALE, 4*SNS_SCALE, _directionView.image.size.width*SNS_SCALE, _directionView.image.size.height*SNS_SCALE);
        [self addSubview:_directionView];
        _directionView.hidden =YES;
        
        
    }
    return self;
}

-(CharmStruct* )workOutCharmPercent:(int)oldCharmValue withAdd:(int) addCharmValue
{
    NSArray* charmLVArray = [Math sharedMath].array_charmLV;
    NSArray* charmSumLVArray = [Math sharedMath].array_charmSumLV;
    
    CharmStruct* tmpCharm = [[[CharmStruct alloc] init] autorelease];

    for (int i = 0; i<[charmSumLVArray count]; i++) {
        if ((oldCharmValue+addCharmValue) >= [charmSumLVArray[i] intValue]) {
            if (i == [charmSumLVArray count]-1) {
                tmpCharm.charmLV = i;
                tmpCharm.charmPercent = 1.0;
                break;
            }else if((oldCharmValue+addCharmValue) < [charmSumLVArray[i+1] intValue])
            {
                tmpCharm.charmLV = i;
                int result = oldCharmValue+addCharmValue-[charmSumLVArray[i] intValue];
                tmpCharm.charmPercent =  result/[charmLVArray[i+1] floatValue];
                break;
            }
        }
    }

    return tmpCharm;
}


-(void)replaceCharmValue:(int)newCharmValue
{
    if ((newCharmValue-_originCharmValue) > 0) {
        _directionView.image = [UIImage imageNamed_New:@"Profile_charmUp.png"];
        _directionView.frame = SNSRect(95*SNS_SCALE, 4*SNS_SCALE, _directionView.image.size.width*SNS_SCALE, _directionView.image.size.height*SNS_SCALE);
        _directionView.hidden = NO;
    }else if ((newCharmValue-_originCharmValue) <0)
    {
        _directionView.image = [UIImage imageNamed_New:@"Profile_charmDown.png"];
        _directionView.frame = SNSRect(95*SNS_SCALE, 4*SNS_SCALE, _directionView.image.size.width*SNS_SCALE, _directionView.image.size.height*SNS_SCALE);
        _directionView.hidden  = NO;
    }else
    {
        _directionView.hidden = YES;
    }
    
    _originCharmValue = newCharmValue;
    UserInfoOC* selfUserInfo = [DataManager shareDataManager].self_UserInfo;
    int flowersNum = MakeUnsignedInt(selfUserInfo.flowersNum);
    int eggsNum = MakeUnsignedInt(selfUserInfo.eggsNum);
    int popularInt = flowersNum - eggsNum;
//    int popularLV = [[Math sharedMath] calculatePopularLv:popularInt];
    int popularLV = [[Math sharedMath] calculateLevel:[Math sharedMath].array_popularitySumLV Value:popularInt];
    float popularAddition = [[Math sharedMath] calculateValue:[Math sharedMath].array_popularityAdditionLV Level:popularLV];
    int showPopularAddition = popularAddition*100-100;
    _showCharmValue = _originCharmValue*popularAddition;
    
    int rankUpNum = 999999;
    for (int i = 0; i<[[Math sharedMath].array_charmLV count]; i++) {
        int rankUpInt = [([Math sharedMath].array_charmSumLV)[i] intValue];
        if (rankUpInt > _showCharmValue) {
            rankUpNum = rankUpInt;
            break;
        }
    }

    NSString* _charmValueStr = nil;
    if (rankUpNum == 999999) {
        _charmValueStr = [NSString stringWithFormat:@"%d",_showCharmValue];
        _exBgView.hidden = YES;
        _exView.hidden = YES;
    }else
    {
        _charmValueStr = [NSString stringWithFormat:@"%d/%d",_showCharmValue,rankUpNum];
        _exBgView.hidden = NO;
        _exView.hidden = NO;
    }

    [Utils autoTextSizeLabel:_charmValueLabel font:[UIFont boldSystemFontOfSize:10*SNS_SCALE]  labelAlign:AutoTextSizeLabelAlignLeft frame:SNSRect(28*SNS_SCALE, 4*SNS_SCALE, 120*SNS_SCALE, 10*SNS_SCALE) text:_charmValueStr textColor:_popularColor];
    
    [Utils autoTextSizeLabel:_popularLabel font:[UIFont boldSystemFontOfSize:10*SNS_SCALE]  labelAlign:AutoTextSizeLabelAlignCenter frame:SNSRect(57*SNS_SCALE, 32*SNS_SCALE , 50*SNS_SCALE, 10*SNS_SCALE) text:[NSString stringWithFormat:@"+%d%%",showPopularAddition] textColor:_popularColor];
    CharmStruct* result = [self workOutCharmPercent:_showCharmValue withAdd:0];
    _lvLabel.text = [NSString stringWithFormat:@"%d",result.charmLV];
    _exView.frame = SNSRect(24*SNS_SCALE, 16*SNS_SCALE, _exView.image.size.width*SNS_SCALE*result.charmPercent, _exView.image.size.height*SNS_SCALE);
    

    
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    SNSLogFunction;
    int    popType;
    int    animationType;
    NSString* charmTypeName = nil;
    NSString* popularTypeName = nil;
    UIColor *color = nil;
    NSString* sureBtnNormal = nil;
    NSString* sureBtnHighlight = nil;
    switch (_type) {
        case CharmView_ProFileType:
            popType = PopMsgViewStyleBlue;
            animationType = EMBT_Profile;
            charmTypeName = @"ShoppingMall_Cart_Heart.png";
            popularTypeName = @"PopularFlower01.png";
            color = [UIColor whiteColor];
            sureBtnNormal = @"Com_PMV_sBtn03_3.png";
            sureBtnHighlight = @"Com_PMV_sBtn03_4.png";
            color =  SNS_TEXTCOLOR_PROFILE_NEW;
            break;
        case CharmView_ShopMailType:
            popType = PopMsgViewStyleRed;
            animationType = EMBT_ShoppingMall;
            charmTypeName = @"ShoppingMall_Cart_Heart.png";
            popularTypeName = @"PopularFlower01.png";
            color = [UIColor colorWithRed:208/255.0 green:149/255.0 blue:160/255.0 alpha:1.0];
            sureBtnNormal = @"Com_PMV_sBtn04_3@2x.png";
            sureBtnHighlight = @"Com_PMV_sBtn04_4@2x.png";
        case CharmView_PetType:
        {
            popType = PopMsgViewStyleYellow;
            animationType = EMBT_Profile;
            charmTypeName = @"ShoppingMall_Cart_Heart.png";
            popularTypeName = @"PopularFlower02.png";
            color = [UIColor whiteColor];
            sureBtnNormal = @"Com_PMV_sBtn03_3.png";
            sureBtnHighlight = @"Com_PMV_sBtn03_4.png";
            color =  SNSColorMake(211.0f, 198.0f, 146.0f, 1.0f);
        }
            break;
        default:
            break;
    }
    _popMsgView = [PopMessageView createPopMsgViewWithStyle:popType];
    _popMsgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _popMsgView.messageLabel.text = @"";
    
    
    
    _popMsgView.leftBtn.frame = SNSRect(_popMsgView.messageBgView.frame.size.width/2-_popMsgView.leftBtn.frame.size.width/2, 145*SNS_SCALE, _popMsgView.leftBtn.frame.size.width, _popMsgView.leftBtn.frame.size.height);
    [_popMsgView.leftBtn setHidden:YES];
    
    [_popMsgView.leftBtn setBackgroundImage:[UIImage imageNamed_New:sureBtnNormal] forState:UIControlStateNormal];
    [_popMsgView.leftBtn setBackgroundImage:[UIImage imageNamed_New:sureBtnHighlight] forState:UIControlStateHighlighted];
    _popMsgView.leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 2, 0);
    
    [_popMsgView.leftBtn setTitle:MultiLanguage(cbvBSure) forState:UIControlStateNormal];
    [_popMsgView.rightBtn setHidden:YES];
    
    UIImageView* charmHeart = [[UIImageView alloc] initWithImage:[UIImage imageNamed_New:charmTypeName]];
    charmHeart.frame = SNSRect(_popMsgView.messageBgView.frame.size.width/2-127*SNS_SCALE, 39*SNS_SCALE, charmHeart.image.size.width*SNS_SCALE, charmHeart.image.size.height*SNS_SCALE);
    [_popMsgView.messageBgView addSubview:charmHeart];
    [charmHeart release];
    
    UILabel* wordLabel1 = [[UILabel alloc] initWithFrame:SNSRect(_popMsgView.messageBgView.frame.size.width/2-110*SNS_SCALE, 40*SNS_SCALE, 250*SNS_SCALE, 15*SNS_SCALE)];
    wordLabel1.text = MultiLanguage(cbvLWord1);
    wordLabel1.backgroundColor = [UIColor clearColor];
    wordLabel1.textColor = color;
    wordLabel1.font = [UIFont boldSystemFontOfSize:12*SNS_SCALE];
    [_popMsgView.messageBgView addSubview:wordLabel1];
    [wordLabel1 release];
    
    UILabel* wordLabel2 = [[UILabel alloc] initWithFrame:SNSRect(_popMsgView.messageBgView.frame.size.width/2-125*SNS_SCALE,55*SNS_SCALE, 250*SNS_SCALE, 30*SNS_SCALE)];
    wordLabel2.numberOfLines = 2;
    wordLabel2.text = MultiLanguage(cbvLWord2);
    wordLabel2.backgroundColor = [UIColor clearColor];
    wordLabel2.textColor = color;
    wordLabel2.font = [UIFont systemFontOfSize:10*SNS_SCALE];
    [_popMsgView.messageBgView addSubview:wordLabel2];
    [wordLabel2 release];
    
    
    UIImageView* popularFlower = [[UIImageView alloc] initWithImage:[UIImage imageNamed_New:popularTypeName]];
    popularFlower.frame = SNSRect(_popMsgView.messageBgView.frame.size.width/2-125*SNS_SCALE, 87*SNS_SCALE, popularFlower.image.size.width*SNS_SCALE, popularFlower.image.size.height*SNS_SCALE);
    [_popMsgView.messageBgView addSubview:popularFlower];
    [popularFlower release];
    
    UILabel* wordLabel3 = [[UILabel alloc] initWithFrame:SNSRect(_popMsgView.messageBgView.frame.size.width/2-110*SNS_SCALE,90*SNS_SCALE, 250*SNS_SCALE, 15*SNS_SCALE)];
    wordLabel3.text = MultiLanguage(cbvLWord3);
    wordLabel3.backgroundColor = [UIColor clearColor];
    wordLabel3.textColor = color;
    wordLabel3.font = [UIFont boldSystemFontOfSize:12*SNS_SCALE];
    [_popMsgView.messageBgView addSubview:wordLabel3];
    [wordLabel3 release];
    
    UILabel* wordLabel4 = [[UILabel alloc] initWithFrame:SNSRect(_popMsgView.messageBgView.frame.size.width/2-125*SNS_SCALE,105*SNS_SCALE, 250*SNS_SCALE, 30*SNS_SCALE)];
    wordLabel4.numberOfLines = 2;
    wordLabel4.text = MultiLanguage(cbvLWord4);
    wordLabel4.backgroundColor = [UIColor clearColor];
    wordLabel4.textColor = color;
    wordLabel4.font = [UIFont systemFontOfSize:10*SNS_SCALE];
    [_popMsgView.messageBgView addSubview:wordLabel4];
    [wordLabel4 release];
    
    _popMsgView.delegate = self;
    if (_type == CharmView_ProFileType)
    {
        [self.superview addSubview:_popMsgView];
    }
    else if(_type == CharmView_ShopMailType)
    {
        [self.superview.superview addSubview:_popMsgView];
    }
    else if(_type == CharmView_PetType)
    {
        [self.superview.superview addSubview:_popMsgView];
    }
    
    [_popMsgView startAnimationWithType:animationType];
    
}


-(void)didCloseBtnClick:(id)sender
{
    SNSLogFunction;
    [_popMsgView removeFromSuperview];
}


-(void)didLeftBtnClick:(id)sender
{
    SNSLogFunction;
    [_popMsgView removeFromSuperview];
}

-(void)didRightBtnClick:(id)sender
{
    SNSLogFunction;
}

- (void)dealloc
{
    SNSLog(@"%s",__FUNCTION__);
    [_bgView release];
    [_exBgView release];
    [_exView release];
    [_lvLabel release];
    [_charmValueLabel release];
    [_popularLabel release];
    [_directionView release];
    [super dealloc];
}

@end


@implementation CharmStruct

@synthesize charmLV=_charmLV,charmPercent = _charmPercent;

- (id)init
{
    self = [super init];
    if (self) {
        _charmLV = 0;
        _charmPercent = 0;
    }
    return self;
}

- (void)dealloc
{
    
    [super dealloc];
}

@end
