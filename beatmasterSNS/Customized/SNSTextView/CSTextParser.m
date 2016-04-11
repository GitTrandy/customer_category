//
//  CSTextParser.m
//  CoreTextTest
//
//  Created by chengsong on 13-10-11.
//  Copyright (c) 2013年 chengsong. All rights reserved.
//

#import "CSTextParser.h"

@implementation CSTextParser

#pragma mark - Life Circle
#pragma mark
-(id)init
{
    self = [super init];
    if (self) {
        // // init codes
    }
    
    return self;
}


#pragma mark - Private Methods
#pragma mark
/*
 *  @brief: 分析字符串
 */
-(CSTextCompoment *)analysisString:(NSString *)needAnalysisString
{
    //needAnalysisString = @"This is a test:字{<color = red,font = sysfont,type=1>红色字} 然后图片{<type=2>img.png}测试{<=>不写标记}{<>}";
    if (needAnalysisString == nil || [@"" isEqualToString:needAnalysisString])
    {
        return nil;
    }
    
    CSTextCompoment *textCompoment = [[CSTextCompoment alloc]init];
    
    NSMutableArray *specialTextComArr = [[NSMutableArray alloc]init];
    NSMutableArray *imgComArr = [[NSMutableArray alloc]init];
    NSMutableArray *imgAniComArr = [[NSMutableArray alloc]init];
    
    NSMutableString *showText = [[NSMutableString alloc]init];
    NSInteger startIndex = -1;
    NSString *oneCharactor = @"";
    NSInteger stringLength = needAnalysisString.length;
    
    BOOL isInSpecialRect = NO;
    
    NSMutableString *analyStringTip = [[NSMutableString alloc]init];
    
    for (int i=0; i<stringLength; i++)
    {
        oneCharactor = [needAnalysisString substringWithRange:NSMakeRange(i, 1)];
        
        // " \ "
        if ([@"\\" isEqualToString:oneCharactor])
        {
            // // 如果遇到"\"，后面还有字就正常加上显示字符串，没有就不要这个"\"
            if (i+1 < stringLength)
            {
                if (isInSpecialRect)
                {
                    [analyStringTip appendString:[needAnalysisString substringWithRange:NSMakeRange(i+1, 1)]];
                    i++;
                }
                else
                {
                    [showText appendString:[needAnalysisString substringWithRange:NSMakeRange(i+1, 1)]];
                    i++;
                }
            }
            continue;
            
        }
        // " { "
        if ([@"{" isEqualToString:oneCharactor])
        {
            // // 如果遇到"{"，纪录特殊显示字符串开始位置，连续的"{{",只纪录最开始的一个的位置
            if (!isInSpecialRect)
            {
                isInSpecialRect = YES;
                startIndex = showText.length;
            }
            continue;
        }
        // " } "
        if ([@"}" isEqualToString:oneCharactor])
        {
            // // 在找到"{"的情况下，遇到第一个"}"关闭这个特殊区间
            if (isInSpecialRect)
            {
                
                //NSLog(@"SSS: %@",analyStringTip);
                
                NSDictionary *analiedDict = [self keepSpecialRectAttr:analyStringTip location:showText.length];
                if (analiedDict)
                {
                    NSString *type = analiedDict[TVType];
                    if (type && [TVTypeImg isEqualToString:type])
                    {
                        // // 图片类型
                        [imgComArr addObject:analiedDict];
                        
                    }
                    else if (type && [TVTypeImgAni isEqualToString:type])
                    {
                        [imgAniComArr addObject:analiedDict];
                    }
                    else
                    {
                        // // 特殊字类型
                        [specialTextComArr addObject:analiedDict];
                    }
                    NSString *textStr = analiedDict[TVText];
                    if (textStr)
                    {
                        [showText appendString:textStr];
                    }
                    
                }
                
                startIndex = -1;
                isInSpecialRect = NO;
                [analyStringTip setString:@""];
                
            }
            continue;
        }
        
        
        if (isInSpecialRect)
        {
            [analyStringTip appendString:oneCharactor];
        }
        else
        {
            [showText appendString:oneCharactor];
        }
    }
    
    if (analyStringTip.length > 0)
    {
        [showText appendString:analyStringTip];
    }
    
    textCompoment.showText = showText;
    textCompoment.specialTextCompoments = specialTextComArr;
    textCompoment.imgCompoments = imgComArr;
    textCompoment.imgAniCompoments = imgAniComArr;
    
    return textCompoment;
    
}

/*
 *  @brief: 特殊属性的项分析和存储方式
 */
-(NSDictionary *)keepSpecialRectAttr:(NSString *)targetStr location:(int)location
{
    NSMutableDictionary *attrDict = [[NSMutableDictionary alloc]init];
    
    NSString *specialText = @"";
    NSRange startRange = [targetStr rangeOfString:@"<"];
    NSRange endRange = [targetStr rangeOfString:@">"];
    if (startRange.length==0 || endRange.length==0 || startRange.location>=endRange.location)
    {
        attrDict[TVColor] = @"#FF0000";
        attrDict[TVText] = targetStr;
        return attrDict;
    }
    
    NSString *str = startRange.location<targetStr.length-1 ? [targetStr substringWithRange:NSMakeRange(startRange.location+1, endRange.location-startRange.location-1)] : @"";
    if (endRange.location<targetStr.length-1)
    {
        specialText = [targetStr substringFromIndex:endRange.location+1];
    }
    if (str && str.length>0)
    {
        NSArray *attrArr = [str componentsSeparatedByString:@","];
        for (NSString *attr in attrArr)
        {
            NSArray *key_values = [attr componentsSeparatedByString:@"="];
            if (key_values && key_values.count == 2)
            {
                NSString *key = [[key_values[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]lowercaseString];
                NSString *value = [key_values[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                attrDict[key] = value;
            }
        }
    }
    
    NSString *type = attrDict[TVType];
    if (type && ([TVTypeImg isEqualToString:type] || [TVTypeImgAni isEqualToString:type]))
    {
        // // 图片或动画:纪录图片名称(动画的第一张图片名称)，字符串增加一个占位符
        attrDict[TVImageName] = specialText;
        specialText = TVImgSpace;
    }
    attrDict[TVText] = specialText;
    
    attrDict[TVRLocation] = [NSString stringWithFormat:@"%d",location];
    attrDict[TVRLength] = [NSString stringWithFormat:@"%d",specialText.length];
    
    
    return attrDict;
}

/*
 *  @brief: 给需要显示"\" 或 "{" 或 "}"的字符串转义
 */
+(NSString *)escapedCharactors:(NSString *)targetString
{
    if (!targetString)
    {
        return nil;
    }
    
    NSMutableString *ret_str = [[NSMutableString alloc]init];
    NSString *oneChar = @"";
    for (int i=0; i<targetString.length; i++)
    {
        oneChar = [targetString substringWithRange:NSMakeRange(i, 1)];
        if ([@"\\" isEqualToString:oneChar] || [@"{"isEqualToString:oneChar] || [@"}"isEqualToString:oneChar])
        {
            [ret_str appendString:[NSString stringWithFormat:@"\\%@",oneChar]];
            continue;
        }
        [ret_str appendString:oneChar];
    }
    
    return ret_str;
    
}

@end

@implementation CSTextCompoment

-(id)init
{
    self = [super init];
    if (self) {
        // // init codes
        [self variablesInit];
    }
    return self;
}

-(void)variablesInit
{
    self.showText = @"";
    self.specialTextCompoments = @[];
    self.imgCompoments = @[];
    self.imgAniCompoments = @[];
}

@end
