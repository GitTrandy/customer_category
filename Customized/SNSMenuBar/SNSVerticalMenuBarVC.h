//
//  SNSMenuBarItem.h
//  TestSNSMenuBar
//
//  Created by Sunny on 13-9-18.
//  Copyright (c) 2013年 RedAtoms Inc. All rights reserved.
//

#import "SNSVerticalMenuBar.h"

@interface SNSVerticalMenuBarVC : UIViewController <SNSVeriticalMenuBarDelegate>

@property (nonatomic, weak) UIViewController* selectedChildViewController;

/* subviews(从底至上)
 + view
    - backgroundImageView (背景图)
    - backgroundCoverView (半透明黑色底)
    - contentView (外部subview加在这层)
    - menuBar (自动生成)
 */
@property (nonatomic, strong) UIImageView* backgroundImageView;
@property (nonatomic, strong) UIView* backgroundCoverView;
@property (nonatomic, strong) UIView* contentView; // 要使用[self.contentView addSubview:....]，保证menuBar在最上层;
@property (nonatomic, strong) SNSVerticalMenuBar* menuBar;

@end
