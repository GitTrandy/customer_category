//
//  CSTextView.m
//  CoreTextTest
//
//  Created by chengsong on 13-10-9.
//  Copyright (c) 2013年 chengsong. All rights reserved.
//

#import "CSTextView.h"
@interface CSTextView()

//// // 字符串分析之后的数据集合
//@property(nonatomic,strong)CSTextCompoment *csTextCompoment;

// // 当前被点击的对象的Range的Location
@property(nonatomic,assign)int currentClickTextLocation;
@end

@implementation CSTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self variableInit];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    [self drawTextView:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, SCREEN_HEIGHT)];
}

-(void)setOriginalString:(NSString *)originalString
{
    if (_originalString != originalString)
    {
        _originalString = [originalString copy];
        CSTextParser *parser = [[CSTextParser alloc]init];
        _csTextCompoment = [parser analysisString:originalString];
        
        [self setNeedsDisplay];
    }
}
-(void)setNormalFont:(UIFont *)normalFont
{
    if (_normalFont != normalFont)
    {
        _normalFont = [normalFont copy];
        [self setNeedsDisplay];
    }
}
-(void)setNormalColor:(UIColor *)normalColor
{
    if (_normalColor != normalColor)
    {
        _normalColor = [normalColor copy];
        [self setNeedsDisplay];
    }
}
-(void)setTextAlignment:(CSTextAlignment)textAlignment
{
    if (_textAlignment != textAlignment)
    {
        _textAlignment = textAlignment;
        [self setNeedsDisplay];
    }
}
-(void)setTextLineBreakMode:(CSLineBreakMode)textLineBreakMode
{
    if (_textLineBreakMode != textLineBreakMode)
    {
        _textLineBreakMode = textLineBreakMode;
        [self setNeedsDisplay];
    }
}
-(void)setCsTextCompoment:(CSTextCompoment *)csTextCompoment
{
    _csTextCompoment = csTextCompoment;
    [self setNeedsDisplay];
}
-(void)variableInit
{
    _originalString = nil;
    _normalFont = TVDefaultFont;
    _normalColor = [UIColor blackColor];
    _textAlignment = CSTextAlignmentLeft;
    _textLineBreakMode = CSLineBreakByCharWrapping;
    _currentClickTextLocation = -1;
    self.backgroundColor = [UIColor whiteColor];
    
}

#pragma mark - Image CTRunDelegate
#pragma mark
void CSTVCTRunDelegateDeallocCallback(void *refCon)
{
    CFRelease(refCon);
}
CGFloat CSTVCTRunDelegateGetAscentCallback(void *refCon)
{
    NSDictionary *dict = (__bridge NSDictionary *)(refCon);
    NSString *imgName = dict[TVImageName];
    CGFloat margin = [dict[TVImgYmargin]floatValue];
    
    CGFloat ascent = 0.0f;
    //NSString *imgName = [NSString stringWithUTF8String:refCon];
    ascent = [UIImage imageNamed_New:imgName].size.height*SNS_SCALE - margin*SNS_SCALE;
    return ascent;
}
CGFloat CSTVCTRunDelegateGetDescentCallback(void *refCon)
{
    CGFloat descent = 0.0f;
    NSDictionary *dict = (__bridge NSDictionary *)(refCon);
    descent = [dict[TVImgYmargin]floatValue]*SNS_SCALE;
    
    return descent;
}
CGFloat CSTVCTRunDelegateGetCTRunWithCallback(void *refCon)
{
    NSDictionary *dict = (__bridge NSDictionary *)(refCon);
    NSString *imgName = dict[TVImageName];
    
    CGFloat width = 0.0f;
    //NSString *imgName = [NSString stringWithUTF8String:refCon];
    width = [UIImage imageNamed_New:imgName].size.width*SNS_SCALE;
    return width;
}

-(CTRunDelegateRef)imgCTRunDelegateCreateWithKey:(NSDictionary *)key
{
    CTRunDelegateCallbacks  imgCallbacks;
    imgCallbacks.version = kCTRunDelegateCurrentVersion;
    imgCallbacks.dealloc = CSTVCTRunDelegateDeallocCallback;
    imgCallbacks.getAscent = CSTVCTRunDelegateGetAscentCallback;
    imgCallbacks.getDescent = CSTVCTRunDelegateGetDescentCallback;
    imgCallbacks.getWidth = CSTVCTRunDelegateGetCTRunWithCallback;
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imgCallbacks, (__bridge_retained void *)key);
    
    
    return runDelegate;
}

