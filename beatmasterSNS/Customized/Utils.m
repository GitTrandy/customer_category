//
//  Utils.m
//  beatmasterSNS
//
//  Created by  on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"
#import "SoundComDef.h"
#import "UserDefaultsManager.h"


@implementation Utils

-(id)init{
    
    if ( (self=[super init]))
    {
    }
    
    return self;
}

-(void) dealloc{
    
    [super dealloc];
}

static Utils* g_UtilsInstance=nil;
+(Utils*)shareUtils{
    
    if (nil==g_UtilsInstance)
    {
        g_UtilsInstance = [[Utils alloc] init];
    }
    
    return g_UtilsInstance;
}

+(void)purgeShareUtils{
    
    if (nil!=g_UtilsInstance)
    {
        [g_UtilsInstance release];
        g_UtilsInstance = nil;
    }
}

+ (id)findFirstObjMemberOfClassName:(NSString *)className inArray:(NSArray *)array
{
    if (!className || !array) 
    {
        return nil;
    }
    for (id obj in array) 
    {
        Class class = NSClassFromString(className);
        if ([obj isMemberOfClass:class]) 
        {
            return obj;
        }
    }
    return nil;
}

+ (NSArray *)findSubviewsKindOfClassName:(NSString *)className inView:(UIView *)view
{
    NSMutableArray* array = [NSMutableArray array];
    
    if ([view isKindOfClass:NSClassFromString(className)]) 
    {
        [array addObject:view];
    }
    
    for (UIView* subview in [view subviews]) 
    {
        [array addObjectsFromArray:[self findSubviewsMemberOfClassName:className inView:subview]];
        
    }
    
    return array;
}

+ (NSArray *)findSubviewsMemberOfClassName:(NSString *)className inView:(UIView *)view
{
    
    NSMutableArray* array = [NSMutableArray array];
    
    if ([view isMemberOfClass:NSClassFromString(className)]) 
    {
        [array addObject:view];
    }
    
    for (UIView* subview in [view subviews]) 
    {
        [array addObjectsFromArray:[self findSubviewsMemberOfClassName:className inView:subview]];
        
    }
    
    return array;
}

/**
 *  @brief  自动适应Text内容大小的Label，具有左对齐 居中 右对齐功能
 *  @param
 *      labelName : 被调整的Label
 *      font      : text字体
 *      labelAlign: 整个Label相对其父视图的对齐方式
 *      frame     : Label相对的对齐点位置以及允许的最大高度与宽度(origin:对齐点位置，size:最大高度与宽度)
 *      text      : Label字内容
 *      textColor : 字体颜色
 */
+ (void) autoTextSizeLabel:(UILabel *)labelName font:(UIFont *)font labelAlign:(AutoTextSizeLabelAlign)align frame:(CGRect)rect text:(NSString *)text textColor:(UIColor *)color
{
    labelName.backgroundColor = [UIColor clearColor];
    labelName.font = font;
    labelName.numberOfLines = 0;
    labelName.text = text;
    labelName.textColor = color;
    labelName.textAlignment = NSTextAlignmentLeft;
    labelName.lineBreakMode = NSLineBreakByCharWrapping;
    
    CGSize labelSize = [labelName.text sizeWithFont:labelName.font constrainedToSize:CGSizeMake(rect.size.width, rect.size.height) lineBreakMode:NSLineBreakByCharWrapping];
    switch (align)
    {
        case AutoTextSizeLabelAlignLeft:
            labelName.frame = CGRectMake(rect.origin.x, rect.origin.y, labelSize.width, labelSize.height);
            break;
        case AutoTextSizeLabelAlignCenter:
            labelName.frame = CGRectMake(rect.origin.x - labelSize.width/2.0f, rect.origin.y - labelSize.height/2.0f, labelSize.width, labelSize.height);
            break;
        case AutoTextSizeLabelAlignRight:
            labelName.frame = CGRectMake(rect.origin.x - labelSize.width, rect.origin.y, labelSize.width, labelSize.height);
            break;
        case AutoTextSizeLabelAlignLeftXCenterY:
            labelName.frame = CGRectMake(rect.origin.x, rect.origin.y - labelSize.height/2.0f, labelSize.width, labelSize.height);
            break;
            
        default:
            labelName.frame = rect;
            break;
    }
}


