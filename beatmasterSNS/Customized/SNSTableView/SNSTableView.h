//
//  SNSTableView.h
//  BaseTableView
//
//  Created by 彭慧明 on 13-10-15.
//  Copyright (c) 2013年 彭慧明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComTableView.h"
#import "TableViewScrollLineView.h"

//typedef enum
//{
//    ScrollLineStyleBLue  = 0,  // 俱乐部大厅
//    ScrollLineStylePurple,     // 战报
//    ScrollLineStyleYellow,     // 档案
//    ScrollLineStyleRed,        // 商城
//    ScrollLineStyleGreen,      // 练习
//    ScrollLineStyleGray        // 消息
//    
//}ScrollLineStyle;

@interface SNSTableView : ComTableView

-(id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style andFreshStyle:(RefreshStyle)freshStyle andScrollStyle:(ScrollLineStyle) scrollStyle;

@end
