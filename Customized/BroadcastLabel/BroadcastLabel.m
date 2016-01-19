//
//  BroadcastLabel.m
//  beatmasterSNS
//
//  Created by chengsong on 12-12-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BroadcastLabel.h"
#import <CoreText/CoreText.h>

@implementation MessageSize
@synthesize size,lineCount,lineHeight;

- (id)init
{
    self = [super init];
    if (self){
        // // initialize codes
        self.size = CGSizeZero;
        self.lineCount = 0;
        self.lineHeight = 0.0f;
    }
    
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

@end


@interface BroadcastLabel()
-(NSString *)analysisString:(NSString *)needAnalysisString;
-(void)doSetAttributeString;

@end
@implementation BroadcastLabel
@synthesize needDisplayString = _needDisplayString;


- (id)initWithFrame:(CGRect)frame broadcastText:(NSString *)broadcastText color:(UIColor *)color norColor:(UIColor *)norColor
{
    self = [super initWithFrame:frame];
    if (self) {
        // // init codes;
        _specialTextColor = [color retain];
        _normalTextColor = [norColor retain];
        _textString = [broadcastText copy];
        self.font = [UIFont boldSystemFontOfSize:15*SNS_SCALE];
        _isNeedAddAttribute = YES;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (_isNeedAddAttribute)
    {
        [self doAddAttributeForText:_textString color:_specialTextColor norColor:_normalTextColor];
    }
    
    if (_needDisplayString != nil)
    {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 0.0, 0.0);//move
        CGContextScaleCTM(context, 1.0, -1.0);
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_needDisplayString);
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGPathAddRect(pathRef,NULL , CGRectMake(0, 0.0f, self.bounds.size.width, self.bounds.size.height));//const CGAffineTransform *m
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), pathRef,NULL );//CFDictionaryRef frameAttributes
        CGContextTranslateCTM(context, 0, -self.bounds.size.height);
        CGContextSetTextPosition(context, 0, 0);
        CTFrameDraw(frame, context);
        CGContextRestoreGState(context);
        CGPathRelease(pathRef);
        CFRelease(framesetter);
        CFRelease(frame);
        UIGraphicsPushContext(context);
    }
    
}
-(void)dealloc
{
    if (_needDisplayString != nil)
    {
        [_needDisplayString release];
    }
    
    if (_textString != nil)
    {
        [_textString release];
    }
    if (_specialTextColor != nil)
    {
        [_specialTextColor release];
    }
    if (_normalTextColor)
    {
        [_normalTextColor release];
    }
    
    [super dealloc];
    //SNSLog(@"%s",__FUNCTION__);
}

-(void)setNeedDisplayString:(NSAttributedString *)needDisplayString
{
    if ([needDisplayString isEqualToAttributedString:_needDisplayString])
    {
        return;
    }
    if (_needDisplayString != nil)
    {
        [_needDisplayString release];
    }
    _needDisplayString = [needDisplayString copy];
    
    [super setText:_needDisplayString.string];
    
    _isNeedAddAttribute = NO;
    
    [self setNeedsDisplay];
}

-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    _isNeedAddAttribute = YES;
    [self setNeedsDisplay];
    
}

-(void)setText:(NSString *)text
{
    [super setText:text];
    if (_textString != nil)
    {
        if ([text isEqualToString:_textString])
        {
            return;
        }
        [_textString release];
        _textString = [text copy];
    }
    else
    {
        _textString = [text copy];
    }
    
    _isNeedAddAttribute = YES;
    [self setNeedsDisplay];
}

#pragma mark - private methods
/*
 *  @brief: 设置字符串的属性，针对非广播Message使用BroadcastLabel
 */
-(void)doAddAttributeForText:(NSString *)text color:(UIColor *)color norColor:(UIColor *)norColor
{
    if (text == nil || ![text isKindOfClass:[NSString class]])
    {
        return;
    }
    
    ColorStringAnalysis *analysisClass = [[[ColorStringAnalysis alloc]init]autorelease];
    
    NSString *analysedStr = [analysisClass analysisString:text];
    NSAttributedString *attrStr = [analysisClass doSetAttributeString:analysedStr normalColor:norColor specialColor:color font:self.font];
    
    self.needDisplayString = attrStr;
}

@end


//**************************//
// // 彩色Label字符串处理类 // //
//*************************//
@implementation ColorStringAnalysis

- (id)init
{
    self = [super init];
    if (self) {
        // // initialize codes
        
    }
    
    return self;
}

-(void)dealloc
{
    [_rangeArray release];
    [super dealloc];
}

#pragma mark - public methods

/*
 *  @brief: 分析字符串
 */
