//
//  SNSMenuBarItem.h
//  TestSNSMenuBar
//
//  Created by Sunny on 13-9-18.
//  Copyright (c) 2013年 RedAtoms Inc. All rights reserved.
//

#import "SNSMenuBarItem.h"

@interface SNSMenuBarItem ()

// 按ImageIndex顺序储存[image,highlightImage,selectedImage]
@property (nonatomic, strong) NSArray* images;

// 事件处理和通知给外部MenuBar
- (void)longPressGestureCallback:(UILongPressGestureRecognizer *)recognizer;
@property (nonatomic, weak) id target;
@property (nonatomic) SEL selector;

@property (nonatomic) CGSize itemImageSize; // 默认使用image.size

@end

@implementation SNSMenuBarItem

#pragma mark - 创建方法

+ (instancetype)itemWithImage:(UIImage *)image hightlight:(UIImage *)hightlightImage selected:(UIImage *)selectedImage
{
    SNSMenuBarItem* item = [SNSMenuBarItem new];
    
    // 设置图片，若highlight或select图片为空则使用image
    NSAssert(image, @"SNSMenuBarItem item image==nil");
    hightlightImage = hightlightImage ? hightlightImage : image;
    selectedImage = selectedImage ? selectedImage : hightlightImage;
    item.images = @[image, hightlightImage, selectedImage];
    
    // 设置默认值
    item.currentImageIndex = SNSMenuBarItemImageIndexNormal;
    item.itemImageSize = image.size;
    
    return item;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        // 初始化bgImageView
        self.backgroundImageView = [UIImageView new];
        [self addSubview:self.backgroundImageView];
        
        // 初始化itemImageView
        self.itemImageView = [UIImageView new];
        self.itemImageView.userInteractionEnabled = YES; // 设置接收事件
        [self addSubview:self.itemImageView];
        
        // 初始化animation view
        self.animationView = [UIView new];
        self.animationView.userInteractionEnabled = NO;
        [self.itemImageView addSubview:self.animationView];
        
        /*  使用LongPress手势，因为要接收touch began和touch end两个事件
         使用Tap手势只能接收touch end事件 */
        self.longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureCallback:)];
        self.longPressRecognizer.minimumPressDuration = 0.001f; // 设置最小触摸时间
        [self.itemImageView addGestureRecognizer:self.longPressRecognizer];
        
    }
    return self;
}

#pragma mark - 布局

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundImageView.frame = self.bounds;
    
    // 若图片真实size小于item的size按照图片size
    // 反之按照item的size
   
    CGFloat itemImageWidth = MIN(CGRectGetWidth(self.bounds), self.itemImageSize.width);
    CGFloat itemImageHeight = MIN(CGRectGetHeight(self.bounds), self.itemImageSize.height);
    
    // 图片宽高比例
    CGFloat ratio = self.itemImageSize.height/self.itemImageSize.width;

    if (itemImageWidth <= itemImageHeight)
    {
        itemImageHeight = itemImageWidth * ratio;
    }
    else
    {
        itemImageWidth = itemImageHeight / ratio;
    }
    self.itemImageView.frame = CGRectMake(0, 0, itemImageWidth*SNS_SCALE, itemImageHeight*SNS_SCALE);
    self.itemImageView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    // 动画
    self.animationView.frame = self.itemImageView.bounds;


}

#pragma mark - SNSMenuBar主调的方法

- (void)setItemTouchEndHandler:(id)target selector:(SEL)sel
{
    self.target = target;
    self.selector = sel;
}

- (void)setSelected:(BOOL)selected
{
    self->_selected = selected;
    self.currentImageIndex = selected ? SNSMenuBarItemImageIndexSelected : SNSMenuBarItemImageIndexNormal;
}

#pragma mark - 动画

- (void)setAnimation:(SNSMenuBarItemAnimation *)animation
{
    self->_animation = animation;
    if (animation)
    {
        [self.animationView addSubview:animation];
    }
}

#pragma mark - 私有

// 根据index改变itemImageView的image
- (void)setCurrentImageIndex:(SNSMenuBarItemImageIndex)currentImageIndex
{
    self->_currentImageIndex = currentImageIndex;
    self.itemImageView.image = self.images[currentImageIndex];
}

- (void)longPressGestureCallback:(UILongPressGestureRecognizer *)recognizer
{
    UIGestureRecognizerState state = recognizer.state;
    if (state == UIGestureRecognizerStateBegan)
    {
        // 将image变成highlight
        self.currentImageIndex = SNSMenuBarItemImageIndexHighlight;
    }
    else if (state == UIGestureRecognizerStateEnded)
    {
        // 选中了selected状态的item，默认将image变成normal
        if (self.isSelected)
        {
            [self setCurrentImageIndex:SNSMenuBarItemImageIndexSelected];
        }
        else
        {
            [self setCurrentImageIndex:SNSMenuBarItemImageIndexNormal];
        }
        
        //关闭arc下的warning
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        // 将事件通知给menu bar
        [self.target performSelector:self.selector withObject:self];
#pragma clang diagnostic pop
        
    }
}

@end
