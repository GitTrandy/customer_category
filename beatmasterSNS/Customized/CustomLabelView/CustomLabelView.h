//
//  CustomLabelView.h
//  beatmasterSNS
//
//  Created by chengsong on 12-11-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum 
{
    CustomLabelViewStyleNoWords = 0,
    CustomLabelViewStyleNotMoreThan4,      // // 不大于4个字
    CustomLabelViewStyleEqual5,                // // 等于5个字
    CustomLabelViewStyle6plus_Line1_4,         // // 大于等于6个字，第一行4个字
    CustomLabelViewStyle6plus_Line1_5plus      // // 大于等于6个字，第一行5或者6个字
}CustomLabelViewStyle;
@interface CustomLabelView : UIView
{
    UIImageView *_bgView;
    UILabel     *_firstWordLabel;
    UILabel     *_secondWordLabel;
    UILabel     *_thirdWordLabel;
    NSString    *_showWords;
    CustomLabelViewStyle _style;
    int         _firstBlankIndex;
    int         _userInfoStyle;
}

- (id)initWithFrame:(CGRect)frame words:(NSString *)words userInfoStyle:(int)userInfoStyle;

@end
