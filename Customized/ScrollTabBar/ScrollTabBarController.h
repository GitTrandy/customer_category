//Sunny
//2012.8.9

#import <UIKit/UIKit.h>

#import "ScrollTabBar.h"

@interface ScrollTabBarController : UIViewController
{
    @protected    
    //UIView* _contentView;   //for add scrollTabBar, make it top
}

- (id)initWithViewFrame:(CGRect)frame;

//scrollTabBar in controller
@property (nonatomic, retain) ScrollTabBar* scrollTabBar;     //default is empty

@property (nonatomic, retain) ScrollTabBarItem* returnItem;   //default nil

//view controllers that stored
//auto display the first view controller
@property (nonatomic, copy)     NSArray* viewControllers;    //default is nil
@property (nonatomic, readonly) UIViewController* selectedViewController;   //default is the first, return nil if viewControllers nil

//control
//override it to deal callbacks, default auto transform
- (void)scrollTabBarDidSelectedReturnItem:(ScrollTabBarItem *)returnItem;
- (void)scrollTabBarItem:(ScrollTabBarItem *)item didSelectedItemAtIndex:(int)index;

//translate
//auto transform view controller by selected item
//also send the selected message
@property (nonatomic) BOOL autoReturn;                      //default YES
@property (nonatomic) BOOL autoTransformViewController;     //default YES

//transition from last selected view controller to new selected view controller
- (void)transitionToViewControllerAtIndex:(NSUInteger)index;

@end




//UIViewController Category
//can set a scroll tab bar item to a view controller
@interface UIViewController (ScrollTabBarControllerItem)

@property (nonatomic, retain) ScrollTabBarItem* scrollTabBarItem;

@end