//*************************************//
// //           数字view加载          // //
// // mainView:整个数字view           // //
// // num: 数字                      // //
// // align:数字对齐方式               // //
// // numType:数字的美术图片分类        // //
// // frame:数字按对齐方式固定的那个点位置 // //
+(void)createNumView:(UIImageView *)mainView number:(float)num decimal:(int)decimal percent:(BOOL)percent align:(NumAlign)align numType:(NumType)numType frame:(CGRect)frame margin:(int)margin
{
    SNSLog(@"Num=%f",num);
    int count = 0;  // // 数字长度
    float numWidth = 0.0f; // // 数字宽度
    float numHeight = 0.0f; // // 数字高度
    float numFloat = num;       // // 待显示数字
    if (decimal != 0)
    {
        for (int i=0; i<decimal; i++)
        {
            numFloat *= 10;
        }
    }
    int numTmp = (int)numFloat;  // // 小数转化为整数处理
    
    NSString *typeStr = nil;
    
    // // 数字类型  数字宽度/高度
    switch (numType)
    {
        case NumTypeBattleRound:
            typeStr = @"BattleRound";// // 局数
            break;
        case NumTypeBattleScore:
            typeStr = @"BattleScore";// // 得分分数
            break;
        case NumTypeBattleResult:
            typeStr = @"BattleResult";// // 游戏结果
            break;
        case NumTypePlayResult:
            typeStr = @"result_num1";
            break;
            
        default:
            typeStr = @"BattleResult";
            break;
    }
    UIImage *numImg = [UIImage imageNamed_New:[NSString stringWithFormat:@"%@_00.png",typeStr]];
    numWidth = numImg.size.width*SNS_SCALE ;//* 0.5;
    numHeight = numImg.size.height*SNS_SCALE;
    SNSLog(@"NumWidth=%.1f",numWidth);
    
    
    // // 适配目的 margin乘以系数
    margin = margin * SNS_SCALE;
    // // 数字长度
    int countPoint = 0;   // // 小数点占位置
    int countPercent = 0; // // ％号占位置
    if (decimal != 0)
    {
        countPoint = 1;
    }
    if (percent)
    {
        countPercent = 1;
    }
    do
    {
        numTmp /= 10 ;
        count++;
    } while (numTmp != 0);
    count = count + countPoint + countPercent;
    
    // // 数字加载位置
    numTmp = (int)numFloat;
    for (int i=0; i<count; i++)
    {
        if (percent && i==0)
        {
            UIImageView *percentView = [[UIImageView alloc]initWithImage:[UIImage imageNamed_New:[NSString stringWithFormat:@"%@_percent.png",typeStr]]];
            percentView.frame = CGRectMake((count-1-i)*(numWidth-2*margin)-margin, 0, numWidth, numHeight);
            [mainView addSubview:percentView];
            [percentView release];
            percentView = nil;
            
            continue;
        }
        if (decimal!=0 && i==(decimal+countPercent)) {
            UIImageView *pointView = [[UIImageView alloc]initWithImage:[UIImage imageNamed_New:[NSString stringWithFormat:@"%@_point.png",typeStr]]];
            pointView.frame = CGRectMake((count-1-i)*(numWidth-2*margin)-margin, 0, numWidth, numHeight); // // 小数点在图片的中间，调整高度
            [mainView addSubview:pointView];
            [pointView release];
            pointView = nil;
            
            continue;
        }
        
        int gotNum = numTmp % 10;
        UIImageView *numView = [[UIImageView alloc]initWithImage:[UIImage imageNamed_New:[NSString stringWithFormat:@"%@_%02d.png",typeStr,gotNum]]];
        numView.frame = CGRectMake((count-1-i)*(numWidth-2*margin)-margin, 0, numWidth, numHeight);
        [mainView addSubview:numView];
        [numView release];
        numView = nil;
        numTmp /= 10;
        SNSLog(@"xxx=%.1f",(count-1-i)*(numWidth-2*margin)-margin);
    }
    
    // // 设置mainView的位置
    switch (align)
    {
        case NumAlignLeft:
            mainView.frame = CGRectMake(frame.origin.x, frame.origin.y, count*(numWidth-2*margin), numHeight);
            break;
        case NumAlignCenter:
            mainView.frame = CGRectMake(frame.origin.x-(count*(numWidth-2*margin))/2, frame.origin.y, count*(numWidth-2*margin), numHeight);
            break;
        case NumAlignRight:
            mainView.frame = CGRectMake(frame.origin.x-count*(numWidth-2*margin), frame.origin.y, count*(numWidth-2*margin), numHeight);
            break;
            
        default:
            mainView.frame = frame;
            break;
    }
    SNSLog(@"width=%.1f",count*(numWidth-2*margin));
}


