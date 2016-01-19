//
//  CSTextButton.h
//  CoreTextTest
//
//  Created by chengsong on 13-10-16.
//  Copyright (c) 2013年 chengsong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSTextButton : UIButton

// // 按钮的类别,用户可自行定义，应为最后是作为数据传给用户使用的
@property(nonatomic,strong)NSString *btnType;
// // 按钮上附带的信息，用户需要按钮传递的信息，比如网址链接、XXID等等
@property(nonatomic,strong)NSString *btnInfo;
@end
