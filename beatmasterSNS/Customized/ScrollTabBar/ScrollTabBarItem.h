//Sunny
//8.8

#import <UIKit/UIKit.h>


@interface ScrollTabBarItem : UIButton
{
    @private
    UITapGestureRecognizer*     _tapRecognizer;
    UIImageView*                _image_View;
    
    //
    UIImageView *_maskImageView;    //选中框
    BOOL    _frameIsSet;    // YES:是外部程序设定的 NO:是通过图片Size设置的
}

+ (id)item;
+ (id)itemWithImage:(UIImage *)image selected:(UIImage *)selectedImage;
+ (id)itemWithImageName:(NSString *)imageName selected:(NSString *)selectedImageName;

+ (id)itemWithImageNameAndFrame:(CGRect)frame common:(NSString *)commonImageName highlighted:(NSString *)highlightedImageName selected:(NSString *)selectedIamgeName mask:(NSString *)maskImageName;

+(id)itemWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName selected:(NSString *)selectedImageName;

@property (nonatomic, assign) BOOL frameIsSet;
@property (nonatomic, assign) BOOL isVertical; // 是否是垂直的scrollbar上的按钮

//item background
@property (nonatomic, retain) UIImageView* backgroundImageView;  //default is nil, set image with |.image|
//@property (nonatomic, retain) UIImageView* underImageView;  //reserved

//layout
@property (nonatomic) UIEdgeInsets imageInsets;     //default is UIEdgeInsetsZero

//set width | height to change frame, keep w/h ratio
- (void)setFrameKeepRatioWithWidth:(CGFloat)width;
- (void)setFrameKeepRatioWithHeight:(CGFloat)height;

//image in item
@property (nonatomic, retain) UIImage* image;               //default is nil
@property (nonatomic, retain) UIImage* selectedImage;       //default is nil

@property (nonatomic, retain) UIImage *maskImage;

//item action
@property (nonatomic) BOOL selected;    //defalut NO, set YES image will change
//block
@property (nonatomic, copy) void (^block)(ScrollTabBarItem* selectedItem);  //default nil

//just exe the block
- (void)executeSelectedBlock;

@end

//adapt to old (deprecate)
@interface ScrollTabBarItem(ScrollTabBarItemDeprecated)

- (id)initWithImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage;
+ (id)initWithImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage;

@end