-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    
}

+ (void) cocos2dDirectorVC{
    
    
    /*
    // 在进入游戏页面前暂停UI背景音乐
    PauseUIMusic();
    
    // 在进入游戏中暂停talkData
    [SNSUDataAnalyzer suspendRequest];
    
    CCDirectorIOS* director_ = nil;
    
    if (NULL == [[CCDirector sharedDirector] view]) {
        // Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
        CCGLView *glView = [CCGLView viewWithFrame:SCREEN_FRAME
                                       pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
                                       depthFormat:0	//GL_DEPTH_COMPONENT24_OES
                                preserveBackbuffer:NO
                                        sharegroup:nil
                                     multiSampling:NO
                                   numberOfSamples:0];
        
        [glView setMultipleTouchEnabled:YES];
        
        director_ = (CCDirectorIOS*) [CCDirector sharedDirector];
        
        director_.wantsFullScreenLayout = YES;
        
        
#if !defined(TEST_ENV_STAGING) && !defined(TEST_ENV_QA) && !defined(TEST_ENV_PRODUCTION)
        // Display FSP and SPF
        [director_ setDisplayStats:YES];
#else
        // Display FSP and SPF
        [director_ setDisplayStats:NO];
#endif
        
        // set FPS at 60
        [director_ setAnimationInterval:1.0/60];
        
        // attach the openglView to the director
        [director_ setView:glView];
        
        // for rotation and other messages
        [director_ setDelegate:[Utils shareUtils]];
        
        // 2D projection
        [director_ setProjection:kCCDirectorProjection2D];
        
        // Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
        if( ! [director_ enableRetinaDisplay:YES] )
            CCLOG(@"Retina Display Not supported");
        
        //[director_ setContentScaleFactor:2.f];
        
    }
    else {
        director_ = (CCDirectorIOS*) [CCDirector sharedDirector];
    }
     
    assert(director_);
    return director_;
     
     */
    
}


+(ActionItemParallel*) createViewAnimationWithViewArray:(NSArray *)viewArray
{
    // 创建对话框动画，viewArray是所有需要遍历做动画的view的数组，第一个数组元素是背景框，要做横向拉伸的那个
    ActionItemParallel* viewAction = [ActionItemParallel actionItemParallel];
    
    for (int i=0; i<[viewArray count]; i++)
    {
        UIView* view = [viewArray objectAtIndex:i];
        if (0==i)
        {
            [view setHidden:YES];
            ScaleAction* bgAction = [ScaleAction action:ECT_Y target:view duration:0.2f fromValue:0.1f toValue:1.f];
            ActionItem* bgItem = [ActionItem actionItemsRepeatCount:1 beginTime:0.0f actionItems:bgAction, nil];
            [viewAction addActionItem:bgItem];
        }
        
        for (UIView* subView in [view subviews])
        {
            if (YES==[subView isHidden])
            {
                //已经隐藏的就不做动做了
                continue;
            }
            
            [subView setHidden:YES];
            OpacityAction* action = [OpacityAction action:subView duration:0.3f fromValue:0.f toValue:1.f];
            
            if ([subView isKindOfClass:NSClassFromString(@"UIButton")])
            {
                
                ActionItem* btnItems = [ActionItem actionItemRepeatCount:1 beginTime:0.4f];
                [btnItems addAction:action];
                
                [viewAction addActionItem:btnItems];
            }
            else
            {
                ActionItem* otherItems = [ActionItem actionItemRepeatCount:1 beginTime:0.2f];
                [otherItems addAction:action];
                
                [viewAction addActionItem:otherItems];
            }
        }
    }
    
    return viewAction;
}

