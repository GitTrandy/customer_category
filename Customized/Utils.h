//
//  Utils.h
//  beatmasterSNS
//
//  Created by  on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "cocos2d.h"
#import "UIImage+Replace_imageNamed.h"
#import "ActionItemParallel.h"

#import "UIDevice+Resolutions.h"
#import "MBProgressHUD.h"

/*
 *  System Versioning Preprocessor Macros
 */
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


//create by sunny
//---------------关于坐标点的宏
//#define SNSPoint(x,y) CGPointMake((x),(y))
//#define SNSSize(w,h) CGSizeMake((w),(h))
//#define SNSRect(x,y,w,h) CGRectMake((x),(y),(w),(h))

// liuwang

#define ReminderViewTag   1806

#define NoNetworkTag   2013

#define MultiLanguage(key) NSLocalizedString(@""#key"", nil)   
#define MultiLanguageWithNSString(key) NSLocalizedString(key, nil)   

//---------------辅助宏

#define SNS_REMOVEALLOBJ_RELEASE_NIL(obj) \
if (obj)\
{\
    [obj removeAllObjects];\
    [obj release];\
    obj = nil;\
}\

//释放并指空
#define SNS_RELEASE_NIL(obj) \
if (obj)\
{\
    [obj release];\
    obj = nil;\
}\

//移除view并指空
#define SNS_VIEW_REMOVE_NIL(view) \
if ([view isKindOfClass:[UIView class]] && view.superview) \
{\
    [view removeFromSuperview];\
    view = nil;\
}\

#define SNS_VIEW_REMOVE_RELEASE_NIL(view) \
if (view != nil && [view isKindOfClass:[UIView class]] && view.superview) \
{\
[view removeFromSuperview];\
[view release]; \
view = nil;\
}\

// 字符串赋值
#define SNS_NSSTRING_SET(obj)   \
if ([obj isKindOfClass:[NSString class]] && obj == nil) \
{   \
    obj = @"";  \
}   \

#define SNSLogFunction SNSLog(@"SNSLogFunction:%s", __FUNCTION__)

// //***********************// //
// //      几个推荐用的宏      // //
// // 颜色设置
#define SNSColorMake(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

// //***********************// //
// //    基本设备信息(横版)    // //
// // 设备高度
#define DEVICE_HEIGHT   ([[UIScreen mainScreen] bounds].size.width)
// // 设备宽度
#define DEVICE_WIDTH    ([[UIScreen mainScreen] bounds].size.height)

// // 设备基本放大比率参数
#define DEVICE_SCALE_WIDTH  (DEVICE_WIDTH/480.0f) // 2.1333333
#define DEVICE_SCALE_HEIGHT  (DEVICE_HEIGHT/320.0f)  // 2.4
// // 基本设置位置函数
#define SNSPoint(x,y) CGPointMake((x),(y))
#define SNSSize(w,h) CGSizeMake((w),(h))
#define SNSRect(x,y,w,h) CGRectMake((x),(y),(w),(h))
// // 基本设备类型判断(横版) iphone／itouch   ipad
#define IS_IPHONEUI   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPADUI     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE4     ((int)DEVICE_WIDTH%480==0)
#define IS_IPHONE5     ((int)DEVICE_WIDTH%568==0)
#define IS_IPAD        ((int)DEVICE_WIDTH%1024==0)

// //*******************************// //
// //      推荐用的几个信息(横版)      // //
// // 现在美术图片都是(480*320)@2x版本 // //
// // 故所有的缩放以美术图片为参考      // //
// // 满屏幕显示区域
#define SCREEN_WIDTH            DEVICE_WIDTH  // 1024 568 480
#define SCREEN_HEIGHT           DEVICE_HEIGHT // 768  320 320
#define SCREEN_FRAME            SNSRect(0.0f, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT)
#define SCREEN_WIDTH_OFFSET     (SCREEN_WIDTH - 480.f)