-(NSString *)analysisString:(NSString *)needAnalysisString
{
    if (needAnalysisString == nil || [@"" isEqualToString:needAnalysisString])
    {
        return nil;
    }
    if (_rangeArray != nil)
    {
        [_rangeArray release];
        _rangeArray = nil;
    }
    
    //SNS_RELEASE_NIL(_rangeArray);
    _rangeArray = [[NSMutableArray alloc]init];
    
    NSMutableString *ret_str = [[[NSMutableString alloc]init]autorelease];
    NSInteger startIndex = -1;
    NSInteger rangeLength = 0;
    NSString *oneCharactor = @"";
    NSInteger stringLength = needAnalysisString.length;
    
    for (int i=0; i<stringLength; i++)
    {
        oneCharactor = [needAnalysisString substringWithRange:NSMakeRange(i, 1)];
        
        // " \ "
        if ([@"\\" isEqualToString:oneCharactor])
        {
            // // 如果遇到"\"，后面还有字就正常加上显示字符串，没有就不要这个"\"
            if (i+1 < stringLength)
            {
                [ret_str appendString:[needAnalysisString substringWithRange:NSMakeRange(i+1, 1)]];
                i++;
                if (-1 != startIndex)
                {
                    rangeLength++;
                }
            }
            continue;
            
        }
        // " { "
        if ([@"{" isEqualToString:oneCharactor])
        {
            // // 如果遇到"{"，纪录特殊显示字符串开始位置，连续的"{{",只纪录最开始的一个的位置
            if (-1 == startIndex)
            {
                startIndex = ret_str.length;
            }
            continue;
        }
        // " } "
        if ([@"}" isEqualToString:oneCharactor])
        {
            // // 在找到"{"的情况下，遇到第一个"}"关闭这个特殊区间
            if (-1 != startIndex)
            {
                if (startIndex>=0 && startIndex<stringLength && rangeLength>0)
                {
                    [_rangeArray addObject:[NSValue valueWithRange:NSMakeRange(startIndex, rangeLength)]];
                }
                startIndex = -1;
                rangeLength = 0;
            }
            continue;
        }
        
        [ret_str appendString:oneCharactor];
        if (-1 != startIndex)
        {
            rangeLength++;
        }
    }
    
    return ret_str;
    
}

/*
 *  @brief: 属性设置
 *  @param:
 *      analysedSring:  已经分析过的字符串，去掉了"{"和"}"
 *      normalColor  :  一般字符串颜色
 *      specialColor :  特殊字符串颜色
 *      font         :  字符串字体
 */
-(NSAttributedString *)doSetAttributeString:(NSString *)analysedString normalColor:(UIColor *)normalColor specialColor:(UIColor *)specialColor font:(UIFont *)font;
{
    if (analysedString == nil)
    {
        //SNSLog(@"%s error:analysedString==nil",__FUNCTION__);
        return nil;
    }
    UIColor *displayColor_nor = [UIColor blackColor];
    UIColor *displayColor_spe = [UIColor redColor];
    UIFont  *displayFont = [UIFont systemFontOfSize:15*SNS_SCALE];
    if (normalColor != nil)
    {
        displayColor_nor = normalColor;
    }
    if (specialColor != nil)
    {
        displayColor_spe = specialColor;
    }
    if (font != nil)
    {
        displayFont = font;
    }
    NSMutableAttributedString *needDisplayString = [[NSMutableAttributedString alloc]initWithString:analysedString];
    [needDisplayString addAttribute:(NSString *)(kCTForegroundColorAttributeName) value:(id)displayColor_nor.CGColor range:NSMakeRange(0, analysedString.length)];
    for (NSValue *value in _rangeArray)
    {
        [needDisplayString addAttribute:(NSString *)(kCTForegroundColorAttributeName) value:(id)displayColor_spe.CGColor range:[value rangeValue]];
    }
    
    id customFondId = (id)CTFontCreateWithName((CFStringRef)displayFont.fontName,font.pointSize , NULL);
    [needDisplayString addAttribute:(NSString *)kCTFontAttributeName
                              value:customFondId range:NSMakeRange(0, analysedString.length)];
    
    CFRelease(customFondId);
    
    return [needDisplayString autorelease];
}

/*
 *  @brief: 获取字符串占的行高
 */
-(CGFloat)doGetLineHeightOfNeedDisplayString:(NSAttributedString *)needDisplayString
{
    CGFloat retHeight = 0.0f;
    
    if (needDisplayString == nil)
    {
        return retHeight;
    }
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)needDisplayString);
    // // 字符串占据size属性
    CGSize needSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter,CFRangeMake(0, 0),NULL,CGSizeMake(99999, 99999),NULL);
    
    retHeight = needSize.height;
    CFRelease(frameSetter);
    
    return retHeight;
}

-(NSDictionary *)getAllLinesArrOfAttrStrInLabel:(CGSize)size wholeAttrStr:(NSAttributedString *)wholeAttStr
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)wholeAttStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,size.width,99999));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    // // 长属性字符串分行
    NSArray *lines = (NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[[NSMutableArray alloc]init]autorelease];
    
    for (id line in lines)
    {
        CTLineRef lineRef = (CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSAttributedString *lineString = [wholeAttStr attributedSubstringFromRange:range];
        [linesArray addObject:lineString];
    }
    
    // // 字符串占据size属性
    CGSize needSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter,CFRangeMake(0, 0),NULL,CGSizeMake(99999, 99999),NULL);
    MessageSize *msgSize = [[MessageSize alloc]init];
    msgSize.size = needSize;
    msgSize.lineCount = [linesArray count];
    msgSize.lineHeight = needSize.height;
    
    
    dict[kKeyOfAttributedStringMsgSize] = msgSize;
    dict[kKeyOfAttributedStringArr] = linesArray;
    
    CFRelease(frameSetter);
    CFRelease(path);
    CFRelease(frame);
    [msgSize release];
    
    return (NSDictionary *)dict;
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
    
    NSMutableString *ret_str = [[[NSMutableString alloc]init]autorelease];
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
