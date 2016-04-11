//
//  CustomLabelView.m
//  beatmasterSNS
//
//  Created by chengsong on 12-11-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomLabelView.h"
/*
 *  @brief: 特殊Label摆放
 */
@interface CustomLabelView()
-(void)createCustomLabelView;
-(void)makeSureCustomLabelViewStyle;

@end
@implementation CustomLabelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame words:(NSString *)words userInfoStyle:(int)userInfoStyle
{
    self = [super initWithFrame:frame];
    if (self) {
        // // init codes
        _showWords = nil;
        _userInfoStyle = userInfoStyle;
        
        if (words != nil && [words isKindOfClass:[NSString class]])
        {
            _showWords = [words copy];
        }
        [self createCustomLabelView];
    }
    
    return self;
}

-(void)dealloc
{
    [_bgView release];
    [_firstWordLabel release];
    [_secondWordLabel release];
    [_thirdWordLabel release];
    [_showWords release];
    [super dealloc];
}

#pragma mark - private methods
-(void)createCustomLabelView
{
    if (_showWords == nil || [_showWords isEqualToString:@""])
    {
        _showWords = [MultiLanguage(clvNShow) retain];
    }
    SNSLog(@"showWords:%d",_showWords.length);
    
    
    [self makeSureCustomLabelViewStyle];
    
    int font_first = 0;
    int font_second = 0;
    int font_third = 0;
    CGRect frame_first = CGRectZero;
    CGRect frame_second = CGRectZero;
    CGRect frame_third = CGRectZero;
    NSString *words_label_1 = nil;
    NSString *words_label_2 = nil;
    NSString *words_label_3 = nil;
    
    switch (_style)
    {
        case CustomLabelViewStyleNoWords:
        {
            font_first = 20*SNS_SCALE;
            frame_first = CGRectMake(5*SNS_SCALE, 1*SNS_SCALE, 80*SNS_SCALE, 20*SNS_SCALE);
            words_label_1 = @"";
            
            font_second = 16*SNS_SCALE;
            frame_second = CGRectMake(7*SNS_SCALE, 5*SNS_SCALE, 80*SNS_SCALE, 20*SNS_SCALE);
            words_label_2 = @"";
        }
            break;
        case CustomLabelViewStyleNotMoreThan4:
        {
            font_first = 20*SNS_SCALE;
            frame_first = CGRectMake(5*SNS_SCALE, 1*SNS_SCALE, 80*SNS_SCALE, 20*SNS_SCALE);
            words_label_1 = [_showWords substringToIndex:1];
            
            font_second = 16*SNS_SCALE;
            frame_second = CGRectMake(7*SNS_SCALE, 5*SNS_SCALE, 80*SNS_SCALE, 20*SNS_SCALE);
            words_label_2 = [_showWords substringFromIndex:1];
        }
            break;
        case CustomLabelViewStyleEqual5:
        {
            font_first = 19*SNS_SCALE;
            frame_first = CGRectMake(3*SNS_SCALE, 1*SNS_SCALE, 80*SNS_SCALE, 20*SNS_SCALE);
            words_label_1 = [_showWords substringToIndex:1];
            
            font_second = 14*SNS_SCALE;
            frame_second = CGRectMake(3*SNS_SCALE, 6*SNS_SCALE, 90*SNS_SCALE, 20*SNS_SCALE);
            words_label_2 = [_showWords substringFromIndex:1];
        }
            break;
        case CustomLabelViewStyle6plus_Line1_4:
        {
            font_first = 16*SNS_SCALE;
            frame_first = CGRectMake((5+7)*SNS_SCALE, -3*SNS_SCALE, 80*SNS_SCALE, 20*SNS_SCALE);
            words_label_1 = [_showWords substringToIndex:1];
            
            font_second = 12*SNS_SCALE;
            frame_second = CGRectMake((5+8)*SNS_SCALE, 2*SNS_SCALE, 85*SNS_SCALE, 20*SNS_SCALE);
            NSRange secondRange;
            secondRange.location = 1;
            secondRange.length = _firstBlankIndex - 1;
            words_label_2 = [_showWords substringWithRange:secondRange];
            
            font_third = 10*SNS_SCALE;
            frame_third = CGRectMake((5+8)*SNS_SCALE, -2*SNS_SCALE, 85*SNS_SCALE, 20*SNS_SCALE);
            words_label_3 = [_showWords substringFromIndex:_firstBlankIndex];
            words_label_3 = [words_label_3 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
            break;
        case CustomLabelViewStyle6plus_Line1_5plus:
        {
            font_first = 16*SNS_SCALE;
            frame_first = CGRectMake(5*SNS_SCALE, -3*SNS_SCALE, 80*SNS_SCALE, 20*SNS_SCALE);
            words_label_1 = [_showWords substringToIndex:1];
            
            font_second = 12*SNS_SCALE;
            frame_second = CGRectMake(5*SNS_SCALE, 2*SNS_SCALE, 85*SNS_SCALE, 20*SNS_SCALE);
            NSRange secondRange;
            secondRange.location = 1;
            secondRange.length = 5;
            words_label_2 = [_showWords substringWithRange:secondRange];
            
            font_third = 10*SNS_SCALE;
            frame_third = CGRectMake(5*SNS_SCALE, -2*SNS_SCALE, 85*SNS_SCALE, 20*SNS_SCALE);
            words_label_3 = [_showWords substringFromIndex:6];
            words_label_3 = [words_label_3 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
            break;
        default:
            break;
    }
    
    
    
    // // 背景View
    NSString* bgImgString = [NSString stringWithFormat:@"UI_achivementBg%02d.png", _userInfoStyle];
    UIImage *bgImg = [UIImage imageNamed_New:bgImgString];
    _bgView = [[UIImageView alloc]initWithImage:bgImg];
    _bgView.frame = SNSRect(0, 0, bgImg.size.width * SNS_SCALE, bgImg.size.height*SNS_SCALE);
    [self addSubview:_bgView];
    // NSString *firstWord = [_showWords substringToIndex:1];
    
    // // 第一个字Label .HelveticaNeueUI-BoldItalic
    //UIFont *font1 = [UIFont systemFontOfSize:12*SNS_SCALE];
    //NSString *firstFontName = [font1.fontName stringByAppendingFormat:@"%@",@"-BoldItalic"];
    NSString *firstFontName = @".HelveticaNeueUI-BoldItalic";
    UIFont *firstFontBoldItalic = [UIFont fontWithName:firstFontName size:font_first];
    if (firstFontBoldItalic == nil)
    {
        firstFontBoldItalic = [UIFont boldSystemFontOfSize:font_first];
    }
    _firstWordLabel = [[UILabel alloc]initWithFrame:frame_first];
    [Utils autoTextSizeLabel:_firstWordLabel font:firstFontBoldItalic labelAlign:AutoTextSizeLabelAlignLeft frame:frame_first text:words_label_1 textColor:[UIColor yellowColor]];
    
    // // 第二个Label
    int secondTmpX = frame_second.origin.x;
    int secondTmpWidth = frame_second.size.width;
    frame_second.origin.x = secondTmpX + _firstWordLabel.frame.size.width;
    frame_second.size.width = secondTmpWidth - _firstWordLabel.frame.size.width - secondTmpX;
    
    _secondWordLabel = [[UILabel alloc]initWithFrame:frame_second];
    [Utils autoTextSizeLabel:_secondWordLabel font:[UIFont boldSystemFontOfSize:font_second] labelAlign:AutoTextSizeLabelAlignLeft frame:frame_second text:words_label_2 textColor:[UIColor whiteColor]];
    
    // // 第三个Label
    int thirdTmpX = frame_third.origin.x;
    int thirdTmpWidth = frame_third.size.width;
    frame_third.origin.x = thirdTmpX + _firstWordLabel.frame.size.width;
    frame_third.origin.y = _secondWordLabel.frame.origin.y + _secondWordLabel.frame.size.height + frame_third.origin.y;
    frame_third.size.width = thirdTmpWidth - _firstWordLabel.frame.size.width  - thirdTmpX;
    
    _thirdWordLabel = [[UILabel alloc]initWithFrame:frame_third];
    [Utils autoTextSizeLabel:_thirdWordLabel font:[UIFont boldSystemFontOfSize:font_third] labelAlign:AutoTextSizeLabelAlignLeft frame:frame_third text:words_label_3 textColor:[UIColor whiteColor]];
    
    [_bgView addSubview:_firstWordLabel];
    [_bgView addSubview:_secondWordLabel];
    [_bgView addSubview:_thirdWordLabel];
    //[self addSubview:_secondWordLabel];
    
}

-(void)makeSureCustomLabelViewStyle
{
    if (_showWords == nil)
    {
        _showWords = [MultiLanguage(clvNShow) retain];
    }
    
    unichar word;
    _firstBlankIndex = 0;
    int wordCount = 0;
    int wordCount_blank = 0;
    int wordCount_en = 0;
    int wordCount_ch = 0;
    for (int i=0; i<_showWords.length; i++)
    {
        word = [_showWords characterAtIndex:i];
        if (isblank(word))
        {
            wordCount_blank++;
            if (_firstBlankIndex==0 && i != 0)
            {
                _firstBlankIndex = i;
            }
        }
        else if (isascii(word))
        {
            wordCount_en++;
        }
        else
        {
            wordCount_ch++;
        }
    }
    
    wordCount = wordCount_ch + ceilf(wordCount_blank + wordCount_en)/2.0;
    
    switch (wordCount)
    {
        case 0:
            _style = CustomLabelViewStyleNoWords;
            break;
        case 1:
        case 2:
        case 3:
        case 4:
            _style = CustomLabelViewStyleNotMoreThan4;
            break;
        case 5:
            _style = CustomLabelViewStyleEqual5;
            break;
            
        default:
            if (wordCount_blank == 4)
            {
                _style = CustomLabelViewStyle6plus_Line1_4;
            }
            else {
                _style = CustomLabelViewStyle6plus_Line1_5plus;
            }
            break;
    }
    
}

@end
