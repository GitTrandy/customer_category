//
//  SNSMenuBarItem.h
//  TestSNSMenuBar
//
//  Created by Sunny on 13-9-18.
//  Copyright (c) 2013年 RedAtoms Inc. All rights reserved.
//

#import "SNSMenuBarItemAnimaton.h"

typedef NS_ENUM(NSUInteger, SNSMenuBarItemImageIndex)
{
    SNSMenuBarItemImageIndexNormal = 0,
    SNSMenuBarItemImageIndexHighlight,
    SNSMenuBarItemImageIndexSelected
};

/* subviews 从底至上
 + view
    - backgroundImageView (默认透明)
    + itemImageView (手势识别加到这层)
        - animationView (不接收触摸事件)
 */
@interface SNSMenuBarItem : UIView

// image不能为nil，highlight或select为nil则使用image
+ (instancetype)itemWithImage:(UIImage *)image
                   hightlight:(UIImage *)hightlightImage
                     selected:(UIImage *)selectedImage;


@property (nonatomic) SNSMenuBarItemImageIndex currentImageIndex; // Default Normal


@property (nonatomic, strong) UIImageView* backgroundImageView;
@property (nonatomic, strong) UIImageView* itemImageView;
@property (nonatomic, strong) UIView* animationView;

@property (nonatomic, strong) UILongPressGestureRecognizer* longPressRecognizer;

@property (nonatomic, strong) SNSMenuBarItemAnimation* animation;



// MenuBar主调，用于通知MenuBar触摸事件
- (void)setItemTouchEndHandler:(id)target selector:(SEL)sel;
// MenuBar主调，用于改变被选择的item的显示状态
@property (nonatomic, getter=isSelected) BOOL selected;


@end










