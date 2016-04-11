//
//  CTPhotoBrowse.m
//  circle_iphone
//
//  Created by sujie on 15/4/20.
//  Copyright (c) 2015年 ctquan. All rights reserved.
//

#import "CTPhotoBrowse.h"

@interface CTPhotoBrowse ()
{
    UIScrollView *imgScrollView;
    UIPageControl *pageControl;
    NSMutableArray *scrollArray;
}
@end

@implementation CTPhotoBrowse

+ (instancetype)sharedCTPhotoBrowse
{
    static CTPhotoBrowse *photoBrowse = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        photoBrowse = [[CTPhotoBrowse alloc] init];
        photoBrowse.backgroundColor = [UIColor blackColor];
    });
    return photoBrowse;
}

- (void)createPhotoBrowseView
{
    self.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    
    imgScrollView = [[UIScrollView alloc] init];
    imgScrollView.frame = CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
    imgScrollView.contentSize = CGSizeMake(DEVICE_WIDTH * self.imgData.count, 0);
    imgScrollView.contentOffset = CGPointMake(self.frame.size.width * self.page, 0);
    imgScrollView.pagingEnabled = YES;
    imgScrollView.delegate = self;
    [self addSubview:imgScrollView];
    
    scrollArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i = 0; i < self.imgData.count; i++) {
        UIScrollView *scroll = [[UIScrollView alloc] init];
        scroll.frame = CTRect(DEVICE_WIDTH * i, 0, DEVICE_WIDTH, DEVICE_HEIGHT);
        scroll.backgroundColor = [UIColor clearColor];
        scroll.tag = i;
        [imgScrollView addSubview:scroll];
        
        [scrollArray addObject:scroll];
        
        //触发层
        UIView *touchView = [[UIView alloc] init];
        touchView.frame = CTRect(0, 0, scroll.frame.size.width, scroll.frame.size.height);
        touchView.backgroundColor = [UIColor clearColor];
        touchView.tag = i;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleSingleTap:)];
        singleTap.numberOfTapsRequired = 1;
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        [touchView addGestureRecognizer:singleTap];
        [touchView addGestureRecognizer:doubleTap];
        
        
        UIImage *defaultImage = [UIImage imageNamed:@"PD_banner_img.png"];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        if (IS_IPHONE6) {
            imageView.frame = CTRect((DEVICE_WIDTH - defaultImage.size.width * CT_SCALE) / 2,
                                     (DEVICE_HEIGHT - defaultImage.size.height * CT_SCALE) / 2,
                                     defaultImage.size.width * CT_SCALE,
                                     defaultImage.size.height * CT_SCALE);
        }else
        {
            imageView.frame = CTRect((DEVICE_WIDTH - defaultImage.size.width) / 2,
                                     (DEVICE_HEIGHT - defaultImage.size.height) / 2,
                                     defaultImage.size.width,
                                     defaultImage.size.height);
        }
        imageView.image = defaultImage;
        imageView.tag = 99;
        [touchView addSubview:imageView];
        [scroll addSubview:touchView];
        
        //scrollView缩放设置
        scroll.delegate = self;
        scroll.maximumZoomScale = 2.0;
        scroll.minimumZoomScale = 1.0;
        scroll.contentSize = imageView.frame.size;
        
        
        [imageView sd_setImageWithURL:self.imgData[i]
                     placeholderImage:defaultImage
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                if (image != nil) {
                                    float scaleW = 0.0f;
                                    float scaleH = 0.0f;
                                    if (image.size.width > DEVICE_WIDTH && image.size.height > DEVICE_HEIGHT) {
                                        //宽高都超标
                                        scaleW = DEVICE_WIDTH / image.size.width;
                                        scaleH = DEVICE_HEIGHT / image.size.height;
                                        if (scaleW < scaleH) {
                                            imageView.frame = CGRectMake((DEVICE_WIDTH - image.size.width * scaleW) / 2,
                                                                         (DEVICE_HEIGHT - image.size.height * scaleW) / 2,
                                                                         image.size.width * scaleW,
                                                                         image.size.height * scaleW);
                                        }else
                                        {
                                            imageView.frame = CGRectMake((DEVICE_WIDTH - image.size.width * scaleH) / 2,
                                                                         (DEVICE_HEIGHT - image.size.height * scaleH) / 2,
                                                                         image.size.width * scaleH,
                                                                         image.size.height * scaleH);
                                        }
                                    }else if (image.size.width > DEVICE_WIDTH && image.size.height <= DEVICE_HEIGHT) {
                                        //宽超标 高没超标
                                        scaleW = DEVICE_WIDTH / image.size.width;
                                        imageView.frame = CGRectMake((DEVICE_WIDTH - image.size.width * scaleW) / 2,
                                                                     (DEVICE_HEIGHT - image.size.height * scaleW) / 2,
                                                                     image.size.width * scaleW,
                                                                     image.size.height * scaleW);
                                    }else if (image.size.width <= DEVICE_WIDTH && image.size.height > DEVICE_HEIGHT) {
                                        //宽没超标 高超标
                                        scaleH = DEVICE_HEIGHT / image.size.height;
                                        imageView.frame = CGRectMake((DEVICE_WIDTH - image.size.width * scaleH) / 2,
                                                                     (DEVICE_HEIGHT - image.size.height * scaleH) / 2,
                                                                     image.size.width * scaleH,
                                                                     image.size.height * scaleH);
                                    }else
                                    {
                                        //宽高都没超标
                                        imageView.frame = CGRectMake((DEVICE_WIDTH - image.size.width) / 2,
                                                                     (DEVICE_HEIGHT - image.size.height) / 2,
                                                                     image.size.width,
                                                                     image.size.height);
                                    }
                                    imageView.image = image;
                                    
                                }
                                
                            }];
    }
    
    pageControl = [[UIPageControl alloc] init];
    pageControl.backgroundColor = CTClearColor;
    pageControl.frame = CTRect(0, DEVICE_HEIGHT - 30, DEVICE_WIDTH, 30);
    pageControl.numberOfPages = self.imgData.count;
    pageControl.currentPage = self.page;
    [pageControl addTarget:self
                    action:@selector(changePage:)
          forControlEvents:UIControlEventValueChanged];
    [self addSubview:pageControl];
}