// // 针对屏幕的缩放(用于每个页面的大布局)
#define SCREEN_SCALE_X          SCREEN_WIDTH/480.0f     // x坐标系数
#define SCREEN_SCALE_Y          SCREEN_HEIGHT/320.0f    // y坐标系数
#define SCREEN_SCALE_W          SCREEN_WIDTH/480.0f     // 对象宽系数
#define SCREEN_SCALE_H          SCREEN_HEIGHT/320.0f    // 对象高度系数
// // 针对父视图的缩放(用于每个view对象的内部布局)
// // 1、保持不变形用SNS_SCALE设置宽高，2、忽略或需要变形(例如某个Label)SNS_SCALE_W,SNS_SCALE_H
// // 内部view的整体宽高缩放            (iphone) ? iphone : ipad
#define SNS_SCALE               ((IS_IPHONEUI) ? 1.0f : (1024.0f/480.0f))
#define SNS_SCALE_FLOAT(f) (SNS_SCALE*(f))
#define SNS_SCALE_RECT(rect) SNSRect((rect).origin.x*SNS_SCALE_X,(rect).origin.y*SNS_SCALE_Y,(rect).size.width*SNS_SCALE_W,(rect).size.height*SNS_SCALE_H)
#define SNS_SCALE_FONT(font) [(font) fontWithSize:(font).pointSize*SNS_SCALE]
// // 涉及到中间的不怕变形的X缩放，用SNS_SCALE_MIDDLE 更精确
#define SNS_SCALE_X             ((IS_IPHONEUI) ? (SCREEN_WIDTH/480.0f) : (1024.0f/480.0f))
#define SNS_SCALE_Y             ((IS_IPHONEUI) ? 1.0f : (1024.0f/480.0f))
// // 涉及到中间的不怕变形的W缩放，用SNS_SCALE_MIDDLE 更精确
#define SNS_SCALE_W             ((IS_IPHONEUI) ? (SCREEN_WIDTH/480.0f) : (1024.0f/480.0f))
#define SNS_SCALE_H             ((IS_IPHONEUI) ? 1.0f : (1024.0f/480.0f))  

#define SNS_2USER_OFFSET            (((IS_IPHONEUI) && (SCREEN_WIDTH == 568.0f)) ? 20.f : 0.f)
#define SNS_2USER_RANK_TBL_OFFSET   (((IS_IPHONEUI) && (SCREEN_WIDTH == 568.0f)) ? 20.f : 0.f)

#define SNS_1_0                 ((IS_IPHONEUI) ? 0 : 1)

// // 人物信息UserInfoView相关
#define SNS_WIDTH_USERINFOVIEW      (140.f * SNS_SCALE) // 人物信息宽度
#define SNS_HEIGHT_USERINFOVIEW     SCREEN_HEIGHT       // 人物信息高度
#define SNS_USERINFOVIEWFRAME       SNSRect(5.0f*SNS_SCALE, 0.0f, SNS_WIDTH_USERINFOVIEW, SNS_HEIGHT_USERINFOVIEW)

// // ScrollTabBar相关
#define SNS_WIDTH_SCROLLTABBAR      (55.0f * SNS_SCALE)                     // ScrollTabBar 宽度
#define SNS_HEIGHT_SCROLLTABBAR     (SCREEN_HEIGHT - 8 * SNS_SCALE)        // ScrollTabBat 高度
#define SNS_SCROLLBARFRAME          SNSRect(SCREEN_WIDTH - SNS_WIDTH_SCROLLTABBAR, 0.0f, SNS_WIDTH_SCROLLTABBAR, SNS_HEIGHT_SCROLLTABBAR - 8 * SNS_SCALE)

