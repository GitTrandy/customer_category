//
//  UIViewController+ImagePickerRotationBugFixed.h
//  beatmasterSNS
//
//  Created by Sunny on 13-8-27.
//
//

#import <UIKit/UIKit.h>

/* 
 UIImagePicker需要app支持竖屏，如果只加竖屏支持的话将引起所有ViewContoller的竖屏问题
 此Category将所有ViewController的竖屏旋转滤去，相对于从每个VC里都加入旋转支持是一个tricky的方法
 */
@interface UIViewController (ImagePickerRotationBugFixed)
// Override
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
- (NSUInteger)supportedInterfaceOrientations;
@end
