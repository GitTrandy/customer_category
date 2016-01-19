//
//  CSColorConvert.h
//  CoreTextTest
//
//  Created by chengsong on 13-10-14.
//  Copyright (c) 2013年 chengsong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSColorConvert : NSObject

/*
 *  @brief:  类似"#FF00BB"的十六进制颜色转化为UIcolor对象
 *  @param:  hexStr
 *           十六进制表示的RGB颜色，格式类似 #FF00BB
 *  @return: 颜色对象
 */
+(UIColor *)getColorWithHexStr:(NSString *)hexStr;

/*
 *  @brief:  把RGB三个int数字转化为类似#FF00BB十六进制字符串表示
 *  @param:  r   g   b
 *           r g b 分别代表红、绿、蓝颜色值
 *  @return: 十六进制表示字符串
 */
+(NSString *)getHexStrWithR:(int)r G:(int)g B:(int)b;
@end