// // 中间区域相关
#define SNS_WIDTH_MIDDLE            (SCREEN_WIDTH - SNS_WIDTH_USERINFOVIEW - SNS_WIDTH_SCROLLTABBAR)
#define SNS_HEIGHT_MIDDLE           SCREEN_HEIGHT
#define SNS_COMMON_MIDDLE_FRAME     SNSRect(SNS_WIDTH_USERINFOVIEW,0.0f,SNS_WIDTH_MIDDLE,SNS_HEIGHT_MIDDLE)
// // 涉及到中间缩放，x 和 width 都乘以下面这个系数会非常精确
#define SNS_SCALE_MIDDLE            (SNS_WIDTH_MIDDLE/(480.0f-140.0f-55.0f))
// //***********************// //
// //      黑色背景宏         // //
#define SNS_BLACKBG_OFFSET  (40*SNS_SCALE)
#define SNS_BLACKCOLOR_BG   [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]
#define SNS_BLACKCOLOR_WIDTH (SCREEN_WIDTH - SNS_WIDTH_USERINFOVIEW - SNS_BLACKBG_OFFSET)
#define SNS_BLACKBG_HALLFRAME   SNSRect(0.0f,0.0f,SCREEN_WIDTH - SNS_BLACKBG_OFFSET,SCREEN_HEIGHT)
#define SNS_BLACKBG_FRAME   SNSRect(SNS_WIDTH_USERINFOVIEW,0.0f,SNS_BLACKCOLOR_WIDTH,SCREEN_HEIGHT)
#define SNS_BLACKBG_SUBFRAME   SNSRect(0.0f,0.0f,SNS_BLACKCOLOR_WIDTH,SCREEN_HEIGHT)
#define SNS_TEXTCOLOR_PROFILE [UIColor colorWithRed:0.8 green:0.79 blue:0.72 alpha:1.f]
#define SNS_TEXTCOLOR_PROFILE_NEW [UIColor colorWithRed:(61/255.0f) green:(132/255.0f) blue:(254/255.0f) alpha:1.f]

// // 没有左边人物信息(比如大厅),只有左边和ScrollTabBar
#define SNS_HALL_TABLEFRAME         SNSRect(0.0f,0.0f,SCREEN_WIDTH - SNS_WIDTH_SCROLLTABBAR, SCREEN_HEIGHT)

// // MessageView Frame
#define SNS_HEIGHT_MESSAGEVIEW      (24.0f*SNS_SCALE)
#define SNS_MESSAGEVIEW_LONGVIEW      SNSRect(0.0f,0.0f,382.0f*SNS_SCALE,SNS_HEIGHT_MESSAGEVIEW)
#define SNS_WIDTH_MESSAGEVIEW_SUBVIEW   ((IS_IPHONE5) ? (373.0f*SNS_SCALE) : (288.0f*SNS_SCALE))
#define SNS_MESSAGEVIEW_SUBVIEW     SNSRect(SNS_WIDTH_USERINFOVIEW, 0.f, SNS_WIDTH_MESSAGEVIEW_SUBVIEW, SNS_HEIGHT_MESSAGEVIEW)


//
#define SNS_HEIGHT_TABBARVIEW       (40.f*SNS_SCALE_H)

#define SNS_CHARMBARVIEW_FRAME      SNSRect(15*SNS_SCALE_X, 5*SNS_SCALE_Y, 120*SNS_SCALE_W, 40*SNS_SCALE_H)


// // 以下稍后解决
#define SNS_MAINVIEW_iCarousel  SNSRect(SNS_WIDTH_USERINFOVIEW - 40.f*SNS_SCALE_X, 0, SCREEN_WIDTH - SNS_WIDTH_USERINFOVIEW + 30.f*SNS_SCALE_W, SCREEN_HEIGHT)


// Achievement View
#define SNS_ACHIEVE_TABLE_FRAME SNSRect(30,40, SCREEN_WIDTH - SNS_WIDTH_SCROLLTABBAR - 30, 280)
#define SNS_ACHIEVE_TABLE_LEFTBTN_FRAME  SNSRect(10*SNS_SCALE_X, 0, (SCREEN_WIDTH - SNS_WIDTH_SCROLLTABBAR-50*SNS_SCALE_W) / 2.f, 70*SNS_SCALE)
#define SNS_ACHIEVE_TABLE_RIGHTBTN_FRAME SNSRect((SCREEN_WIDTH - SNS_WIDTH_SCROLLTABBAR-50*SNS_SCALE_W) / 2.f + 20.0f*SNS_SCALE_X, 0, (SCREEN_WIDTH - SNS_WIDTH_SCROLLTABBAR-50*SNS_SCALE_W) / 2.f, 70*SNS_SCALE)

// In Practice
#define SNS_PC_ADFRAME          SNSRect(0, 0, 130, SCREEN_HEIGHT)
#define SNS_PC_MUSICLIST_FRAME  SNSRect(SNS_WIDTH_USERINFOVIEW, 80-30, SCREEN_WIDTH - SNS_WIDTH_USERINFOVIEW - SNS_WIDTH_SCROLLTABBAR + 6.f, 240+30)
#define SNS_PC_MSG_FRAME        SNSRect(140+75,0,200,20)    // TODO: need fix it later
#define SNS_PC_SORTBUTTON_RECT(img_w,img_h) SNSRect(SCREEN_WIDTH - SNS_WIDTH_SCROLLTABBAR - img_w,19,img_w,img_h)
#define SNS_PC_MUSICLIST_CELL   SNSRect(0, 0, SCREEN_WIDTH - SNS_WIDTH_USERINFOVIEW - SNS_WIDTH_SCROLLTABBAR + 6.f, 50)