#pragma mark - Private Methods
#pragma mark
-(void)drawTextView:(CGRect)rect
{
    if (!_csTextCompoment)
    {
        return;
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0.0f, rect.size.height);
    CGContextScaleCTM(ctx, 1.0f, -1.0f);
    
    CGContextSaveGState(ctx);
    
    // // 字符串
    NSMutableAttributedString *maString = [[NSMutableAttributedString alloc]initWithString:_csTextCompoment.showText];
    // // 增加字符串各种属性
    [self addTextBaseAttribute:maString];
    [self addTextAttribute:maString attrDicts:_csTextCompoment.specialTextCompoments type:TVTypeText];
    [self addTextAttribute:maString attrDicts:_csTextCompoment.imgCompoments type:TVTypeImg];
    [self addTextAttribute:maString attrDicts:_csTextCompoment.imgAniCompoments type:TVTypeImgAni];
    
    // // 字符Frame
    CTFramesetterRef ctfSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)(maString));
    CGMutablePathRef textPath = CGPathCreateMutable();
    CGPathAddRect(textPath, NULL, rect);
    CTFrameRef ctf = CTFramesetterCreateFrame(ctfSetter, CFRangeMake(0, 0), textPath, NULL);
    CTFrameDraw(ctf, ctx);
    
    if (_currentClickTextLocation == -1)
    {
        for (UIView *subView in [self subviews])
        {
            [subView removeFromSuperview];
        }
        // // 设置可点击的文字
        [self addTextClickAttributeWithCTFrame:ctf rect:rect];
        // // 设置图片动画
        [self addImageOrImgAniWithCTFrame:ctf context:ctx rect:rect imgType:TVTypeImgAni];
    }
    // // 设置图片
    [self addImageOrImgAniWithCTFrame:ctf context:ctx rect:rect imgType:TVTypeImg];
    
    CFRelease(ctfSetter);
    CFRelease(ctf);
    CGPathRelease(textPath);
    CGContextRestoreGState(ctx);
    
}

-(CGSize)doGetMinSizeInContainSize:(CGSize)containSize
{
    // // 字符串
    NSMutableAttributedString *maString = [[NSMutableAttributedString alloc]initWithString:_csTextCompoment.showText];
    // // 增加字符串各种属性
    [self addTextBaseAttribute:maString];
    [self addTextAttribute:maString attrDicts:_csTextCompoment.specialTextCompoments type:TVTypeText];
    [self addTextAttribute:maString attrDicts:_csTextCompoment.imgCompoments type:TVTypeImg];
    [self addTextAttribute:maString attrDicts:_csTextCompoment.imgAniCompoments type:TVTypeImgAni];
    
    // // 字符Frame
    CTFramesetterRef ctfSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)(maString));
    
    CGSize ret_size = CTFramesetterSuggestFrameSizeWithConstraints(ctfSetter, CFRangeMake(0, 0), NULL, containSize, NULL);
    
    CFRelease(ctfSetter);
    return ret_size;
    
}

/*
 *  @brief: 增加文字可点击的属性
 */
