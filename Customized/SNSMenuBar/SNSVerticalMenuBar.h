//
//  SNSVeriticalMenuBar.h
//  SNSMenuBarDemo
//
//  Created by Sunny on 13-10-11.
//  Copyright (c) 2013年 sunny. All rights reserved.
//

#import "SNSMenuBar.h"

@protocol SNSVeriticalMenuBarDelegate <SNSMenuBarDelegate>
@optional
- (SNSMenuBarItem *)menuBarReturnItem:(SNSMenuBar *)menuBar;
- (void)menuBar:(SNSMenuBar *)menuBar didSelectReturnItem:(SNSMenuBarItem *)item;
- (BOOL)menuBar:(SNSMenuBar *)menuBar shouldSelectReturnItem:(SNSMenuBarItem *)item;
@end

/* subviews
 + view
    - returnItem
    - SNSMenuBar(super)
 */


@interface SNSVerticalMenuBar : SNSMenuBar

@property (nonatomic, weak) id<SNSVeriticalMenuBarDelegate> delegate;
- (void)selectReturnItem;

@end
