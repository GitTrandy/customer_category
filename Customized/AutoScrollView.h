//Sunny
//2012.7.19

#import <UIKit/UIKit.h>
#import "iCarousel.h"


@class AdInfo;
@class RNTimer;

@protocol AdJumpDelegate <NSObject>

@optional

-(void)jumpToAdPresentVC:(AdInfo*) aInfo;

@end



@interface AutoScrollView : UIView <iCarouselDataSource, iCarouselDelegate>
{

    @private
    iCarousel*          _carouselView;
    NSMutableArray*     _itemObjects;
    NSMutableSet*       _needDownloadImg;
    UIImageView*        _bgImageView;
    UIPageControl*      _pageControl;
    RNTimer*            _timer;
    
    id<AdJumpDelegate>  _delegate;
}

@property (nonatomic,assign) id<AdJumpDelegate> delegate;


- (void)addAdItem:(AdInfo *)itemAd;
- (void)setBackgroundImage:(UIImage *)image;
- (void)beginDownloadAdImage;
@end
