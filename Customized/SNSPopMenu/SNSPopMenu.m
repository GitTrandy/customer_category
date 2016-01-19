//
//  SNSPopMenu.m
//  beatmasterSNS
//
//  Created by Sunny on 13-12-26.
//
//

#import "SNSPopMenu.h"
#import <QuartzCore/QuartzCore.h>

const NSTimeInterval SNSPopMenuFadeAnimationDuration = 0.4; // 渐隐动画
const NSTimeInterval SNSPopMenuInertiaAnimationDuration = 0.15; // 惯性动画
const NSTimeInterval SNSPopMenuRotateAnimationDuration = 0.3; // 旋转动画

const CGFloat SNSPopMenuInertiaAngle = M_PI / 20;
const CGFloat SNSPopMenuRotateAngle = M_PI_2;

typedef NS_ENUM(NSInteger, SNSPopMenuPopStatus)
{
    SNSPopMenuStatusClosed,
    SNSPopMenuStatusAnimating,
    SNSPopMenuStatusPoped,
};

@interface SNSPopMenu ()

@property (nonatomic) SNSPopMenuPopStatus popStatus;
@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) UIButton *rootButton;
@property (nonatomic, strong) UIImageView *popBackgroundImageView;
@property (nonatomic, strong) UIView *menuContentView; // 放items

@end

@implementation SNSPopMenu

- (void)addItem:(SNSPopMenuItem *)item
{
    [self.items addObject:item];
    [self.menuContentView addSubview:item];
    [self setNeedsLayout];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // data
        self.popStatus = SNSPopMenuStatusClosed;
        self.items = [NSMutableArray array];
        
        // 弹出的环状背景图
        self.popBackgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SNSPopMenuBg"]];
        self.popBackgroundImageView.frame = CGRectMake(0, 0, 122.0f * SNS_SCALE, 122.0f * SNS_SCALE);
        self.popBackgroundImageView.alpha = 0;
        [self addSubview:self.popBackgroundImageView];
        
        // 为了旋转动画将item添加上的view, 为了旋转，设置左下角为锚点
        self.menuContentView = [UIView new];
        self.menuContentView.layer.anchorPoint = CGPointMake(0, 1);
        self.menuContentView.frame = (CGRect){.size = self.popBackgroundImageView.bounds.size};
        self.menuContentView.transform = CGAffineTransformMakeRotation(-SNSPopMenuRotateAngle); // 默认-90度旋转到屏幕外
        self.menuContentView.alpha = 0;
        [self addSubview:self.menuContentView];
              
        // 左下角root button
        CGRect buttonFrame = CGRectMake(0, CGRectGetHeight(self.frame) - 43 * SNS_SCALE, 43 * SNS_SCALE, 43 * SNS_SCALE);
        self.rootButton = [UIButton buttonCustomWithFrame:buttonFrame normalImage:[UIImage imageNamed:@"SNSPopMenuButtonRoot"] highlightedImage:nil];
        [self.rootButton addTarget:self action:@selector(rootButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.rootButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.popStatus == SNSPopMenuStatusAnimating)
    {
        return;
    }
    
    // 根据item个数布局item摆放位置
    CGFloat radius = CGRectGetWidth(self.menuContentView.frame);
    radius -= 28.0f * SNS_SCALE; // offset
    
    NSUInteger count = [self.items count];
    if (count == 0)
    {
        return;
    }
    
    // 头尾预留的角度
    CGFloat degreeReserved = M_PI / 12;
    CGFloat degreeReservedTotal = degreeReserved * 2;
    
    // 除去头尾预留的两个角度，剩下的角度按item个数平分
    CGFloat degreeEach = (M_PI_2 - degreeReservedTotal) / (count - 1);
    for (int index = 0; index < count; index++)
    {
        SNSPopMenuItem *item = self.items[index];
        CGPoint center = CGPointZero;
        center.x = radius * sinf(degreeReserved + index * degreeEach);
        center.y = CGRectGetHeight(item.superview.frame) - radius * cosf(degreeReserved + index * degreeEach);
        item.center = center;
    }
}


- (void)rootButtonTouched:(UIButton *)button
{
    PlayEffect(SFX_BUTTON);
    
    switch (self.popStatus)
    {
        case SNSPopMenuStatusClosed:
        {
            // 更新pop状态
            self.popStatus = SNSPopMenuStatusAnimating;
            
            // 开始隐现环状背景动画
            self.popBackgroundImageView.alpha = 0;
            [UIView animateWithDuration:SNSPopMenuFadeAnimationDuration animations:^{
                self.popBackgroundImageView.alpha = 1;
            } completion:^(BOOL finished) {
                self.popStatus = SNSPopMenuStatusPoped;
            }];
            
            // menu旋转进屏幕
            [UIView animateWithDuration:SNSPopMenuRotateAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.menuContentView.transform = CGAffineTransformMakeRotation(SNSPopMenuInertiaAngle);
                self.menuContentView.alpha = 1;
            } completion:^(BOOL finished) {
                // 惯性动画
                [UIView animateWithDuration:SNSPopMenuInertiaAnimationDuration animations:^{
                    self.menuContentView.transform = CGAffineTransformMakeRotation(0);
                }];
            }];

        } break;
            
        case SNSPopMenuStatusPoped:
        {
            // 更新pop状态
            self.popStatus = SNSPopMenuStatusAnimating;
            
            // 开始渐隐环状背景动画
            [UIView animateWithDuration:SNSPopMenuFadeAnimationDuration delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.popBackgroundImageView.alpha = 0;
            } completion:^(BOOL finished) {
                self.popStatus = SNSPopMenuStatusClosed;
            }];
            
            // 惯性动画
            [UIView animateWithDuration:SNSPopMenuInertiaAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.menuContentView.transform = CGAffineTransformMakeRotation(SNSPopMenuInertiaAngle);
            } completion:^(BOOL finished) {
                // 旋转渐隐menu层
                [UIView animateWithDuration:SNSPopMenuRotateAnimationDuration animations:^{
                    self.menuContentView.transform = CGAffineTransformMakeRotation(-SNSPopMenuRotateAngle);
                    self.menuContentView.alpha = 0;
                }];
            }];

            
        } break;
            
        default:
            break;
    }

}

@end