-(void)addTextClickAttributeWithCTFrame:(CTFrameRef)ctf rect:(CGRect)rect
{
    if (!ctf)
    {
        return;
    }
    if (_csTextCompoment.specialTextCompoments == nil || _csTextCompoment.specialTextCompoments.count == 0)
    {
        return;
    }
    
    NSMutableArray *canBeClickedCompoments = [[NSMutableArray alloc]init];
    for (NSDictionary *dictTmp in _csTextCompoment.specialTextCompoments)
    {
        NSString *clickType = dictTmp[TVClick];
        if (clickType != nil)
        {
            [canBeClickedCompoments addObject:dictTmp];
        }
    }
    if (canBeClickedCompoments.count == 0)
    {
        return;
    }
    
    CFArrayRef lines = CTFrameGetLines(ctf);
    int linesCount = CFArrayGetCount(lines);
    CGPoint lineOrigins[linesCount];
    CTFrameGetLineOrigins(ctf, CFRangeMake(0, 0), lineOrigins);
    int clickCount = canBeClickedCompoments.count;
    
    int lastShowedIndex = 0;
    for (int i=0; i<linesCount; i++)
    {
        if (lastShowedIndex == clickCount)
        {
            break;
        }
        CTLineRef oneLine = (CTLineRef)CFArrayGetValueAtIndex(lines, i);
        CFRange lineRange = CTLineGetStringRange(oneLine);
        int lineLoc = lineRange.location;
        int lineLen = lineRange.length;
        CGFloat lineAsc = 0.0f;
        CGFloat lineDes = 0.0f;
        CGFloat lineLeading = 0.0f;
        CTLineGetTypographicBounds(oneLine, &lineAsc, &lineDes, &lineLeading);
        CGPoint linePoint = lineOrigins[i];
        for (int j=lastShowedIndex; j<clickCount && j>=0; j++)
        {
            int textLoc = [canBeClickedCompoments[j][TVRLocation]integerValue];
            int textLen = [canBeClickedCompoments[j][TVRLength]integerValue];
            if ((lineLoc <= textLoc && textLoc+textLen <= lineLoc+lineLen) || (lineLoc <= textLoc && textLoc < lineLoc+lineLen && textLoc+textLen > lineLoc+lineLen) || (lineLoc > textLoc && lineLoc < textLoc+textLen))
            {
                CGFloat xOffset_front = CTLineGetOffsetForStringIndex(oneLine, textLoc, NULL);
                CGFloat xOffset_back = CTLineGetOffsetForStringIndex(oneLine, textLoc+textLen, NULL);
                CGFloat xOriginX = linePoint.x + xOffset_front;
                CGFloat xWidth = xOffset_back - xOffset_front;
                CGFloat xHeight = lineAsc+abs(lineDes);
                CGFloat xOriginY = rect.size.height-linePoint.y-lineAsc;
                
                CGRect btnRect = CGRectMake(xOriginX, xOriginY, xWidth, xHeight);
                
                NSString *btnType = canBeClickedCompoments[j][TVClick];
                NSString *btnInfo = canBeClickedCompoments[j][TVInfo];
                
                [self addClickBtnWithRect:btnRect type:btnType info:btnInfo tag:textLoc];
                
                lastShowedIndex = j;
                if (textLoc+textLen <= lineLoc+lineLen)
                {
                    lastShowedIndex++;
                }
                continue;
            }
            break;
        }
        
    }
    
}

/*
 *  @brief:
 */
