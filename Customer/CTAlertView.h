//
//  CTAlertView.h
//  circle_iphone
//
//  Created by trandy on 15/8/17.
//  Copyright (c) 2015年 ctquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CTAlertView;

//typedef NS_ENUM(NSInteger, CTAlertType)
//{
//    CTAlertType_Select = 0,
//    CTAlertType_Delete = 1
//};

@protocol CTAlertViewDelegate <NSObject>

@required

-(void)ctAlertView:(CTAlertView *)view didSelectAtIndex:(NSInteger)index;

@end

@interface CTAlertView : UIView

//@property (nonatomic,assign) CTAlertType type;
@property (nonatomic,weak) id<CTAlertViewDelegate> delegate;

- (instancetype)initWithDeletage:(id<CTAlertViewDelegate>) target
                           title:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION;

- (void)show;
- (void)dismiss;
- (void)remove;

- (void)setColor:(UIColor *)color atIndex:(NSInteger)index;

@end
