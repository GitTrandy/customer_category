//
//  SNSTableView.m
//  BaseTableView
//
//  Created by 彭慧明 on 13-10-15.
//  Copyright (c) 2013年 彭慧明. All rights reserved.
//

#import "SNSTableView.h"
#import "UIImage+Replace_imageNamed.h"

@implementation SNSTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style andFreshStyle:(RefreshStyle)freshStyle andScrollStyle:(ScrollLineStyle)scrollStyle
{
    if (self = [super initWithFrame:frame style:style andFreshStyle:freshStyle])
    {
        self.lineView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.indicatorStyle=UIScrollViewIndicatorStyleWhite;
        self.separatorStyle = NO;                   //去掉分割线
        switch (scrollStyle)
        {
            case ScrollLineStyleBLue:
            {
                self.lineView.image = [[UIImage imageNamed_New:@"ScrollLineStyle_00@2x.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6.0f, 0.0f, 6.0f, 0.0f)];
            }
                break;
            case ScrollLineStylePurple:
            {
                self.lineView.image = [[UIImage imageNamed_New:@"ScrollLineStyle_01@2x.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6.0f, 0.0f, 6.0f, 0.0f)];
            }
                break;
            case ScrollLineStyleYellow:
            {
                self.lineView.image = [[UIImage imageNamed_New:@"ScrollLineStyle_02@2x.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6.0f, 0.0f, 6.0f, 0.0f)];
            }
                break;
            case ScrollLineStyleRed:
            {
                self.lineView.image = [[UIImage imageNamed_New:@"ScrollLineStyle_03@2x.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6.0f, 0.0f, 6.0f, 0.0f)];
            }
                break;
            case ScrollLineStyleGreen:
            {
                self.lineView.image = [[UIImage imageNamed_New:@"ScrollLineStyle_04@2x.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6.0f, 0.0f, 6.0f, 0.0f)];
            }
                break;
            case ScrollLineStyleGray:
            {
                self.lineView.image = [[UIImage imageNamed_New:@"ScrollLineStyle_05@2x.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6.0f, 0.0f, 6.0f, 0.0f)];
            }
                break;
                
            default:
                break;
        }
    }
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

@end