-(void)addClickBtnWithRect:(CGRect)btnRect type:(NSString *)btnType info:(NSString *)btnInfo tag:(int)location
{
    CSTextButton *btn = [[CSTextButton alloc]initWithFrame:btnRect];
    btn.btnType = btnType;
    btn.btnInfo = btnInfo;
    btn.tag = location;
    [btn addTarget:self action:@selector(csTextBtnClickDown:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(csTextBtnClickToOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [btn addTarget:self action:@selector(csTextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //btn.backgroundColor = [UIColor yellowColor];
    //btn.alpha = 0.3f;
    
    [self addSubview:btn];
}

/*
 *  @brief: 增加文本中显示的图片或者图片桢动画
 */
-(void)addImageOrImgAniWithCTFrame:(CTFrameRef)ctf context:(CGContextRef)ctx rect:(CGRect)rect imgType:(NSString *)type
{
    if (!ctf)
    {
        return;
    }
    NSArray *arrCompoments = nil;
    BOOL isImg = NO;
    if ([TVTypeImg isEqualToString:type])
    {
        arrCompoments = _csTextCompoment.imgCompoments;
        isImg = YES;
    }
    else if ([TVTypeImgAni isEqualToString:type])
    {
        arrCompoments = _csTextCompoment.imgAniCompoments;
    }
    if (arrCompoments == nil || arrCompoments.count == 0)
    {
        return;
    }
    
    CFArrayRef lines = CTFrameGetLines(ctf);
    int linesCount = CFArrayGetCount(lines);
    CGPoint lineOrigins[linesCount];
    CTFrameGetLineOrigins(ctf, CFRangeMake(0, 0), lineOrigins);
    int lastShowedIndex = -1;
    int compomentsCount = arrCompoments.count;
    for (int i=0; i<linesCount; i++)
    {
        if (lastShowedIndex == compomentsCount-1)
        {
            break;
        }
        CTLineRef oneLine = (CTLineRef)CFArrayGetValueAtIndex(lines, i);
        CFRange lineRange = CTLineGetStringRange(oneLine);
        CGFloat lineAsc = 0.0f;
        CGFloat lineDes = 0.0f;
        CGFloat lineLeading = 0.0f;
        CTLineGetTypographicBounds(oneLine, &lineAsc, &lineDes, &lineLeading);
        CGPoint xPoint = lineOrigins[i];
        for (int j=lastShowedIndex+1; j<compomentsCount && j>=0; j++)
        {
            NSDictionary *compomentsDict = arrCompoments[j];
            
            int location = [compomentsDict[TVRLocation]integerValue];
            if (lineRange.location <= location && location < lineRange.location+lineRange.length)
            {
                CGFloat xOffset = CTLineGetOffsetForStringIndex(oneLine, location, NULL);
                CGPoint imgPoint = CGPointMake(xPoint.x+xOffset, xPoint.y);
                
                UIImage *img = [UIImage imageNamed_New:compomentsDict[TVImageName]];
                NSString *margin = compomentsDict[TVImgYmargin];
                if (margin == nil)
                {
                    margin = @"0.0";
                }
                
                if (isImg)
                {
                    // // 图片
                    CGRect imgRect = CGRectMake(imgPoint.x, imgPoint.y-[margin floatValue]*SNS_SCALE, img.size.width*SNS_SCALE, img.size.height*SNS_SCALE);
                    CGContextDrawImage(ctx, imgRect, img.CGImage);
                }
                else
                {
                    // // 图片动画
                    //UIImage *img00 = [UIImage imageNamed:compomentsDict[TVImageName]];
                    CGRect imgAniRect = CGRectMake(imgPoint.x, rect.size.height-imgPoint.y-img.size.height*SNS_SCALE+[margin floatValue]*SNS_SCALE, img.size.width*SNS_SCALE, img.size.height*SNS_SCALE);
                    [self addImgAniView:imgAniRect dict:compomentsDict];
                }
                
                lastShowedIndex = j;
                continue;
            }
            break;
        }
        
    }
}
/*
 *  @brief: 在某个位置显示图片动画
 */
-(void)addImgAniView:(CGRect)imgAniRect dict:(NSDictionary *)compomentsDict
{
    NSString *imgName00 = compomentsDict[TVImageName];
    int imgMaxIndex = [compomentsDict[TVImgMaxIndex] intValue];
    imgMaxIndex = MAX(imgMaxIndex, 0);
    NSArray *tmpArr = [imgName00 componentsSeparatedByString:@"."];
    if (tmpArr && tmpArr.count==2)
    {
        NSString *imgName00Prefix = tmpArr[0];
        int prefixLen = imgName00Prefix.length;
        NSString *imgNamePrefix = [imgName00Prefix substringToIndex:prefixLen-2];
        NSString *imgName00Suffix = tmpArr[1];
        NSMutableArray *imgArr = [NSMutableArray array];
        for (int k=0; k<=imgMaxIndex; k++)
        {
            NSString *imgName = [NSString stringWithFormat:@"%@%02d.%@",imgNamePrefix,k,imgName00Suffix];
            UIImage *imgTmp = [UIImage imageNamed_New:imgName];
            if (imgTmp)
            {
                [imgArr addObject:imgTmp];
            }
        }
        float duration = TVImgAniDefaultDuration;
        NSString *durationStr = compomentsDict[TVImgAniDuration];
        if (durationStr)
        {
            duration = [durationStr floatValue];
        }
        UIImage *img00 = [UIImage imageNamed_New:imgName00];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:img00];
        imgView.frame = imgAniRect;
        imgView.animationImages = imgArr;
        imgView.animationDuration = duration;
        [imgView startAnimating];
        [self addSubview:imgView];
    }
}

#pragma mark - Add Attributes For ShowText
#pragma mark
/*
 *  @brief: 增加整个文本的基本属性
 */
-(void)addTextBaseAttribute:(NSMutableAttributedString *)showAttrString
{
    NSRange range = NSMakeRange(0, showAttrString.mutableString.length);
    if (self.normalFont)
    {
        NSString *fontName = self.normalFont.fontName;
        float fontSize = self.normalFont.pointSize;
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)fontName, fontSize, NULL);
        [showAttrString addAttribute:(id)kCTFontAttributeName value:(__bridge id)font range:range];
        CFRelease(font);
    }
    
    if (self.normalColor)
    {
        [showAttrString addAttribute:(id)kCTForegroundColorAttributeName value:(id)self.normalColor range:range];
    }
    
    // // 对齐
    CTTextAlignment alignment = (CTTextAlignment)self.textAlignment;
    CTParagraphStyleSetting alignmentStyle;
    alignmentStyle.spec=kCTParagraphStyleSpecifierAlignment;
    alignmentStyle.valueSize=sizeof(alignment);
    alignmentStyle.value=&alignment;
    
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = (CTLineBreakMode)self.textLineBreakMode;
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    
    // //组合设置
    CTParagraphStyleSetting settings[] = {alignmentStyle,lineBreakMode};
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 2);
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(__bridge id)style forKey:(id)kCTParagraphStyleAttributeName ];
    [showAttrString addAttributes:attributes range:range];
    CFRelease(style);
    
}
/*
 *  @brief: 增加文本中的特殊文本、图片、图片动画的属性
 */
