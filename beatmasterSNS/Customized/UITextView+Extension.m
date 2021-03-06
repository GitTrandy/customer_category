//
//  UITextView+Extension.m
//  beatmasterSNS
//
//  Created by 刘旺 on 13-4-27.
//
//

#import "UITextView+Extension.h"

@implementation UITextView (Extension)

//按需求截取字符串同时返回剩余字符串长度
-(int)limitTextByMaxCharacterCount:(int)maxCount
{
    NSString* inputString = [self.text copy];
    
    __block int count = 0;
    __block int allLength = 0;
    [inputString enumerateSubstringsInRange:NSMakeRange(0, inputString.length)
                                    options:NSStringEnumerationByComposedCharacterSequences
                                 usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
                                     count += (1 == substring.length && isascii([substring characterAtIndex:0]) ? 1 : 2);
                                     if (count <= maxCount)
                                     {
                                         allLength += substring.length;
                                     }
                                 }];
    if (allLength < inputString.length)
    {
        self.text = [inputString substringToIndex:allLength];
    }
    [inputString release];
    
    int remainCount = maxCount - count;
    return (remainCount > 0 ? remainCount : 0);
}

-(BOOL)isTextOverMaxCharacterCount:(int)maxCount
{
    NSString* inputString = [self.text copy];
    
    __block int count = 0;
    [inputString enumerateSubstringsInRange:NSMakeRange(0, inputString.length)
                                    options:NSStringEnumerationByComposedCharacterSequences
                                 usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
                                     count += (1 == substring.length && isascii([substring characterAtIndex:0]) ? 1 : 2);
                                 }];
    
    [inputString release];
    
    return (count > maxCount);
}

//同时返回剩余字符串长度
-(int)countTextByMaxCharacterCount:(int)maxCount
{
    NSString* inputString = [self.text copy];
    
    __block int count = 0;
    __block int allLength = 0;
    [inputString enumerateSubstringsInRange:NSMakeRange(0, inputString.length)
                                    options:NSStringEnumerationByComposedCharacterSequences
                                 usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
                                     count += (1 == substring.length && isascii([substring characterAtIndex:0]) ? 1 : 2);
                                     if (count <= maxCount)
                                     {
                                         allLength += substring.length;
                                     }
                                 }];
    [inputString release];
    
    int remainCount = maxCount - count;
    return (remainCount > 0 ? remainCount : 0);
}

@end
