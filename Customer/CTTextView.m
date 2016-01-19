//
//  CTTextView.m
//  circle_iphone
//
//  Created by trandy on 15/8/20.
//  Copyright (c) 2015年 ctquan. All rights reserved.
//

#import "CTTextView.h"

@interface CTTextView()<UIScrollViewDelegate>

@property (nonatomic,strong) UILabel            *countLabel;
@property (nonatomic,assign) NSInteger          count;
@end

@implementation CTTextView

- (void)showCountLabel:(NSInteger)count
{
    self.count = count;
    self.countLabel = [[UILabel alloc] initWithFrame:CTRect(self.frame.size.width - 45, self.frame.size.height - 25, 40, 20)];
    self.countLabel.font = self.font;
    self.countLabel.textAlignment = NSTextAlignmentRight;
    self.countLabel.textColor = CTColorMake(170, 170, 170, 1);
//    self.countLabel.backgroundColor = [UIColor yellowColor];
    if (self.text.length > self.count) {
        self.text = [self.text substringToIndex:self.count];
    }
    NSInteger leftCount = count - self.text.length;
    self.countLabel.text = [NSString stringWithFormat:@"%ld",leftCount];
    [self.countLabel setUserInteractionEnabled:NO];
    [self addSubview:self.countLabel];
}

- (void)update
{
    if (self.countLabel) {
        if (self.text.length > self.count) {
            self.text = [self.text substringToIndex:self.count];
        }
        NSInteger leftCount = self.count - self.text.length;
        self.countLabel.text = [NSString stringWithFormat:@"%ld",leftCount];
    }
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
    if (self.countLabel) {
        self.countLabel.frame = CTRect(self.frame.size.width - 45,contentOffset.y + self.frame.size.height - 25, 40, 20);
    }
}

@end