-(void)addTextAttribute:(NSMutableAttributedString *)showAttrString attrDicts:(NSArray *)attrDictArr type:(NSString *)type
{
    if (showAttrString==nil || attrDictArr==nil)
    {
        return;
    }
    if ([TVTypeText isEqualToString:type])
    {
        for (NSDictionary *textAttrDict in attrDictArr)
        {
            [self addStringAttribute:showAttrString attrDict:textAttrDict];
        }
    }
    else if ([TVTypeImg isEqualToString:type] || [TVTypeImgAni isEqualToString:type])
    {
        for (NSDictionary *imgAttrDict in attrDictArr)
        {
            [self addImgAttribute:showAttrString attrDict:imgAttrDict];
        }
    }
}
/*
 *  @brief: 增加特殊的文本的属性
 */
-(void)addStringAttribute:(NSMutableAttributedString *)showAttrString attrDict:(NSDictionary *)attrDict
{
    NSRange range = [self doGetAttrRangeWithString:showAttrString.mutableString attrDict:attrDict];
    if (NSEqualRanges(range, NSMakeRange(0, 0)))
    {
        return;
    }
    
    BOOL isClicked = (_currentClickTextLocation == range.location);
    
    // // 字体
    NSString *fontName = attrDict[TVFontName];
    NSString *fontSizeStr = attrDict[TVFontSize];
    float fontSize = _normalFont.pointSize;
    if (!fontName)
    {
        fontName = _normalFont.fontName;
    }
    if (fontSizeStr)
    {
        fontSize = [fontSizeStr floatValue];
    }
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)fontName, fontSize, NULL);
    [showAttrString addAttribute:(id)kCTFontAttributeName value:(__bridge id)font range:range];
    CFRelease(font);
    // // 字颜色
    NSString *colorStr = nil;
    if (isClicked)
    {
        colorStr = attrDict[TVClickColor];
    }
    if (colorStr == nil)
    {
        colorStr = attrDict[TVColor];
    }
    
    if (colorStr)
    {
        UIColor *color = [CSColorConvert getColorWithHexStr:colorStr];
        [showAttrString addAttribute:(id)kCTForegroundColorAttributeName value:(id)color range:range];
    }
    
    NSString *underLineType = attrDict[TVULineType];
    if (underLineType)
    {
        NSNumber *num = nil;
        switch ([underLineType intValue])
        {
            case 1:
                num = @(kCTUnderlineStyleSingle);
                break;
            case 2:
                num = @(kCTUnderlineStyleDouble);
                break;
                
            default:
                num = @(kCTUnderlineStyleSingle);
                break;
        }
        [showAttrString addAttribute:(id)kCTUnderlineStyleAttributeName value:(id)num range:range];
    }
    
    NSString *underLineColor = nil;
    if (isClicked)
    {
        underLineColor = attrDict[TVClickColor];
    }
    if (underLineColor == nil)
    {
        underLineColor = attrDict[TVULineColor];
    }
    if (underLineColor)
    {
        UIColor *ulc = [CSColorConvert getColorWithHexStr:underLineColor];
        [showAttrString addAttribute:(id)kCTUnderlineColorAttributeName value:(id)ulc range:range];
    }
    
}

