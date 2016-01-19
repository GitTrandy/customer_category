//
//  UILabel+Extension.m
//  circle_iphone
//
//  Created by sujie on 15/4/14.
//  Copyright (c) 2015年 ctquan. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

- (void)setLineSpace:(float)lineSpace text:(NSString *)str
{
    if (str == nil) {
        str = @"";
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, [str length])];
    
    
    self.attributedText = attributedString;
}

#pragma mark - 计算动态lable size
+ (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize lineSpace:(float)lineSpace
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineSpacing = lineSpace;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
                                 NSParagraphStyleAttributeName:paragraphStyle.copy
                                 };
    
    CGSize labelSize = [text boundingRectWithSize:maxSize
                                          options:
                        NSStringDrawingUsesLineFragmentOrigin|
                        NSStringDrawingUsesFontLeading|
                        NSStringDrawingTruncatesLastVisibleLine
                                       attributes:attributes
                                          context:nil].size;
    labelSize.height = ceil(labelSize.height);
    labelSize.width = ceil(labelSize.width);
    
    return labelSize;
    
}

@end