- (void)changePage:(id)sender
{
    NSInteger page = pageControl.currentPage;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         imgScrollView.contentOffset = CTPoint(DEVICE_WIDTH * page, 0);
                     }
                     completion:nil
     ];
}

//#pragma mark - 单击图片
//- (void)singleTap:(UITapGestureRecognizer *)tap
//{
//    CTLogFunction;
//    [self.deleagte dismissCTPhotoClick];
//}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControl.currentPage = scrollView.contentOffset.x / DEVICE_WIDTH;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{

    return [scrollView viewWithTag:99];
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;

    UIView *view = [scrollView viewWithTag:99];
    view.center = CGPointMake(scrollView.contentSize.width/2 + offsetX,scrollView.contentSize.height/2 + offsetY);
}


- (void)handleSingleTap:(UITapGestureRecognizer *)tap
{
    SYXLog(@"单击");
    [self.deleagte dismissCTPhotoClick:pageControl.currentPage];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap
{
    SYXLog(@"双击");
    
    NSInteger tag = [tap view].tag;
    UIScrollView *scroll = scrollArray[tag];
    CGFloat zs = scroll.zoomScale;
    zs = (zs == 1.0)?2.0:1.0;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         scroll.zoomScale = zs;
                     }];
}

//#pragma mark - touchBegan
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
//    
//    UITouch *touch = [touches anyObject];
//    
//    UIScrollView *scroll = (UIScrollView *)[touch view];
//    
//    if ([touch tapCount] == 1) {
//        [self performSelector:@selector(singleTap:) withObject:nil afterDelay:0.3];
//    }else if ([touch tapCount] == 2) {
//        CGFloat zs = scroll.zoomScale;
//        zs = (zs == 1.0)?2.0:1.0;
//        
//        [UIView animateWithDuration:0.3
//                         animations:^{
//                             scroll.zoomScale = zs;
//                         }];
//        
//    }
//}

@end