/*
 *  @brief: 增加文本中的图片、图片动画的属性
 */
-(void)addImgAttribute:(NSMutableAttributedString *)showAttrString attrDict:(NSDictionary *)attrDict
{
    NSRange range = [self doGetAttrRangeWithString:showAttrString.mutableString attrDict:attrDict];
    if (NSEqualRanges(range, NSMakeRange(0, 0)))
    {
        return;
    }
    
    NSString *imgStr = attrDict[TVImageName];
    NSString *margin = attrDict[TVImgYmargin];
    if (margin == nil)
    {
        margin = @"0.0";
    }
    NSDictionary *dict = @{TVImageName: imgStr,TVImgYmargin:margin};
    if (imgStr)
    {
        CTRunDelegateRef runDelegate = [self imgCTRunDelegateCreateWithKey:dict];
        
        [showAttrString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge_transfer id)runDelegate range:range];
    }
    
}

/*
 *  @brief:     验证在showString增加属性的可行性，并且返回属性添加Range
 *  @param:     showString
 *              需要添加属性的目标字符串
 *  @param:     attrDict
 *              包括一系列属性的字典，也包括这些属性在showString上的影响范围Range
 *  @return:    如果可以添加属性，就返回范围Range，如果不可以添加属性，返回范围Range(0,0)
 */
-(NSRange)doGetAttrRangeWithString:(NSString *)showString attrDict:(NSDictionary *)attrDict
{
    NSRange ret_range = NSMakeRange(0, 0);
    
    if (showString == nil || attrDict == nil)
    {
        return ret_range;
    }
    
    int strLen = showString.length;
    if (strLen == 0)
    {
        return ret_range;
    }
    
    int location = -1;
    int length = -1;
    NSString *locationStr = attrDict[TVRLocation];
    NSString *lengthStr = attrDict[TVRLength];
    if (locationStr)
    {
        location = [locationStr integerValue];
    }
    if (lengthStr)
    {
        length = [lengthStr integerValue];
    }
    if (location < 0 || location > strLen-1 || length <=0)
    {
        return ret_range;
    }
    
    ret_range.location = location;
    ret_range.length = length;
    return ret_range;
}

#pragma mark - 获取整个view中，每行的字符串和该行的所有属性信息
#pragma mark
/*
 *  @brief: 取得每一行的字符串和该行的所有属性
 */
