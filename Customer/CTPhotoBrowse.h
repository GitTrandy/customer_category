//
//  CTPhotoBrowse.h
//  circle_iphone
//
//  Created by sujie on 15/4/20.
//  Copyright (c) 2015年 ctquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CTPhotoBrowseDelegate <NSObject>

- (void)dismissCTPhotoClick:(NSInteger)visitPage;

@end

@interface CTPhotoBrowse : UIView<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *imgData;     //图片源
@property (nonatomic, assign) NSInteger page;       //点击哪张图片
@property (nonatomic, weak) id<CTPhotoBrowseDelegate> deleagte;

+ (CTPhotoBrowse *)sharedCTPhotoBrowse;
- (void)createPhotoBrowseView;

@end