+(ActionItemParallel*) createViewAnimationWithView:(UIView *)view bgColorView:(UIView*)bgColorView bgImageView:(UIView*)bgView bgType:(MainVcBgType)type isForeachBgImageView:(bool)isForeachBgImageView{
    
    NSString* str = nil;
    switch (type) {
        case EMBT_Practice:
        case EMBT_BattleNotice:
        case EMBT_Club:
        case EMBT_Profile:
        case EMBT_ShoppingMall:
            str = [NSString stringWithFormat:@"PopDlgAni_001.png"];
            break;
            
        default:
            str = [NSString stringWithFormat:@"PopDlgAni_001.png"];
            break;
    }
    
    //闪光动画
//    UIImageView* lightAni = [[UIImageView alloc] initWithImage:[UIImage imageNamed_New:str]];
//    lightAni.center = bgView.center;
//    [view addSubview:lightAni];
//    [lightAni release];
//    [lightAni setHidden:YES];
//    
//    ScaleAction* lightAction1 = [ScaleAction action:ECT_Y target:lightAni duration:0.3f fromValue:1.2f toValue:0.1f];
//    ScaleAction* lightAction2 = [ScaleAction action:ECT_X target:lightAni duration:0.2f fromValue:1.f toValue:4.f];
//    OpacityAction* lightAction3 = [OpacityAction action:lightAni duration:0.2f fromValue:1.f toValue:0.f];
//    ActionItem* lightItem1 = [ActionItem actionItemsRepeatCount:1 beginTime:0.f actionItems:lightAction1, nil];
//    ActionItem* lightItem2 = [ActionItem actionItemsRepeatCount:1 beginTime:0.f actionItems:lightAction2, lightAction3, nil];
    
    ActionItemParallel* viewAction = [ActionItemParallel actionItemParallel];
    //    [viewAction addActionItem:lightItem1];
    //    [viewAction addActionItem:lightItem2];
    
    //背景动画
    if (nil!=bgColorView)
    {
        [bgColorView setAlpha:0.f];
        OpacityAction* bgColorAction = [OpacityAction action:bgColorView duration:0.2f fromValue:0.f toValue:0.7f];
        ActionItem* bgColorItem = [ActionItem actionItemsRepeatCount:1 beginTime:0.f actionItems:bgColorAction, nil];
        [viewAction addActionItem:bgColorItem];
    }
    
    [bgView setHidden:YES];
    ScaleAction* bgAction = [ScaleAction action:ECT_Y target:bgView duration:0.2f fromValue:0.1f toValue:1.f];
    ActionItem* bgItem = [ActionItem actionItemsRepeatCount:1 beginTime:0.0f actionItems:bgAction, nil];
    [viewAction addActionItem:bgItem];
    
    //其它动画
    UIView* findview = view;
    if (isForeachBgImageView)
        findview = bgView;
    
    for (UIView* subView in [findview subviews])
    {
        if (YES==[subView isHidden])
        {
            //已经隐藏的就不做动做了
            continue;
        }
        
        if (subView==bgColorView)
        {
            //已经做过动作了
            continue;
        }
        
        [subView setHidden:YES];
        OpacityAction* action = [OpacityAction action:subView duration:0.3f fromValue:0.f toValue:1.f];
        
        if ([subView isKindOfClass:NSClassFromString(@"UIButton")])
        {
            
            ActionItem* btnItems = [ActionItem actionItemRepeatCount:1 beginTime:0.4f];
            [btnItems addAction:action];
            
            [viewAction addActionItem:btnItems];
        }
        else
        {
            ActionItem* otherItems = [ActionItem actionItemRepeatCount:1 beginTime:0.2f];
            [otherItems addAction:action];
            
            [viewAction addActionItem:otherItems];
        }
    }
    
    return viewAction;
}


//*****************************//
// //     成就徽章信息        // //
// // 1、获取所有徽章信息      // //
// // 2、获取某个信息的徽章名称 // //
static NSDictionary * s_achievementDict = nil;
+ (NSDictionary *)doGetAllAchievementInfoFromPlist
{
    if (s_achievementDict == nil)
    {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"AchievementInfoDetail.plist" ofType:nil];
        if (path == nil)
        {
            return nil;
        }
        s_achievementDict = [[NSDictionary alloc]initWithContentsOfFile:path];
        if (s_achievementDict == nil)
        {
            return nil;
        }
        
    }
    return s_achievementDict;
    
}
+(NSString *)doGetAchievementName:(NSString *)achievementID
{
    NSString *achievementName = MultiLanguage(uNDefaultAchievementName);
    
    if (achievementID == nil)
    {
        return achievementName;
    }
    if (s_achievementDict == nil)
    {
        [self doGetAllAchievementInfoFromPlist];
    }
    if (s_achievementDict == nil)
    {
        return achievementName;
    }
    NSDictionary *infoDict = s_achievementDict[achievementID];
    if (infoDict == nil)
    {
        return achievementName;
    }
    
    NSString *name = infoDict[@"ACHIEVEMENTNAME"];
    if (name != nil)
    {
        achievementName = name;
    }
    return achievementName;
}




