//
//  SNSHorizonMenuBar.h
//  SNSMenuBarDemo
//
//  Created by Sunny on 13-10-12.
//  Copyright (c) 2013年 sunny. All rights reserved.
//

#import "SNSMenuBar.h"

/* subviews
    + view
    - leftIndicatorImageView
    - SNSMenuBar(super)
    - rightIndicatorImageView
 */

typedef NS_ENUM(NSInteger, SNSHorizonMenuBarType)
{
    SNSHorizonMenuBarTypeProfile,
    SNSHorizonMenuBarTypeShoppingMall
};

@interface SNSHorizonMenuBar : SNSMenuBar
@property (nonatomic) SNSHorizonMenuBarType horizonMenuBarType;

@end

