//
//  CTAlertView.m
//  circle_iphone
//
//  Created by trandy on 15/8/17.
//  Copyright (c) 2015年 ctquan. All rights reserved.
//

#import "CTAlertView.h"
#import "CTSubject.h"

@interface CTAlertView()

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIView *contentView;

@end

@implementation CTAlertView

- (instancetype)initWithDeletage:(id<CTAlertViewDelegate>) target
                           title:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION;
{
    self = [super initWithFrame:DEVICE_RECT];
    if (self) {
        self.delegate = target;
        self.bgView = [[UIView alloc] initWithFrame:DEVICE_RECT];
        self.bgView.backgroundColor = CTColorMake(0, 0, 0, 0.6);
        [self addSubview:self.bgView];
        
        self.contentView = [[UIView alloc] init];
        NSInteger count = 0;
        NSInteger offset = 0;
        
        va_list args;
        va_start(args, firstObj);
        for(NSString *title = firstObj; title != nil; title = va_arg(args, NSString *))
        {
            UIButton *button = [[UIButton alloc] initWithFrame:CTRect(0, 0+offset+51*count, DEVICE_WIDTH, 51)];
            button.backgroundColor = CTColorMake(255, 255, 255, 1);
            if(![title isEqualToString:@"删除"])
            {
                if(count == 0)
                {
                    [button setTitleColor:CTColorMake(149, 149, 149, 1) forState:UIControlStateNormal];
                }else
                {
                    [button setTitleColor:CTColorMake(49, 49, 49, 1) forState:UIControlStateNormal];
                }

            }else
            {
                [button setTitleColor:CTRedColor forState:UIControlStateNormal];
            }
            [button setTitle:title forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
            button.tag = count;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            
            UIView *downLine = [CTSubject createHLine:226 g:226 b:226 a:1 size:CGSizeMake(DEVICE_WIDTH, 0.5)];
            downLine.frame = CTRect(0,button.frame.origin.y+button.frame.size.height-downLine.frame.size.height, downLine.frame.size.width, downLine.frame.size.height);
            [self.contentView addSubview:downLine];
            
            count++;
            offset = 5;
        }
        
        self.contentView.frame = CTRect(0, DEVICE_HEIGHT - 51*count - 5, DEVICE_WIDTH, 51*count + 5);
        self.contentView.backgroundColor = CTColorMake(226, 226, 226, 1);
        [self addSubview:self.contentView];
        
        va_end(args);
        
    }
    return self;
}

- (void)setColor:(UIColor *)color atIndex:(NSInteger)index
{
    UIButton* button = (UIButton *)[self.contentView viewWithTag:index];
    [button setTitleColor:color forState:UIControlStateNormal];
}

- (void)buttonClick:(UIButton *)btn
{
    [self.delegate ctAlertView:self didSelectAtIndex:btn.tag];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.bgView) {
        [self dismiss];
    }
}

- (void)show
{
    self.contentView.frame = CTRect(0, DEVICE_HEIGHT, self.contentView.frame.size.width, self.contentView.frame.size.height);
    [UIView animateWithDuration:0.25f animations:^{
        self.contentView.frame = CTRect(0, DEVICE_HEIGHT - self.contentView.frame.size.height,self.contentView.frame.size.width, self.contentView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25f animations:^{
        self.contentView.frame = CTRect(0, DEVICE_HEIGHT,self.contentView.frame.size.width, self.contentView.frame.size.height);
    } completion:^(BOOL finished) {
        self.delegate  = nil;
        [self removeFromSuperview];
    }];
}

- (void)remove
{
    self.delegate  = nil;
    [self removeFromSuperview];
}

@end