//*****************************//
// //     技术等级信息         // //
// // 1、获取所有技术信息       // //
// // 2、获取给定等级需要的经验  // //
// // 3、获取给定等级需要的总经验 // //
static NSDictionary * s_techLevelInfoDict = nil;
static NSDictionary * s_charmLevelInfoDict = nil;
static NSDictionary * s_intimateLevelInfoDict = nil;
static NSDictionary * s_friendLevelInfoDict = nil;
static NSDictionary * s_popularLevelInfoDict = nil;
+ (NSDictionary*)doGetAllLevelInfoFromPlist:(PlistInfoType)type
{
    switch (type)
    {
        case PlistInfoType_Tech:
            // // 技术等级 经验
            if (s_techLevelInfoDict == nil)
            {
                //NSString *path = [[NSBundle mainBundle]pathForResource:@"TechLevelValues.plist" ofType:nil];
                NSString *path = [[DataManager shareDataManager].localFileManager.plistRes_Path stringByAppendingPathComponent:@"TechLevelValues.plist"];
                if (path == nil)
                {
                    return nil;
                }
                s_techLevelInfoDict = [[NSDictionary alloc]initWithContentsOfFile:path];
                if (s_techLevelInfoDict == nil)
                {
                    return nil;
                }
                
            }
            return s_techLevelInfoDict;
            break;
        case PlistInfoType_Charm:
            // // 魅力等级 经验
            if (s_charmLevelInfoDict == nil)
            {
                //NSString *path = [[NSBundle mainBundle]pathForResource:@"CharmLevelValues.plist" ofType:nil];
                NSString *path = [[DataManager shareDataManager].localFileManager.plistRes_Path stringByAppendingPathComponent:@"CharmLevelValues.plist"];
                if (path == nil)
                {
                    return nil;
                }
                s_charmLevelInfoDict = [[NSDictionary alloc]initWithContentsOfFile:path];
                if (s_charmLevelInfoDict == nil)
                {
                    return nil;
                }
                
            }
            return s_charmLevelInfoDict;
            break;
        case PlistInfoType_intimacy:
            // // 亲密度 婚姻称号
            if (s_intimateLevelInfoDict == nil)
            {
                //NSString *path = [[NSBundle mainBundle]pathForResource:@"IntimateLevelValues.plist" ofType:nil];
                NSString *path = [[DataManager shareDataManager].localFileManager.plistRes_Path stringByAppendingPathComponent:@"IntimateLevelValues.plist"];
                if (path == nil)
                {
                    return nil;
                }
                s_intimateLevelInfoDict = [[NSDictionary alloc]initWithContentsOfFile:path];
                if (s_intimateLevelInfoDict == nil)
                {
                    return nil;
                }
                
            }
            return s_intimateLevelInfoDict;
            break;
            
        case PlistInfoType_Friend:
            // // 亲密度 婚姻称号
            if (s_friendLevelInfoDict == nil)
            {
                //NSString *path = [[NSBundle mainBundle]pathForResource:@"FriendLevelValues.plist" ofType:nil];
                NSString *path = [[DataManager shareDataManager].localFileManager.plistRes_Path stringByAppendingPathComponent:@"FriendLevelValues.plist"];
                if (path == nil)
                {
                    return nil;
                }
                s_friendLevelInfoDict = [[NSDictionary alloc]initWithContentsOfFile:path];
                if (s_friendLevelInfoDict == nil)
                {
                    return nil;
                }
                
            }
            return s_friendLevelInfoDict;
            break;
            
        case PlistInfoType_Popular:
            // // 人气Level PopularLevelValues
            if (s_popularLevelInfoDict == nil)
            {
                //NSString *path = [[NSBundle mainBundle]pathForResource:@"PopularLevelValues.plist" ofType:nil];
                NSString *path = [[DataManager shareDataManager].localFileManager.plistRes_Path stringByAppendingPathComponent:@"PopularLevelValues.plist"];
                if (path == nil)
                {
                    return nil;
                }
                s_popularLevelInfoDict = [[NSDictionary alloc]initWithContentsOfFile:path];
                if (s_popularLevelInfoDict == nil)
                {
                    return nil;
                }
                
            }
            return s_popularLevelInfoDict;
            
        default:
            break;
    }
    
    return nil;
    
}

