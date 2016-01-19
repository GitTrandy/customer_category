//
//  StarView.h
//  circle_iphone
//
//  Created by sujie on 15/3/16.
//  Copyright (c) 2015年 ctquan. All rights reserved.
//

/*
 星级
 */

#import <UIKit/UIKit.h>

@protocol starDelegate <NSObject>

- (void)starChange:(float)rating tag:(NSInteger)t;

@end

@interface StarView : UIView
@property (nonatomic, weak) id<starDelegate> delegate;
@property (nonatomic, assign) float width;      //星星的宽
@property (nonatomic, assign) float height;     //星星的高
@property (nonatomic, assign) NSInteger type;    //标识  1 专业程度  2 实际帮助  3 约谈程度

@property (nonatomic, assign) NSInteger defaultNum; //默认星级
- (void)loadMainView;
- (void)displayRating:(float)rating;
@end
