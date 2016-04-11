//
//  PhotoPicker.h
//  circle_iphone
//
//  Created by trandy on 15/3/4.
//  Copyright (c) 2015年 ctquan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BTBlock)(UIImage *);

@interface PhotoPicker : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController*    _picker;
    UIImage*                    _pickedPhoto;
    BTBlock                     _block;
    UIPopoverController *_popoverController;
}

@property (nonatomic, assign) BOOL isEdit;

//singleton
+ (PhotoPicker *)sharedPhotoPicker;

//do pick
//- (void)pickPhotoWithViewController:(UIViewController *)parent useCamera:(BOOL)useCamera onFinished:(void(^)(UIImage*))block;
- (void)pickPhotoWithViewController:(UIViewController *)parent useCamera:(BOOL)useCamera targetRect:(CGRect)targetRect ArrowDirection:(UIPopoverArrowDirection)direction onFinished:(BTBlock)block;

//resize photo
- (void)resizePickedPhoto:(CGSize)size;

//get picked photo
- (UIImage *)pickedPhoto;
- (UIImage *)pickedPhotoWithSize:(CGSize)size;

//save (file name must ended by jpg or png)
- (void)saveWithFileName:(NSString *)fileName quality:(CGFloat)quality;

//load (file name must ended by jpg or png)
- (UIImage *)loadWithFileName:(NSString *)fileName;

@end
