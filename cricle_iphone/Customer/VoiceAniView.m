//
//  VoiceAniView.m
//  circle_iphone
//
//  Created by trandy on 15/5/25.
//  Copyright (c) 2015年 ctquan. All rights reserved.
//

#import "VoiceAniView.h"

@interface VoiceAniView ()

@property (nonatomic,assign) NSInteger      count;
@property (nonatomic,assign) NSString       *name;

@end

@implementation VoiceAniView

- (instancetype)initWithFileName:(NSString *)name count:(int)count
{
    NSMutableArray* imgArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < count ; i++ )
    {
        UIImage* img = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%d.png",name,i]];
        [imgArray addObject:img];
    }
    
    self = [super init];
    if (self) {
        self.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%d.png",name,count-1]];
        self.animationImages = imgArray;
        self.animationRepeatCount = 0;
        self.animationDuration = 1;
    }
    return self;
}

@end
