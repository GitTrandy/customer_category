//
//  CSTextParser.h
//  CoreTextTest
//
//  Created by chengsong on 13-10-11.
//  Copyright (c) 2013年 chengsong. All rights reserved.
//


/*
    特殊字或者图片增加属性格式:
 
   特殊处理标签       属性分隔符          可以多个属性  特殊字符串
       |               ｜                  |          |
    +--+---------------＋------------------+----------+--------+
       |               ｜                  |          |
       {< key1 = value1 , key2 = value2 , ... >SpecialString}
 
       {< key1 = value1 , key2 = value2 , ... >ImgName}
        |                  |       |               |
    +---+------------------+-------+---------------+-----------+
        |                  |       |               |
      属性标签            属性Key  属性Value       图片名称
 
 支持的属性Key参见 CSTextCommon.h
 
 字符串分析之后得到的数据信息整合之后的结构:
 
    |--CSTextCompoment(字符串分析之后的数据信息集合)
    |    |
    |    |--showText(最后需要显示的字符串)
    |    |--specialTextCompoments(每一段特殊字符串的集合)
    |    |   |
    |    |   |--specialTextAttrDict_1(特殊字符串段1属性集合)
    |    |   |   |
    |    |   |   |--specialText(特殊字符串)
    |    |   |   |--Range(特殊字符串在整个字符串的范围)
    |    |   |   |--Color
    |    |   |   |--FontName
    |    |   |   |--FontSize
    |    |   |   |--type
    |    |   |   |--...
    |    |   |
    |    |   |--specialTextAttrDict_2(特殊字符串段2属性集合)
    |    |   |--...
    |    |
    |    |--imgCompoments(每一个图片的集合)
    |    |   |
    |    |   |--imgAttrDict_1(图片1的属性集合)
    |    |   |   |
    |    |   |   |--imgName(图片名称)
    |    |   |   |--specialText(图片在整个字符串中的占位符)
    |    |   |   |--Range(图片在整个字符串中的范围)
    |    |   |   |--type
    |    |   |   |--...
    |    |   |
    |    |   |--imgAttrDict_2(图片2的属性集合)
    |    |   |--...

 */

#import <Foundation/Foundation.h>
#import "CSTextCommon.h"
@class CSTextCompoment;
@interface CSTextParser : NSObject

/*
 *  @brief:  分析字符串
 *  @param:  needAnalysisString
 *           需要被分析的字符串
 *  @return: 去除属性描述标签的字符串，也是最后要全部显示的字符串等属性数据集合.
 */
-(CSTextCompoment *)analysisString:(NSString *)needAnalysisString;
/*
 *  @brief:  给需要显示"\" 或 "{" 或 "}"的字符串转义
 *  @param:  targetString
 *           需要被转义的字符串
 *  @return: 已经被转义过的字符串,可以作为被分析的字符串
 */
+(NSString *)escapedCharactors:(NSString *)targetString;

@end

/****** 文本属性数据集合 ******/
@interface CSTextCompoment : NSObject

// // 最后被显示的文本
@property(nonatomic,strong)NSString *showText;
// // 特殊的文本的属性等信息集合
@property(nonatomic,strong)NSArray *specialTextCompoments;
// // 图片的属性等信息集合
@property(nonatomic,strong)NSArray *imgCompoments;
// // 图片动画的属性等信息集合
@property(nonatomic,strong)NSArray *imgAniCompoments;

@end