//---------------公用坐标位置

static const CGFloat SNSScreenWidth = 480.0f;   //屏幕宽
static const CGFloat SNSScreenHeight = 320.0f;  //屏幕高
static const CGRect  SNSScreenFrame = {0.0f, 0.0f, 480.0f, 320.0f};
 
static const CGRect  SNSUserInfoViewFrame = {0.0f, 0.0f, 130.0f, 320.0f}; //个人信息栏
static const CGRect  SNSContentFrame = {140.0f, 0.0f, 300.0f, 320.0f};      //中间的内容  
//static const CGRect  SNSTabBarFrame = {435.0f, 0.0f, 45.0f, 320.0f};      //tab bar
static const CGRect  SNSTabBarFrame = {417.5f, 0.0f, 62.5f, 320.0f};      //tab bar

//---当存在子tab bar时:(相对于SNSContentFrame)
//static const CGRect  SNSSubTabBarFrame = {260.0f, 30.0f, 40.0f, 280.0f};  //子tab bar
#define SNSSubTabBarFrame  SNSRect(260.0f, 30.0f, 40.0f, 280.0f)
//static const CGRect  SNSSubContentFrame = {0.0f, 0.0f, 260.0f+22.0f, 320.0f};   //子内容frame
#define SNSSubContentFrame  SNSRect(0.0f, 0.0f, 260.0f+22.0f, 320.0f)


// // 页面跳转释放资源
#define Release_CS(object) if (object)\
{\
    [object removeFromSuperview];\
    [object release];\
    object = nil;\
}\

// // autoTextSizelabel 布局方式：
typedef enum 
{
    AutoTextSizeLabelAlignLeft = 0,
    AutoTextSizeLabelAlignCenter = 1,
    AutoTextSizeLabelAlignRight = 2,
    AutoTextSizeLabelAlignLeftXCenterY = 3
}AutoTextSizeLabelAlign;

@interface Utils : NSObject //<CCDirectorDelegate>
{
    
}

-(id)init;

+(Utils*)shareUtils;
+(void)purgeShareUtils;

+ (id)findFirstObjMemberOfClassName:(NSString *)className inArray:(NSArray *)array;

//在view里面递归搜索所有指定类名的UIView
+ (NSArray *)findSubviewsKindOfClassName:(NSString *)className inView:(UIView *)view;
+ (NSArray *)findSubviewsMemberOfClassName:(NSString *)className inView:(UIView *)view;

/**
 *  自动适应Text内容大小的Label以及布局
 */
+ (void)autoTextSizeLabel:(UILabel *)labelName font:(UIFont *)font labelAlign:(AutoTextSizeLabelAlign)align frame:(CGRect)rect text:(NSString *)text textColor:(UIColor *)color;




typedef enum 
{
    NumAlignLeft = 0,
    NumAlignCenter,
    NumAlignRight
}NumAlign;

typedef enum 
{
    NumTypeBattleRound = 0, // // 局数
    NumTypeBattleScore,     // // 得分分数
    NumTypeBattleResult,     // // 游戏结果(最大连击数等)
    NumTypePlayResult,           //练习结果
    //
    NumTypeResultView_Score     //结果页面，分数类型
}NumType;

//*************************************//
// //           数字view加载          // //
// // mainView:整个数字view           // //
// // num: 数字                      // //
// // align:数字对齐方式               // //
// // numType:数字的美术图片分类        // //
// // frame:数字按对齐方式固定的那个点位置 // //
+ (void)createNumView:(UIImageView *)mainView number:(float)num decimal:(int)decimal percent:(BOOL)percent align:(NumAlign)align numType:(NumType)numType frame:(CGRect)frame margin:(int)margin;


//创建游戏引擎的vc
+ (void) cocos2dDirectorVC;