/*
 *  @brief: 获取某个等级的 数值信息
 */
+ (NSDictionary *)doGetInfoDictWithType:(PlistInfoType)type withLevel:(int)level
{
    NSDictionary *allInfoDict = nil;
    switch (type)
    {
        case PlistInfoType_Tech:
            if (s_techLevelInfoDict == nil)
            {
                s_techLevelInfoDict = [self doGetAllLevelInfoFromPlist:type];
            }
            allInfoDict = s_techLevelInfoDict;
            break;
        case PlistInfoType_Charm:
            if (s_charmLevelInfoDict == nil)
            {
                s_charmLevelInfoDict = [self doGetAllLevelInfoFromPlist:type];
            }
            allInfoDict = s_charmLevelInfoDict;
            break;
        case PlistInfoType_intimacy:
            if (s_intimateLevelInfoDict == nil)
            {
                s_intimateLevelInfoDict = [self doGetAllLevelInfoFromPlist:type];
            }
            allInfoDict = s_intimateLevelInfoDict;
            break;
            
        case PlistInfoType_Friend:
            if (s_friendLevelInfoDict == nil)
            {
                s_friendLevelInfoDict = [self doGetAllLevelInfoFromPlist:type];
            }
            allInfoDict = s_friendLevelInfoDict;
            break;
            
        case PlistInfoType_Popular:
            if (s_popularLevelInfoDict == nil)
            {
                s_popularLevelInfoDict = [self doGetAllLevelInfoFromPlist:type];
            }
            allInfoDict = s_popularLevelInfoDict;
            break;
            
        default:
            break;
    }
    if (allInfoDict == nil)
    {
        return nil;
    }
    NSDictionary *infoDict = allInfoDict[[NSString stringWithFormat:@"%d",level]];
    return infoDict;
}

/*
 *  @brief: 获取完成某个等级所需要的经验
 */
+ (float)doGetNeedPointsWithType:(PlistInfoType)type withLevel:(int)level
{
    float needPoints = -1.0f;
    NSDictionary *infoDict = [self doGetInfoDictWithType:type withLevel:level];
    if (infoDict != nil)
    {
        NSString *needPointsStr = infoDict[@"NeedPoints"];
        needPoints = [needPointsStr floatValue];
    }
    
    return needPoints;
}
/*
 *  @brief: 获取完成某个等级所需要的总经验
 */
+ (float)doGetTotalPointsWithType:(PlistInfoType)type withLevel:(int)level
{
    float totalPoints = -1.0f;
    NSDictionary *infoDict = [self doGetInfoDictWithType:type withLevel:level];
    if (infoDict != nil)
    {
        NSString *totalPointsStr = infoDict[@"TotalPoints"];
        totalPoints = [totalPointsStr floatValue];
    }
    
    return totalPoints;
}

//*********************//
// //   生成Plist   // //
+ (void)CreatePlistWithcsvFile:(NSString *)csvFile
{
    NSMutableDictionary *plistDict = [NSMutableDictionary dictionary];
    NSError* error;
    NSString *srcPath = [[NSBundle mainBundle]resourcePath];
    NSString *filePath = [srcPath stringByAppendingPathComponent:csvFile];
    if (filePath == nil)
    {
        return;
    }
    NSString *fileStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    if (fileStr == nil)
    {
        SNSLog(@"Error reading text file. %@", [error localizedFailureReason]);
    }
    NSArray *lines = [fileStr componentsSeparatedByString:@"\n"];
    for (int i  = 0; i<[lines count]; i++) 
    {
        
        if (![lines[i] isEqual:@" "]) {
            NSArray* tmp = [lines[i] componentsSeparatedByString:@","];
            NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
//            [dic setObject:[tmp objectAtIndex:1] forKey:@"IntimateName"];
//            SNSLog(@"%d = %@",i,[tmp objectAtIndex:1]);
//            [dic setObject:[tmp objectAtIndex:2] forKey:@"IntimateLogoName"];
            dic[@"NeedPoints"] = tmp[1];
            
            dic[@"TotalPoints"] = tmp[2];
            plistDict[tmp[0]] = dic;
            [dic release];
        }
    }
    NSString *plistPath = [srcPath stringByAppendingPathComponent:@"TechLevelValues.plist"];
    SNSLog(@"plistPath = %@",plistPath);
    [plistDict writeToFile:plistPath atomically:YES];
}



