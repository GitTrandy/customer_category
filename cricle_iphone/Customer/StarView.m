//
//  StarView.m
//  circle_iphone
//
//  Created by sujie on 15/3/16.
//  Copyright (c) 2015年 ctquan. All rights reserved.
//

#import "StarView.h"

@interface StarView ()
{
    UIImageView *s1, *s2, *s3, *s4, *s5;
    float starRating, lastRating;
}
@end

@implementation StarView

- (void)loadMainView
{
    s1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    s2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.width, 0, self.width, self.height)];
    s3 = [[UIImageView alloc] initWithFrame:CGRectMake(self.width * 2, 0, self.width, self.height)];
    s4 = [[UIImageView alloc] initWithFrame:CGRectMake(self.width * 3, 0, self.width, self.height)];
    s5 = [[UIImageView alloc] initWithFrame:CGRectMake(self.width * 4, 0, self.width, self.height)];
    
    switch (self.defaultNum) {
        case 0:
        {
            s1.image = [UIImage imageNamed:@"ML_star_img_n.png"];
            s2.image = [UIImage imageNamed:@"ML_star_img_n.png"];
            s3.image = [UIImage imageNamed:@"ML_star_img_n.png"];
            s4.image = [UIImage imageNamed:@"ML_star_img_n.png"];
            s5.image = [UIImage imageNamed:@"ML_star_img_n.png"];
        }
            break;
        case 1:
        {
            s1.image = [UIImage imageNamed:@"ML_star_img_s.png"];
            s2.image = [UIImage imageNamed:@"ML_star_img_n.png"];
            s3.image = [UIImage imageNamed:@"ML_star_img_n.png"];
            s4.image = [UIImage imageNamed:@"ML_star_img_n.png"];
            s5.image = [UIImage imageNamed:@"ML_star_img_n.png"];
        }
            break;
        case 2:
        {
            s1.image = [UIImage imageNamed:@"ML_star_img_s.png"];
            s2.image = [UIImage imageNamed:@"ML_star_img_s.png"];
            s3.image = [UIImage imageNamed:@"ML_star_img_n.png"];
            s4.image = [UIImage imageNamed:@"ML_star_img_n.png"];
            s5.image = [UIImage imageNamed:@"ML_star_img_n.png"];
        }
            break;
        case 3:
        {
            s1.image = [UIImage imageNamed:@"ML_star_img_s.png"];
            s2.image = [UIImage imageNamed:@"ML_star_img_s.png"];
            s3.image = [UIImage imageNamed:@"ML_star_img_s.png"];
            s4.image = [UIImage imageNamed:@"ML_star_img_n.png"];
            s5.image = [UIImage imageNamed:@"ML_star_img_n.png"];
        }
            break;
        case 4:
        {
            s1.image = [UIImage imageNamed:@"ML_star_img_s.png"];
            s2.image = [UIImage imageNamed:@"ML_star_img_s.png"];
            s3.image = [UIImage imageNamed:@"ML_star_img_s.png"];
            s4.image = [UIImage imageNamed:@"ML_star_img_s.png"];
            s5.image = [UIImage imageNamed:@"ML_star_img_n.png"];
        }
            break;
        case 5:
        {
            s1.image = [UIImage imageNamed:@"ML_star_img_s.png"];
            s2.image = [UIImage imageNamed:@"ML_star_img_s.png"];
            s3.image = [UIImage imageNamed:@"ML_star_img_s.png"];
            s4.image = [UIImage imageNamed:@"ML_star_img_s.png"];
            s5.image = [UIImage imageNamed:@"ML_star_img_s.png"];
        }
            break;
        default:
        {
            s1.image = [UIImage imageNamed:@"ML_star_img_n.png"];
            s2.image = [UIImage imageNamed:@"ML_star_img_n.png"];
            s3.image = [UIImage imageNamed:@"ML_star_img_n.png"];
            s4.image = [UIImage imageNamed:@"ML_star_img_n.png"];
            s5.image = [UIImage imageNamed:@"ML_star_img_n.png"];
        }
            break;
    }
    
    starRating = 0;
    lastRating = 0;
    
    [self addSubview:s1];
    [self addSubview:s2];
    [self addSubview:s3];
    [self addSubview:s4];
    [self addSubview:s5];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pt = [[touches anyObject] locationInView:self];
    int newRating = (int)(pt.x / self.width) + 1;
    if (newRating < 1 || newRating > 5) {
        return;
    }
    
    if (newRating != lastRating) {
        [self displayRating:newRating];
    }
    
    [self.delegate starChange:newRating tag:self.type];
}

- (void)displayRating:(float)rating
{
    s1.image = [UIImage imageNamed:@"ML_star_img_n.png"];
    s2.image = [UIImage imageNamed:@"ML_star_img_n.png"];
    s3.image = [UIImage imageNamed:@"ML_star_img_n.png"];
    s4.image = [UIImage imageNamed:@"ML_star_img_n.png"];
    s5.image = [UIImage imageNamed:@"ML_star_img_n.png"];
    
    if (rating >= 1) {
        s1.image = [UIImage imageNamed:@"ML_star_img_s.png"];
    }
    
    if (rating >= 2) {
        s2.image = [UIImage imageNamed:@"ML_star_img_s.png"];
    }
    
    if (rating >= 3) {
        s3.image = [UIImage imageNamed:@"ML_star_img_s.png"];
    }
    
    if (rating >= 4) {
        s4.image = [UIImage imageNamed:@"ML_star_img_s.png"];
    }
    
    if (rating >= 5) {
        s5.image = [UIImage imageNamed:@"ML_star_img_s.png"];
    }
    
    starRating = rating;
    lastRating = rating;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
