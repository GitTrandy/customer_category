//
//  UITextView+Extension.h
//  beatmasterSNS
//
//  Created by 刘旺 on 13-4-27.
//
//

#import <UIKit/UIKit.h>

@interface UITextView (Extension)

/*
 限制textField中输入字符的个数最大为maxCount，返回还剩余的字符个数
 */
-(int)limitTextByMaxCharacterCount:(int)maxCount;

/*
 判断textField中输入的字符是否超出最大输入范围
 返回值：YES：超出可输入的最大值 NO：未超出范围
 */
-(BOOL)isTextOverMaxCharacterCount:(int)maxCount;


/*
 返回还剩余的字符个数
 */
-(int)countTextByMaxCharacterCount:(int)maxCount;


@end
