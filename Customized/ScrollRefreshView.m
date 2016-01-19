//
//  DragRefreshView.m
//  SunnyPageScrollView
//
//  Created by  on 12-7-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ScrollRefreshView.h"




typedef enum 
{
    ScrollRefreshViewStateNormal        = 2 << 0,
    ScrollRefreshViewStateScrolling     = 2 << 1,
    ScrollRefreshViewStateRefreshing    = 2 << 2
    
}ScrollRefreshViewState;

CGFloat const ArrowAnimationDuration = 0.5f;
CGFloat const InsetAnimationDuration = 0.5f;
CGFloat const ContentInsetValue =  60.0f;
NSString* const NormalStateString = @"pull to refresh";
NSString* const ScrollingStateString = @"release to refresh";
NSString* const RefreshingStateString = @"refreshing";
CGSize const ArrowSize = {50, 50};

@interface ScrollRefreshView (Private) 

- (void)changeState:(ScrollRefreshViewState)newState;

@end




@implementation ScrollRefreshView
{
    UIActivityIndicatorView* _loadingIndicator; //菊花状loading指示器
    CALayer*                 _arrowLayer;
    ScrollRefreshViewState   _state;
}

@synthesize delegate = _delegate;
@synthesize textLabel = _textLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        
        //self.userInteractionEnabled = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor blueColor];
        
        
        _textLabel = [[UILabel alloc] initWithFrame:SNSRect(0, 0, 200, 50)];
        _textLabel.font = [UIFont systemFontOfSize:12.0f];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.center = SNSPoint(self.frame.size.width / 2, 200);
        _textLabel.textAlignment = UITextAlignmentRight;
        _textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLabel];
        _textLabel.transform = CGAffineTransformMakeRotation(-90*M_PI/180.0f);
        
        //箭头的CALayer
        _arrowLayer = [CALayer layer];
        _arrowLayer.frame = SNSRect(0, 0, ArrowSize.width, ArrowSize.height);
        _arrowLayer.contentsGravity = kCAGravityResizeAspect;
        _arrowLayer.contentsScale = [[UIScreen mainScreen] scale];
        [self.layer addSublayer:_arrowLayer];
        
  
        self.layer.backgroundColor = [UIColor blueColor].CGColor;
        
        _loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:SNSRect(0, 0, ArrowSize.width, ArrowSize.height)];
        [self addSubview:_loadingIndicator];
        
        
        //state
        [self changeState:ScrollRefreshViewStateNormal];
        
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame arrowImage:(UIImage *)arrowImage
{
    self = [self initWithFrame:frame];
    if (self) 
    {
        [self setArrowImage:arrowImage];
    }
    return self;
}

- (void)setArrowImage:(UIImage *)arrowImage
{
    _arrowLayer.contents = (id)arrowImage.CGImage;
}




- (void)refreshViewDidScroll:(UIScrollView *)scrollView
{
    
    scrollView.contentInset = UIEdgeInsetsMake(0.0f, ContentInsetValue, 0.0f, 0.0f);
    
    if ((_state & ScrollRefreshViewStateScrolling) && scrollView.contentOffset.x > -ContentInsetValue && scrollView.contentOffset.x < 0.0f) 
    {
        [self changeState:ScrollRefreshViewStateNormal];
    }
    else if ((_state & ScrollRefreshViewStateNormal) && scrollView.contentOffset.x < -ContentInsetValue)
    {
        [self changeState:ScrollRefreshViewStateScrolling];
    }

    
}

- (void)refreshViewDidEndDragging:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x <= - ContentInsetValue && !(_state & ScrollRefreshViewStateRefreshing)) 
    {
		
		if ([_delegate respondsToSelector:@selector(scrollRefreshViewShouldBeginRefresh:)]) 
        {
			[_delegate scrollRefreshViewShouldBeginRefresh:self];
		}
		
		[self changeState:ScrollRefreshViewStateRefreshing];

	}
}


- (void)refreshViewDidFinishRefreshData:(UIScrollView *)scrollView
{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:InsetAnimationDuration];
	[scrollView setContentInset:UIEdgeInsetsZero];
	[UIView commitAnimations];
	[self changeState:ScrollRefreshViewStateNormal];
    
}


#pragma mark - Private method

- (void)changeState:(ScrollRefreshViewState)newState
{
    if (newState & ScrollRefreshViewStateNormal) 
    {
        if (_state & ScrollRefreshViewStateScrolling) {
            [CATransaction begin];
            [CATransaction setAnimationDuration:ArrowAnimationDuration];
            _arrowLayer.transform = CATransform3DIdentity;
            [CATransaction commit];
        }
        
        _textLabel.text = NormalStateString;
        [_loadingIndicator stopAnimating];
        
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
        _arrowLayer.hidden = NO;
        _arrowLayer.transform = CATransform3DIdentity;
        [CATransaction commit];
        
        
    }
    else if (newState & ScrollRefreshViewStateScrolling)
    {
        _textLabel.text = ScrollingStateString;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:ArrowAnimationDuration];
        _arrowLayer.transform = CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 1.0f);
        [CATransaction commit];
        
    }
    else if (newState & ScrollRefreshViewStateRefreshing)
    {
        _textLabel.text = RefreshingStateString;
        [_loadingIndicator startAnimating];
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
        _arrowLayer.hidden = YES;
        [CATransaction commit];
    }
    
    _state = newState;
}















@end
