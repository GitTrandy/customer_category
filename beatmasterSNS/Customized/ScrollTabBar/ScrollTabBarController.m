//Sunny
//2012.8.9

#import "ScrollTabBarController.h"

#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

@interface ScrollTabBarController ()

@end

@implementation ScrollTabBarController


#pragma mark - property

@synthesize scrollTabBar = _scrollTabBar;
@synthesize returnItem = _returnItem;
@synthesize viewControllers = _viewControllers;
@synthesize selectedViewController = _selectedViewController;
@synthesize autoReturn = _autoReturn;
@synthesize autoTransformViewController = _autoTransformViewController;

#pragma mark - create

- (id)init
{
    self = [super init];
    if (self) 
    {
        //default value
        _autoReturn = YES;
        _autoTransformViewController = YES;
        
        //test
        _selectedViewController = [[[UIViewController alloc] init] autorelease];
        [self addChildViewController:_selectedViewController];
        [self.view addSubview:_selectedViewController.view];
        //_selectedViewController.view.frame = CGRectMake(150, 0, 200, 300);

    }
    return self;
}

- (id)initWithViewFrame:(CGRect)frame
{
    self = [self init];
    self.view.frame = frame;
    
    _scrollTabBar.frame = CGRectMake(frame.size.width - 40, 0, 40, frame.size.height);
    
    return self;
}

#pragma mark - public

- (void)scrollTabBarDidSelectedReturnItem:(ScrollTabBarItem *)returnItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollTabBarItem:(ScrollTabBarItem *)item didSelectedItemAtIndex:(int)index
{
    [self transitionToViewControllerAtIndex:index];
}

- (void)transitionToViewControllerAtIndex:(NSUInteger)index
{
    
    UIViewController* toVC = _viewControllers[index];
    
    __block typeof(self) weakSelf = self;
    if (toVC != _selectedViewController) 
    {
        [self transitionFromViewController:_selectedViewController toViewController:toVC duration:0.1f options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
            if (finished) 
            {
                weakSelf->_selectedViewController = toVC;
            }
        }];
    }
    

}

#pragma mark - property setters

- (void)setReturnItem:(ScrollTabBarItem *)returnItem
{
    if (_returnItem != returnItem) 
    {
        [_returnItem release];
        _returnItem = [returnItem retain];
    }
    
    //send msg
    if (_autoReturn) 
    {
        __block typeof(self) weakSelf = self;
        [_scrollTabBar setReturnItem:returnItem block:^(ScrollTabBarItem *returnItem) {
            [weakSelf scrollTabBarDidSelectedReturnItem:returnItem];
        }];
    }

}

- (void)setViewControllers:(NSArray *)viewControllers
{
    
    //remove vcs
    for (UIViewController* vc in _viewControllers) 
    {
        [vc removeFromParentViewController];
    }
    
    //copy new
    [_viewControllers release];
    _viewControllers = [viewControllers copy];
    
    
    NSMutableArray* items = [NSMutableArray array];
    for (UIViewController* vc in _viewControllers) 
    {
        [self addChildViewController:vc];
        //[self willMoveToParentViewController:nil];
        [items addObject:vc.scrollTabBarItem];

    }
    
    //add items to scroll tab bar
    if (_autoTransformViewController) 
    {
        __block typeof(self) weakSelf = self;
        [_scrollTabBar setItems:items block:^(ScrollTabBarItem* item, int index) {
            [weakSelf scrollTabBarItem:item didSelectedItemAtIndex:index];
        }];
    }

}

#pragma mark - override

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}



- (void)loadView
{
    [super loadView];
    
    //content view(for add tab bar)
//    _contentView = [[UIView alloc] init];
//    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    _contentView.frame = CGRectMake(0, 0, 100, 320);
//    [self.view addSubview:_contentView];
    
    //init scroll tab bar
    _scrollTabBar = [[ScrollTabBar alloc] init];
    //[self.view addSubview:_scrollTabBar];
    [self.view addSubview:_scrollTabBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_viewControllers.count > 0) 
    {
        [self transitionToViewControllerAtIndex:0];
    }
    
    [self.view bringSubviewToFront:_scrollTabBar];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - private

#pragma mark - dealloc

- (void)dealloc
{
    //class variables
    
    //properties
    [_scrollTabBar release];
    [_returnItem release];
    [_viewControllers release];
    _selectedViewController = nil;
    [super dealloc];
}

@end





@implementation UIViewController (ScrollTabBarControllerItem)

static char ScrollTabBarItemKey;

@dynamic scrollTabBarItem;

- (ScrollTabBarItem *)scrollTabBarItem
{
    return objc_getAssociatedObject(self, &ScrollTabBarItemKey);
}

- (void)setScrollTabBarItem:(ScrollTabBarItem *)scrollTabBarItem
{
    return objc_setAssociatedObject(self, &ScrollTabBarItemKey, scrollTabBarItem, OBJC_ASSOCIATION_RETAIN);

}

@end


