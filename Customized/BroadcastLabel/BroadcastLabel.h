//
//  BroadcastLabel.h
//  beatmasterSNS
//
//  Created by chengsong on 12-12-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/*
 *  @brief: 多功能广播用Label
 *      字体、特殊字颜色、行间距 功能
 */

#import <UIKit/UIKit.h>

@interface MessageSize : NSObject
{
    CGSize _size;    // // 最后矩形大小
    int    _lineCount; // // 行数
    float  _lineHeight; // // 最大行高
}
@property(nonatomic,assign)CGSize size;
@property(nonatomic,assign)int lineCount;
@property(nonatomic,assign)float lineHeight;

@end
@interface BroadcastLabel : UILabel
{
    NSString    *_textString;
    NSAttributedString *_needDisplayString;
    
    UIColor         *_normalTextColor;
    UIColor         *_specialTextColor;
    
    BOOL            _isNeedAddAttribute;
    
}
@property(nonatomic,copy)NSAttributedString *needDisplayString;

/*
 *  @brief: 一下方法只针对非广播Message使用
 */

- (id)initWithFrame:(CGRect)frame broadcastText:(NSString *)broadcastText color:(UIColor *)color norColor:(UIColor *)norColor;

@end



//**************************//
// // 彩色Label字符串处理类 // //
//*************************//
@interface ColorStringAnalysis : NSObject
{
    // // 字符串特殊显示段 数组
    NSMutableArray  *_rangeArray;
    // // 获取长属性字符串的
}
// // 分析字符串，去掉"{"和"}"
-(NSString *)analysisString:(NSString *)needAnalysisString;
// // 给分析后的字符串添加属性
-(NSAttributedString *)doSetAttributeString:(NSString *)analysedString normalColor:(UIColor *)normalColor specialColor:(UIColor *)specialColor font:(UIFont *)font;
// // 获取Label一行显示的时候占的size
-(CGFloat)doGetLineHeightOfNeedDisplayString:(NSAttributedString *)needDisplayString;

// // 已添加属性的长字符串在某个UILabel中显示 的 每一行字符串
// // key1: "MessageSize" key2: "linesAttrStringArr"
-(NSDictionary *)getAllLinesArrOfAttrStrInLabel:(CGSize)size wholeAttrStr:(NSAttributedString *)wholeAttStr;
// // 给需要显示"\" 或 "{" 或 "}"的字符串转义
+(NSString *)escapedCharactors:(NSString *)targetString;
@end

#define kKeyOfAttributedStringMsgSize   @"MessageSize"
#define kKeyOfAttributedStringArr       @"linesAttrStringArr"

