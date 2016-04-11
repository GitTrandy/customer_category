//
//  ChatPhotoBrowse.m
//  circle_iphone
//
//  Created by trandy on 15/11/12.
//  Copyright © 2015年 ctquan. All rights reserved.
//

#import "ChatPhotoBrowse.h"
#import "ChatImgView.h"

@interface ChatPhotoBrowse()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong)        UIScrollView*                       scrollView;
@property (nonatomic,strong)        NSMutableArray<ChatImgView *>*      imgArray;
@property (nonatomic,copy)          NSArray<NSString *>*                msgIDArray;
@property (nonatomic,strong)        EMConversation*                     conversation;
@property (nonatomic,assign,setter=setIndex:)        NSInteger                           index;

@end

@implementation ChatPhotoBrowse

- (instancetype)initWithEID:(NSString *)eID
{
    self = [super initWithFrame:DEVICE_RECT];
    if (self) {
        self.conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:eID isGroup:NO];
        self.backgroundColor = [UIColor blackColor];
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        [self addSubview:self.scrollView];
        
        self.imgArray = [@[] mutableCopy];
        
        //添加单击手势
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(receiveGesture:)];
        tapGesture.delegate = self;
        tapGesture.numberOfTouchesRequired = 1;
        tapGesture.numberOfTapsRequired = 1;
        
        [self.scrollView addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)setMsgIDArray:(NSArray<NSString *> *)msgIDArray withCurrentMsgID:(NSString *)currentID
{
    _msgIDArray = msgIDArray;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*[_msgIDArray count], self.scrollView.frame.size.height);
    
    NSArray* msgArray = [self.conversation loadMessagesWithIds:msgIDArray];
    NSInteger tempIndex = 0;
    for (NSInteger i = 0; i < [msgArray count]; i++) {
        EMMessage* msgObject = msgArray[i];
        
        ChatImgView* img = [[ChatImgView alloc] initWithMessage:msgObject];
        img.frame = CGRectMake(self.scrollView.frame.size.width*i, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        [self.scrollView addSubview:img];
        [self.imgArray addObject:img];
        if ([msgObject.messageId isEqualToString:currentID]) {
            tempIndex = i;
        }
    }
    self.index = tempIndex;
}

- (void)startAnimation
{
    if (self.index < [self.imgArray count] && self.index >=0) {
        ChatImgView* img = self.imgArray[self.index];
        [self.scrollView scrollRectToVisible:CTRect(self.scrollView.frame.size.width*self.index, 0, self.frame.size.width, self.frame.size.height) animated:NO];
        if (img) {
            [img startAnimation];
        }
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/self.scrollView.frame.size.width;
    if (index == self.index) {
        return;
    }
    self.index = index;
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
    [self preLoadImgWithIndex:_index];
}

//预加载
- (void)preLoadImgWithIndex:(NSInteger)index
{
    //加载当前图片
    [self loadImgWithIndex:index];
    //加载前一张
    [self loadImgWithIndex:index - 1];
    //加载后一张
    [self loadImgWithIndex:index + 1];
}


//加载单个图片
- (void)loadImgWithIndex:(NSInteger)index
{
    if (index < [self.imgArray count] && index >=0) {
        //加载当前图片
        ChatImgView* img = self.imgArray[index];
        [img loadImgView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollView.contentOffset.x = %f",scrollView.contentOffset.x);
}


-(void)receiveGesture:(UISwipeGestureRecognizer* ) gestureRecognizer
{
    [self removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
        return YES;
    }
    return NO;
}

@end
