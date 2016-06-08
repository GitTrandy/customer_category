//
//  SNTextView.m
//  SnobMass
//
//  Created by 阿迪 on 16/6/7.
//  Copyright © 2016年 卷瓜. All rights reserved.
//

#import "SNTextView.h"


static NSString * const kLeftAt = @"<$";
static NSString * const kRightAt = @"$>";

@implementation SNTextView
@synthesize delegate = _delegate;

- (NSString *)atText
{
    return _atText;
}

- (void)setAtText:(NSString *)text
{
    NSString *str = text;
    _atText = text;
    NSArray *array = [[NSMutableArray alloc] initWithArray:[str componentsSeparatedByString:kLeftAt]];
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    NSMutableDictionary<NSString *,NSValue *> *rangeDic = [[NSMutableDictionary alloc] init];
    for (NSInteger i = 0; i < [array count]; i++)
    {
        NSString *tmp = array[i];
        //被<$分割的从i=1开始
        if (i == 0)
        {
            [resultStr appendString:tmp];
        }
        else
        {
            NSArray *tmpArray = [[NSMutableArray alloc] initWithArray:[tmp componentsSeparatedByString:kRightAt]];
            //分出两个以上数组才表示有正确结尾
            BOOL isEnd = ([tmpArray count] >= 2);
            
            if (isEnd)
            {
                //tmpArray[0]是@的内容
                NSString *atString = tmpArray[0];
                
                if (![atString isEqualToString:@""])
                {
                    NSRange atRange = NSMakeRange(resultStr.length, atString.length);
                    rangeDic[atString] = [NSValue valueWithRange:atRange];
                }
                [resultStr appendString:atString];
                [resultStr appendString:[tmp substringFromIndex:atString.length + 2]];
            }
            else
            {
                //没有正确结尾 补上被删掉的<$
                [resultStr appendString:kLeftAt];
                [resultStr appendString:tmp];
            }
        }
    }
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:resultStr];
    for (NSString *key in rangeDic.allKeys)
    {
        [attrStr addAttribute:NSLinkAttributeName
                        value:key
                        range:[rangeDic[key] rangeValue]];
        [attrStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:[rangeDic[key] rangeValue]];
        [attrStr addAttribute:NSUnderlineColorAttributeName value:[UIColor redColor] range:[rangeDic[key] rangeValue]];
    }
    
    [super setText:text];
    [super setAttributedText:attrStr];
}


- (BOOL)textView:(SNTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    __block BOOL autoDelete = NO;
    if (textView.attributedText)
    {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
        [attrStr enumerateAttribute:NSLinkAttributeName inRange:NSMakeRange(0, attrStr.string.length) options:NSAttributedStringEnumerationReverse usingBlock:^(id _Nullable value, NSRange attrRange, BOOL * _Nonnull stop) {
            if (value && NSLocationInRange(range.location,attrRange))
            {
                *stop = YES;
                autoDelete = YES;
                //auto delete
                [attrStr replaceCharactersInRange:attrRange withString:@""];
                textView.attributedText = attrStr;
                textView.selectedRange = NSMakeRange(attrRange.location,0);
            }
        }];
    }
    return !autoDelete;
}

@end
