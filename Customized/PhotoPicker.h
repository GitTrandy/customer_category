//Sunny
//2012.7.4

#import <UIKit/UIKit.h>

typedef void (^BTBlock)(UIImage *);

@interface PhotoPicker : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController*    _picker;
    UIImage*                    _pickedPhoto;
    BTBlock                     _block;
    UIPopoverController *_popoverController;
}

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