//**************************************//
// // 设置网络请求运行状态显示内容         // //
// // netStatusView: 所要设置的弹出框   // //
// // type         : 弹出框状态        // //
// // text         : 弹出框要显示的内容 // //
// // delay        : 多少时间之后隐藏   // //
+(void)doChangeNetStatusView:(MBProgressHUD *)netStatusView type:(NetStatusType)type displayText:(NSString *)text hideAfterdelay:(float)delay
{
    if (netStatusView == nil || ![netStatusView isKindOfClass:[MBProgressHUD class]])
    {
        return;
    }
    [netStatusView show:YES];
    
    UIImage *successImg = [UIImage imageNamed_New:@"Com_netRequestSuccess.png"];
    UIImage *falseImg = [UIImage imageNamed_New:@"Com_netRequestfalse.png"];
    UIImage *netErrorImg = [UIImage imageNamed_New:@"Com_netRequestError.png"];
    switch (type)
    {
        case NetStatusTypeLoading:
            netStatusView.mode = MBProgressHUDModeIndeterminate;
            if (text != nil)
            {
                netStatusView.labelText = text;
            }
            else
            {
                netStatusView.labelText = MultiLanguage(uLSending);
            }
            break;
            
        case NetStatusTypeSuccess:
            netStatusView.mode = MBProgressHUDModeCustomView;
            netStatusView.customView = [[[UIImageView alloc]initWithImage:successImg]autorelease];
            if (text != nil)
            {
                netStatusView.labelText = text;
            }
            else
            {
                netStatusView.labelText = MultiLanguage(uLSendSuccess);
            }
            break;
            
        case NetStatusTypeFalse:
            netStatusView.mode = MBProgressHUDModeCustomView;
            netStatusView.customView = [[[UIImageView alloc]initWithImage:falseImg]autorelease];
            if (text != nil)
            {
                netStatusView.labelText = text;
            }
            else
            {
                netStatusView.labelText = MultiLanguage(uLSendFailed);
            }
            break;
            
        case NetStatusTypeNetError:
            netStatusView.mode = MBProgressHUDModeCustomView;
            netStatusView.customView = [[[UIImageView alloc]initWithImage:netErrorImg]autorelease];
            if (text != nil)
            {
                netStatusView.labelText = text;
            }
            else
            {
                netStatusView.labelText = MultiLanguage(uLNetworkError);
            }
            break;
            
        default:
            break;
    }
    
    [netStatusView hide:YES afterDelay:delay];
}

+(void)doSetCellSelectedBgView:(UITableViewCell *)cell style:(CellSelectedStyle)style margin:(CGFloat)margin
{
    if (cell == nil || ![cell isKindOfClass:[UITableViewCell class]])
    {
        return;
    }
    
    NSString *bgImgStr = nil;
    NSString *styleStr = nil;
    NSString *largeStr = @"";
    UIImage  *bgImg = nil;
    UIImageView *cellClickBgView = nil;
    switch (style)
    {
        case CellSelectedStyleBlue:
            styleStr = @"blue";
            break;
        case CellSelectedStyleGreen:
            styleStr = @"green";
            break;
        case CellSelectedStylePurple:
            styleStr = @"purple";
            break;
        case CellSelectedStyleRed:
            styleStr = @"red";
            break;
        case CellSelectedStyleYellow:
            styleStr = @"yellow";
            break;
            
        case CellSelectedStyleBlueLarge:
            styleStr = @"blue";
            largeStr = @"_large";
            break;
            
        default:
            styleStr = @"blue";
            break;
    }
    if (IS_IPHONE5)
    {
        bgImgStr = [NSString stringWithFormat:@"Com_cellBg_%@_i5%@.png",styleStr, largeStr];
        
    }
    else
    {
        bgImgStr = [NSString stringWithFormat:@"Com_cellBg_%@_i4%@.png",styleStr, largeStr];
        
    }
    bgImg = [UIImage imageNamed_New:bgImgStr];
    if (bgImg == nil)
    {
        return;
    }
    
    UIImage *newBgImg = [bgImg resizableImageWithCapInsets:UIEdgeInsetsMake(9.0f, 15.0f, 9.0f, bgImg.size.width - 10.0f)];
    cellClickBgView = [[UIImageView alloc]initWithImage:newBgImg];
    if (IS_IPAD)
    {
        cellClickBgView.transform = CGAffineTransformMakeScale(SNS_SCALE_X, SNS_SCALE_H);
    }
    cellClickBgView.frame = SNSRect(margin, 2, 0, 0);
    
    cellClickBgView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//    cell.selectedBackgroundView = [[[UIView alloc]init]autorelease];
//    [cell.selectedBackgroundView addSubview:cellClickBgView];
    cell.selectedBackgroundView = cellClickBgView;
    [cellClickBgView release];
}

