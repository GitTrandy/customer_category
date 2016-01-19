//
//  CTSegmentedControl.m
//  circle_iphone
//
//  Created by sujie on 15/6/17.
//  Copyright (c) 2015年 ctquan. All rights reserved.
//

#import "CTSegmentedControl.h"

@interface CTSegmentedControl ()
{
    NSInteger lastClickTag;
}
@end

@implementation CTSegmentedControl

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)loadMainView
{
    for (int i = 0; i < _segButtonCount; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * _segButtonWidth,
                                  0,
                                  _segButtonWidth,
                                  self.frame.size.height);
        button.tag = i + 20000;
        if (i == _defaultSelectedIndex) {
            if (_segButtonSelectedBackgroundImageArray.count >= i + 1) {
                [button setBackgroundImage:_segButtonSelectedBackgroundImageArray[i]
                                  forState:UIControlStateNormal];
            }
            button.selected = YES;
            lastClickTag = i + 20000;
        }else
        {
            if (_segButtonNormalBackgroundImageArray.count >= i + 1) {
                [button setBackgroundImage:_segButtonNormalBackgroundImageArray[i]
                                  forState:UIControlStateNormal];
            }
            button.selected = NO;
        }
        
        if (_segButtonTitleArray.count >= i + 1) {
            [button setTitle:_segButtonTitleArray[i]
                    forState:UIControlStateNormal];
        }
        [button addTarget:self
                   action:@selector(segmentedClick:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
    }
    
}

- (void)segmentedClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (!button.selected) {
        UIButton *lastClickButton = (UIButton *)[self viewWithTag:lastClickTag];
        if (_segButtonNormalBackgroundImageArray.count >= lastClickButton.tag - 20000 + 1) {
            [lastClickButton setBackgroundImage:_segButtonNormalBackgroundImageArray[lastClickButton.tag - 20000]
                                       forState:UIControlStateNormal];
        }
        lastClickButton.selected = NO;
        
        
        if (_segButtonSelectedBackgroundImageArray.count >= button.tag - 20000 + 1) {
            [button setBackgroundImage:_segButtonSelectedBackgroundImageArray[button.tag - 20000]
                              forState:UIControlStateNormal];
        }
        button.selected = YES;
        lastClickTag = button.tag;
        [_delegate segmentedClickForIndex:button.tag - 20000];
    }
}

- (void)restoreDefaultState
{
    UIButton *lastClickButton = (UIButton *)[self viewWithTag:lastClickTag];
    if (_segButtonNormalBackgroundImageArray.count >= lastClickButton.tag - 20000 + 1) {
        [lastClickButton setBackgroundImage:_segButtonNormalBackgroundImageArray[lastClickButton.tag - 20000]
                                   forState:UIControlStateNormal];
    }
    lastClickButton.selected = NO;
}


@end