-(NSArray *)doGetLinesAttrCompomentsArr
{
    NSMutableArray *ret_arr = [[NSMutableArray alloc]init];
    // // 字符串
    NSMutableAttributedString *maString = [[NSMutableAttributedString alloc]initWithString:_csTextCompoment.showText];
    // // 增加字符串各种属性
    [self addTextBaseAttribute:maString];
    [self addTextAttribute:maString attrDicts:_csTextCompoment.specialTextCompoments type:TVTypeText];
    [self addTextAttribute:maString attrDicts:_csTextCompoment.imgCompoments type:TVTypeImg];
    [self addTextAttribute:maString attrDicts:_csTextCompoment.imgAniCompoments type:TVTypeImgAni];
    
    // // 字符Frame
    CTFramesetterRef ctfSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)(maString));
    CGMutablePathRef textPath = CGPathCreateMutable();
    CGPathAddRect(textPath, NULL, self.bounds);
    CTFrameRef ctf = CTFramesetterCreateFrame(ctfSetter, CFRangeMake(0, 0), textPath, NULL);
    
    CFArrayRef lines = CTFrameGetLines(ctf);
    int linesCount = CFArrayGetCount(lines);
    int curTextIndex = 0;
    int curImgIndex = 0;
    int curImgAniIndex = 0;
    for (int i=0; i<linesCount; i++)
    {
        CTLineRef oneLine = CFArrayGetValueAtIndex(lines, i);
        CFRange lineRange = CTLineGetStringRange(oneLine);
        NSString *lineStr = [_csTextCompoment.showText substringWithRange:NSMakeRange(lineRange.location, lineRange.length)];
        NSMutableArray *textComDicts = [[NSMutableArray alloc]init];
        NSMutableArray *imgComDicts = [[NSMutableArray alloc]init];
        NSMutableArray *imgAniComDicts = [[NSMutableArray alloc]init];
        CSTextCompoment *compoment = [[CSTextCompoment alloc]init];
        compoment.showText = lineStr;
        
        [self specialForEachLine:&curTextIndex specialArr:_csTextCompoment.specialTextCompoments dictArr:textComDicts range:lineRange];
        [self specialForEachLine:&curImgIndex specialArr:_csTextCompoment.imgCompoments dictArr:imgComDicts range:lineRange];
        [self specialForEachLine:&curImgAniIndex specialArr:_csTextCompoment.imgAniCompoments dictArr:imgAniComDicts range:lineRange];
        
        compoment.specialTextCompoments = textComDicts;
        compoment.imgCompoments = imgComDicts;
        compoment.imgAniCompoments = imgAniComDicts;
        
        [ret_arr addObject:compoment];
        
    }
    
    CFRelease(ctfSetter);
    CFRelease(ctf);
    CGPathRelease(textPath);
    return ret_arr;
}
-(void)specialForEachLine:(int*)curIndex specialArr:(NSArray *)specialArr dictArr:(NSMutableArray *)dictArr range:(CFRange)lineRange
{
    if ((!specialArr) || (specialArr.count==0) || (!dictArr))
    {
        return;
    }
    int index = *curIndex;
    int count = specialArr.count;
    int lineLoc = lineRange.location;
    int lineLen = lineRange.length;
    for (int i=index; i<count; i++)
    {
        NSMutableDictionary *textDict = [[NSMutableDictionary alloc]initWithDictionary:specialArr[i]];
        int textLoc = [textDict[TVRLocation]integerValue];
        int textLen = [textDict[TVRLength]integerValue];
        if ((lineLoc <= textLoc && textLoc+textLen <= lineLoc+lineLen))
        {
            NSString *textLocStr = [NSString stringWithFormat:@"%d",textLoc-lineLoc];
            NSString *textLenStr = [NSString stringWithFormat:@"%d",textLen];
            textDict[TVRLocation] = textLocStr;
            textDict[TVRLength] = textLenStr;
            [dictArr addObject:textDict];
            *curIndex = i;
            (*curIndex)++;
            continue;
            
        }
        else if (lineLoc <= textLoc && textLoc < lineLoc+lineLen && textLoc+textLen > lineLoc+lineLen)
        {NSString *textLocStr = [NSString stringWithFormat:@"%d",textLoc-lineLoc];
            NSString *textLenStr = [NSString stringWithFormat:@"%d",MIN(textLen, lineLoc+lineLen-textLoc)];
            textDict[TVRLocation] = textLocStr;
            textDict[TVRLength] = textLenStr;
            [dictArr addObject:textDict];
            *curIndex = i;
            continue;
            
        }
        else if ((lineLoc > textLoc && lineLoc < textLoc+textLen))
        {
            NSString *textLocStr2 = [NSString stringWithFormat:@"%d",0];
            NSString *textLenStr2 = [NSString stringWithFormat:@"%d",textLoc+textLen-lineLoc];
            textDict[TVRLocation] = textLocStr2;
            textDict[TVRLength] = textLenStr2;
            [dictArr addObject:textDict];
            *curIndex = i;
            (*curIndex)++;
            continue;
        }
        break;
    }
    
}

#pragma mark - CSTextButton Events Actions
#pragma mark
-(void)csTextBtnClickDown:(id)sender
{
    NSLog(@"btnClickDown");
    _currentClickTextLocation = ((CSTextButton *)sender).tag;
    [self setNeedsDisplay];
    
}
-(void)csTextBtnClickToOutside:(id)sender
{
    NSLog(@"btnClickTouchUpOut...");
    _currentClickTextLocation = -1;
    [self setNeedsDisplay];
}
-(void)csTextBtnClicked:(id)sender
{
    NSLog(@"btnClicked...");
    PlayEffect(SFX_BUTTON);
    _currentClickTextLocation = -1;
    [self setNeedsDisplay];
    
    NSString *type = ((CSTextButton *)sender).btnType;
    NSString *info = ((CSTextButton *)sender).btnInfo;
    NSLog(@"type:%@ info:%@",type,info);
    if (_delegate && [_delegate respondsToSelector:@selector(CSTextView:clickedWithType:withInfo:)])
    {
        [_delegate CSTextView:self clickedWithType:type withInfo:info];
    }
}

@end
