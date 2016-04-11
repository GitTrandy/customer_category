//
//  CSTextCommon.h
//  CoreTextTest
//
//  Created by chengsong on 13-10-11.
//  Copyright (c) 2013年 chengsong. All rights reserved.
//

#ifndef CoreTextTest_CSTextCommon_h
#define CoreTextTest_CSTextCommon_h

// // CSText字符串转义
#define TVESCAPE(text) [CSTextParser escapedCharactors:text]

// // 需要转义的字符
#define TVBackSlash @"\\"
#define TVLeftBrace @"{"
#define TVRightBrace @"}"

// // 属性
/* 文字属性 */
#define TVFontName   @"fontname"         // // 字体名称
#define TVFontSize   @"fontsize"         // // 字体大小
#define TVColor      @"color"            // // 字体的颜色
#define TVULineType  @"ul"               // // 字下划线类型(1:单线 2:双线)
#define TVULineColor @"ulc"              // // 字下划线颜色
#define TVClick      @"clicktype"        // // 点击信息(用户自己定义，值最后给用户自己)
#define TVClickColor @"clickcolor"       // // 点中状态文字和下划线的颜色

/* 图片属性 图片动画属性 */
#define TVImgMaxIndex @"maxindex"        // // 桢动画图片组成(约定名称格式:xxx_00.xxx 到 xx_99.xxx) imgMaxIndex最大值99
#define TVImgAniDuration @"duration"     // // 播放一次动画的间隔(默认1.0，数据约定为float型)
#define TVImgAniDefaultDuration 1.0f

/* 公共属性 */
#define TVInfo       @"info"             // // 附加传递信息(用户自己定义，值最后给给用户自己)
#define TVType       @"type"             // // 属性类型(text,img,imgani)

// // 存储属性的Dict的keys
#define TVText       @"specialtext"      // // 显示的字
#define TVTypeText   @"text"             // // 特殊字符串类型
#define TVTypeImg    @"img"              // // 插入图片类型
#define TVTypeImgAni @"imgani"           // // 图片动画类型
#define TVImgSpace   @" "                // // 插入图片占位符
#define TVRLocation  @"location"         // // 字或者图片占位符的Range.location
#define TVRLength    @"length"           // // 字或者图片占位符的Range.Length
#define TVImageName  @"imgname"          // // 插入图片名称
#define TVImgYmargin @"margin"           // // 图片或者图片动画位置在Y轴上的偏移量，正数向下偏移，负数向上偏移

// // CSTextView 默认属性
#define TVDefaultFont  [UIFont systemFontOfSize:12.0f]

typedef struct
{
    int location;
    float width;
    float height;
}ImgSize;

// // 字符串对齐方式
typedef enum
{
    CSTextAlignmentLeft = 0,
    CSTextAlignmentRight = 1,
    CSTextAlignmentCenter = 2,
    CSTextAlignmentJustified = 3,
    CSTextAlignmentNatural = 4,
}CSTextAlignment;
typedef enum
{
    CSLineBreakByWordWrapping = 0,     // // 按词分段
    CSLineBreakByCharWrapping = 1,	   // // 按字分段
    CSLineBreakByClipping = 2,         // // 截掉
    CSLineBreakByTruncatingHead = 3,   // // 类似 ...xyz
    CSLineBreakByTruncatingTail = 4,   // // 类似 abc...
    CSLineBreakByTruncatingMiddle = 5, // // 类似 abc...xyz
}CSLineBreakMode;

#endif