+(UIImage*) imageCompressionWithUIImage:(UIImage*)srcImage toSize:(int)toSize
{
    CGFloat compression = 1.f;
    CGFloat maxCompression = 0.1f;
    int maxImageSize = toSize;
    
    NSData *imageData = UIImageJPEGRepresentation(srcImage, compression);
    while (imageData.length > maxImageSize && compression > maxCompression)
    {
        compression -= 0.05f;
        imageData = UIImageJPEGRepresentation(srcImage, compression);
    }
    
    UIImage* compressionImage = [UIImage imageWithData:imageData];
    return compressionImage;
}

+(UIImage*) scaleToSize:(UIImage*)srcImage toSize:(CGSize)toSize
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(toSize);
    
    // 绘制改变大小的图片
    [srcImage drawInRect:CGRectMake(0, 0, toSize.width, toSize.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

/*
 *  @brief: 存储用户的LBS信息
 */
+(void)saveLSBInfo:(double)newLng withNewCoordinate:(double)newLat updateDate:(NSDate *)date andCityName:(NSString *)cityName for:(NSString *)userID
{
#ifndef storeInUserDefaults
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *lbsInfoData = [userDefault objectForKey:@"LBSInfo"];
    
    NSDictionary *userLBSInfoList = [NSKeyedUnarchiver unarchiveObjectWithData:lbsInfoData];
    NSMutableDictionary *mutableUserLBSInfoList = [NSMutableDictionary dictionaryWithDictionary:userLBSInfoList];
    
    if (!mutableUserLBSInfoList)
    {
        mutableUserLBSInfoList = [NSMutableDictionary dictionary];
    }
    
    //NSDate *currentDate = [NSDate date];
    if (nil!=cityName && ![@"" isEqualToString:cityName]) {
        if (![cityName isKindOfClass:[NSString class]]) {
            cityName = @"";
            BMCCAssert(false, @"error:;--cityname is not string");
            return;
        }
    }
    [mutableUserLBSInfoList setValue:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithDouble:newLng], @"lastLng",
                                      [NSNumber numberWithDouble:newLat], @"lastLat",
                                      cityName,@"cityName",
                                      date, @"lastReportLBSTS", nil] forKey:userID];
    
    NSData *savedUserLBSInfoList = [NSKeyedArchiver archivedDataWithRootObject:mutableUserLBSInfoList];
    [userDefault setObject:savedUserLBSInfoList forKey:@"LBSInfo"];
    [userDefault synchronize];
#else
    if (nil!=cityName)
    {
        if (![cityName isKindOfClass:[NSString class]] && ![@"" isEqualToString:cityName]) {
            cityName = @"";
            BMCCAssert(false, @"error:;--cityname is not string");
            return;
        }
    }
    [UserDefaultsManager setCurrentUserDefaultInfo:@{@"lastLng": @(newLng),
                                                    @"lastLat": @(newLat),
                                                    @"cityName": cityName,
                                                    @"lastReportLBSTS": date}
                                            forKey:@"LBSInfo"
                                         forUserId:userID];
#endif
}

@end

@implementation UIImage(UIImageFromImgFileName)

+(UIImage *)imageFromImgFileName:(NSString *)imgFileName
{
    /*
    UIImage *retImage = nil;
    NSString *imgFilePath = [[NSBundle mainBundle]pathForResource:imgFileName ofType:nil];
    if (imgFilePath != nil)
    {
        retImage = [UIImage imageWithContentsOfFile:imgFilePath];
    }
    
    return retImage;
     */
    
    return [UIImage imageNamed_New:imgFileName];
}

@end
