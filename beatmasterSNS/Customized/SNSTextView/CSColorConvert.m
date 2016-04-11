//
//  CSColorConvert.m
//  CoreTextTest
//
//  Created by chengsong on 13-10-14.
//  Copyright (c) 2013年 chengsong. All rights reserved.
//

#import "CSColorConvert.h"

@implementation CSColorConvert

/*
 *  @brief: 根据十六进制字符串(#FF00BB)解析为UIColor颜色对象
 */
+(UIColor *)getColorWithHexStr:(NSString *)hexStr
{
    if (hexStr == nil)
    {
        return nil;
    }
    NSString *hexStrNoSpace = [hexStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (hexStrNoSpace == nil || [@""isEqualToString:hexStrNoSpace])
    {
        return nil;
    }
    // // 格式检查 #FF00BB
    if (![hexStrNoSpace hasPrefix:@"#"] || hexStrNoSpace.length != 7)
    {
        return nil;
    }
    
    int r = 0, g = 0 , b = 0;
    
    r = [self convertHexToInt:[hexStrNoSpace substringWithRange:NSMakeRange(1, 2)]];
    g = [self convertHexToInt:[hexStrNoSpace substringWithRange:NSMakeRange(3, 2)]];
    b = [self convertHexToInt:[hexStrNoSpace substringWithRange:NSMakeRange(5, 2)]];
    
    UIColor *ret_color = [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];
    return ret_color;
}

/*
 *  @brief: RGB数字转化为十六进制字符串 #FF00BB
 */
+(NSString *)getHexStrWithR:(int)r G:(int)g B:(int)b
{
    NSMutableString *ret_str = [[NSMutableString alloc]init];
    r = [self checkColorNum:r];
    g = [self checkColorNum:g];
    b = [self checkColorNum:b];
    
    NSString *rStr = [self convertIntToHex:r];
    NSString *gStr = [self convertIntToHex:g];
    NSString *bStr = [self convertIntToHex:b];
    
    [ret_str appendFormat:@"#%@%@%@",rStr,gStr,bStr];
    return ret_str;
}
+(int)checkColorNum:(int)num
{
    int ret_num = num;
    ret_num = ret_num < 0 ? 0 : ret_num;
    ret_num = ret_num > 255 ? 255 : ret_num;
    return ret_num;
}

/*
 *  @brief: 十六进制转化为十进制
 */
+(int)convertHexToInt:(NSString *)hexStr
{
    int ret_int = 0;
    NSString *hexStrUp = [hexStr uppercaseString];
    int len = hexStrUp.length;
    for (int i=0; i<len; i++)
    {
        unichar c = [hexStrUp characterAtIndex:i];
        if (c - '9' > 0)
        {
            int add = c - 'A';
            ret_int += (10+add)*(int)pow(16, len-1-i);
        }
        else
        {
            ret_int += (c - '0')*(int)pow(16, len-1-i);
        }
    }
    
    return ret_int;
}
/*
 *  @brief: 十进制整数转化为十六进制字符串
 */
+(NSString *)convertIntToHex:(int)number
{
    NSMutableString *ret_str = [[NSMutableString alloc]init];
    int tmpNum = number;
    int i = 1;
    do {
        int remainder = tmpNum % 16;
        tmpNum = tmpNum / 16;
        NSString *numStr = @"0";
        if (remainder > 9)
        {
            unichar cc = 'A' + (remainder-10);
            numStr = [NSString stringWithFormat:@"%c",cc];
        }
        else
        {
            numStr = [NSString stringWithFormat:@"%d",remainder];
        }
        [ret_str insertString:numStr atIndex:0];
        i++;
        
    } while (tmpNum || i<=2);
    
    return ret_str;
}


@end
