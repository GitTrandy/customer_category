//
//  CTSegScrollView.m
//  CTSegScrollView
//
//  Created by trandy on 15/10/22.
//  Copyright © 2015年 ctquan. All rights reserved.
//

#import "CTSegScrollView.h"

@interface CTSegScrollView()<UIScrollViewDelegate>

@property (nonatomic,copy)      NSArray*    titleArray;
@property (nonatomic,strong)    UIView*     selectView;
@property (nonatomic,assign)    NSInteger   selectIndex;
@property (nonatomic,assign)    CGFloat     itemWidth;
@property (nonatomic,strong)    UIScrollView* scrollView;

@end

@implementation CTSegScrollView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray*)titleArray delegate:(id <CTSegScrollViewDelegate>) delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleArray = [titleArray copy];
        self.selectIndex = 0;
        self.textFont = [UIFont systemFontOfSize:14];
        self.delegate = delegate;
        [self createView];
    }
    return self;
}

- (void)createView
{
    UIView* topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
    topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topView];
    
    UIView* spLine = [[UIView alloc] initWithFrame:CGRectMake(0, 30-0.5, DEVICE_WIDTH, 0.5)];
    spLine.backgroundColor = [UIColor grayColor];
    [self addSubview:spLine];
    
    self.itemWidth = (self.frame.size.width - 40)/[self.titleArray count];
    
    for (NSInteger i = 0; i < [self.titleArray count]; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20 + self.itemWidth*i, 0, self.itemWidth,30);
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:button];
    }
    
    self.selectView = [[UIView alloc] init];
    self.selectView.backgroundColor = [UIColor colorWithRed:3.0f/255.0f green:138.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    self.selectView.frame = [self frameForSelectView];
    [topView addSubview:self.selectView];
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, self.frame.size.width, self.frame.size.height - 30)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*[self.titleArray count], scrollView.frame.size.height);
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    NSMutableArray* viewArray = [@[] mutableCopy];
    for (NSInteger i = 0 ; i < [self.titleArray count]; i++) {
        UIView* view;
        if (self.delegate) {
            view = [self.delegate segScrollViewWithIndex:i];
            view.frame = CGRectMake(scrollView.frame.size.width * i, 0, scrollView.frame.size.width,scrollView.frame.size.height);
        }else
        {
            view = [[UIView alloc] initWithFrame:CGRectMake(scrollView.frame.size.width*i, 0, scrollView.frame.size.width, scrollView.frame.size.height - 30)];
        }
        [scrollView addSubview:view];
        [viewArray addObject:view];
    }
    self.viewArray = [viewArray copy];
}

- (CGRect)frameForSelectView
{
    NSString* title = self.titleArray[self.selectIndex];
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:self.textFont}];
    
    CGRect rect = CGRectMake(20 + self.itemWidth * self.selectIndex + self.itemWidth/2 - titleSize.width/2, 30 - 4,titleSize.width, 4);
    
    return rect;
}

- (CGRect)frameForSelectViewByOffset:(CGFloat)offset
{
    NSInteger leftIndex = offset/self.frame.size.width;
    NSString* leftTitle = self.titleArray[leftIndex];
    CGSize leftTitleSize = [leftTitle sizeWithAttributes:@{NSFontAttributeName:self.textFont}];
    
    NSInteger rightIndex;
    CGSize rightTitleSize;
    if ((leftIndex + 1) >= [self.titleArray count]) {
        rightTitleSize = CGSizeMake(0, 0);
    }else
    {
        rightIndex = leftIndex + 1;
        NSString* rightTitle = self.titleArray[rightIndex];
        rightTitleSize = [rightTitle sizeWithAttributes:@{NSFontAttributeName:self.textFont}];
    }
    
    CGFloat currentWidth = (rightTitleSize.width - leftTitleSize.width)/self.frame.size.width*(offset - self.frame.size.width*leftIndex) + leftTitleSize.width;
    
    CGFloat currentCenterX = self.itemWidth/2+self.itemWidth/self.frame.size.width*offset;
    
    CGRect rect = {currentCenterX - 0.5*currentWidth + 20,30 - 4,currentWidth,4};
    
    return rect;
}

- (void)titleBtnClick:(UIButton *)btn
{
    [self selectAtIndex:btn.tag];
}

- (void)selectAtIndex:(NSInteger)index
{
    self.selectIndex = index;
    
    [UIView animateWithDuration:0.30 animations:^{
        self.selectView.frame = [self frameForSelectView];
        [self.scrollView setContentOffset:CGPointMake(self.frame.size.width*index, 0)];
    }];
    
    if (self.delegate) {
        [self.delegate segScrollViewAppearWithIndex:index];
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    self.selectView.frame = [self frameForSelectViewByOffset:offset.x];
}

@end