typedef enum _tagMainVcBgType{
    
    EMBT_Practice=0,
    EMBT_BattleNotice,
    EMBT_Profile,
    EMBT_Club,
    EMBT_ShoppingMall,
    EMBT_MsgBox,
    
}MainVcBgType;

//创建弹出框动画
+(ActionItemParallel*) createViewAnimationWithView:(UIView*)view bgColorView:(UIView*)bgColorView bgImageView:(UIView*)bgView bgType:(MainVcBgType)type isForeachBgImageView:(bool)isForeachBgImageView;

+(ActionItemParallel*) createViewAnimationWithViewArray:(NSArray*)viewArray;

//*****************************//
// //     成就徽章信息        // //
// // 1、获取所有徽章信息      // //
// // 2、获取某个信息的徽章名称 // //
+ (NSDictionary *)doGetAllAchievementInfoFromPlist;
+ (NSString *)doGetAchievementName:(NSString *)achievementID;

//*****************************//
// //     技术等级信息         // //
// // 1、获取所有技术信息       // //
// // 2、获取给定等级需要的经验  // //
// // 3、获取给定等级需要的总经验 // //
typedef enum
{
    PlistInfoType_Tech = 0,
    PlistInfoType_Charm,
    PlistInfoType_intimacy,
    PlistInfoType_Friend,
    PlistInfoType_Popular
}PlistInfoType;
+ (NSDictionary *)doGetAllLevelInfoFromPlist:(PlistInfoType)type;
+ (NSDictionary *)doGetInfoDictWithType:(PlistInfoType)type withLevel:(int)level;
+ (float)doGetNeedPointsWithType:(PlistInfoType)type withLevel:(int)level;
+ (float)doGetTotalPointsWithType:(PlistInfoType)type withLevel:(int)level;

//*********************//
// //   生成Plist   // //
+ (void)CreatePlistWithcsvFile:(NSString *)csvFile;

//**************************************//
// // 设置网络请求运行状态显示内容         // //
// // netStatusView: 所要设置的弹出框   // //
// // type         : 弹出框状态        // //
// // text         : 弹出框要显示的内容 // //
// // delay        : 多少时间之后隐藏   // //
typedef enum
{
    NetStatusTypeLoading = 0,   // // 正在请求
    NetStatusTypeSuccess,       // // 请求成功
    NetStatusTypeFalse,         // // 请求失败
    NetStatusTypeNetError       // // 网络错误
}NetStatusType;
+(void)doChangeNetStatusView:(MBProgressHUD *)netStatusView type:(NetStatusType)type displayText:(NSString *)text hideAfterdelay:(float)delay;


//*************************************//
// // 设置cell选择状态的背景图片         // //
// // cell     : 所要设置的cell       // //
// // style    : cell背景类型        // //
// // margin   : 左右细微调整位置偏移量 // //
typedef enum
{
    CellSelectedStyleBlue = 0,  // // 蓝色
    CellSelectedStyleGreen,     // // 绿色
    CellSelectedStylePurple,    // // 紫色
    CellSelectedStyleRed,       // // 红色
    CellSelectedStyleYellow,    // // 黄色
    CellSelectedStyleBlueLarge,
}CellSelectedStyle;
+(void)doSetCellSelectedBgView:(UITableViewCell *)cell style:(CellSelectedStyle)style margin:(CGFloat)margin;

/*
    压缩图片的内存大小 (因为是用jpeg压缩，所以返回的图片就没有alpha)
        参数：
            srcImage      要压缩的源
            toSize        要压缩到的大小
 
        返回压缩好的UIImage
 
 */
+(UIImage*) imageCompressionWithUIImage:(UIImage*)srcImage toSize:(int)toSize;

/*
    缩放图片大小
        参数:
            srcImage    要缩放的源图片
            toSize      要缩放的大小
 
        返回缩放好的UIImage
 */
+(UIImage*) scaleToSize:(UIImage*)srcImage toSize:(CGSize)toSize;

/*
 *  @brief: 存储LBS信息
 *  @param: 纬度、经度、用户ID
 */
+ (void)saveLSBInfo:(double)newLng withNewCoordinate:(double)newLat updateDate:(NSDate *)date andCityName:(NSString *)cityName for:(NSString *)userID;

@end

@interface UIImage(UIImageFromImgFileName)
+(UIImage *)imageFromImgFileName:(NSString *)imgFileName;
@end
