//
//  UISearchBar+SNSCustomized.m
//  beatmasterSNS
//
//  Created by Sunny on 13-12-2.
//
//

#import "UISearchBar+SNSCustomized.h"

@implementation UISearchBar (SNSCustomized)

- (void)setTextColor:(UIColor *)textColor
{
    NSArray *subviews = nil;
    if ([self respondsToSelector:@selector(barTintColor)])
    {
        subviews =  [self.subviews[0] subviews];
    }
    else
    {
        subviews = self.subviews;
    }
    for (UIView *subView in subviews)
    {
        if ([subView isKindOfClass:[UITextField class]])
        {
            UITextField *textField = (UITextField *)subView;
            textField.textColor = [UIColor whiteColor];
            textField.font = [UIFont systemFontOfSize:10.0f];
            break;
        }
    }
}

- (void)setFont:(UIFont *)font
{
    NSArray *subviews = nil;
    if ([self respondsToSelector:@selector(barTintColor)])
    {
        subviews =  [self.subviews[0] subviews];
    }
    else
    {
        subviews = self.subviews;
    }
    for (UIView *subView in subviews)
    {
        if ([subView isKindOfClass:[UITextField class]])
        {
            UITextField *textField = (UITextField *)subView;
            textField.font = font;
            break;
        }
    }
}

- (void)removeBackground
{
    NSArray *subviews = nil;
    if ([self respondsToSelector:@selector(barTintColor)])
    {
        subviews =  [self.subviews[0] subviews];
    }
    else
    {
        subviews = self.subviews;
    }
    
    for (UIView *subview in subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
            break;
        }
    }
}

- (void)removeDefaultSearchIcon
{
    NSArray *subviews = nil;
    if ([self respondsToSelector:@selector(barTintColor)])
    {
        subviews =  [self.subviews[0] subviews];
    }
    else
    {
        subviews = self.subviews;
    }
    
    for (UIView *subView in subviews)
    {
        if ([subView isKindOfClass:[UITextField class]])
        {
            UITextField *textField = (UITextField *)subView;
            UIView* view = [[UIImageView new] initWithFrame:self.bounds];
            view.backgroundColor = [UIColor clearColor];
            textField.leftView = view;
            break;
        }
    }
}

@end
