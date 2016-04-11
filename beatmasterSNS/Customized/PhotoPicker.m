//Sunny
//2012.7.4

#import "PhotoPicker.h"

@implementation PhotoPicker

static PhotoPicker* sharedPhotoPicker = nil;
static int PickedPhotoDictionary = NSLibraryDirectory;
static NSString* PickedPhotoFolderName = @"PickedPhoto";

#pragma mark - init

- (id)init
{
    self = [super init];
    if (self) 
    {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;                                        //设置代理对象
        _picker.mediaTypes = @[@"public.image"]; //使用图片（非视频）
        _picker.allowsEditing = YES;                                    //启动编辑模式
        
    }
    return self;
}

#pragma mark - singleton

+ (PhotoPicker *)sharedPhotoPicker
{
    if (!sharedPhotoPicker) 
    {
        sharedPhotoPicker = [[PhotoPicker alloc] init];
    }
    return sharedPhotoPicker;
}

#pragma mark - do pick photo

//- (void)pickPhotoWithViewController:(UIViewController *)parent useCamera:(BOOL)useCamera onFinished:(void (^)(UIImage *))block
- (void)pickPhotoWithViewController:(UIViewController *)parent useCamera:(BOOL)useCamera targetRect:(CGRect)targetRect ArrowDirection:(UIPopoverArrowDirection)direction onFinished:(BTBlock)block
{
    //copy block
    _block = Block_copy(block);
    
    if (useCamera) 
    {
        if (![UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) 
        {
            SNSLog(@"PhotoPicker:camera cannot use...");
            return;
        }
        //设置为照相机模式
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;   
        
        //前照相机
        _picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        
        //闪光灯自动
        _picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        
        //设置图像质量 最高
        _picker.videoQuality = UIImagePickerControllerQualityTypeHigh;
        
        //拍照模式（拍照/视频）
        _picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;

    }
    else
    {
        if (![UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) 
        {
            SNSLog(@"PhotoPicker:album cannot use...");
            return;
        }
        //相册模式
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    //弹出picker view
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone || useCamera){
        _popoverController = nil;
        [parent presentModalViewController:_picker animated:YES];
    }else{
        _popoverController=[[UIPopoverController alloc] initWithContentViewController:_picker] ;
        [_popoverController presentPopoverFromRect:targetRect  inView:parent.view permittedArrowDirections:direction animated:YES];
    }
}

#pragma mark - resize picked photo

- (void)resizePickedPhoto:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [_pickedPhoto drawInRect:CGRectMake(0, 0, size.width, size.height)];
    _pickedPhoto = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

#pragma mark - get picked photo

- (UIImage *)pickedPhoto
{
    if (_pickedPhoto == nil) 
    {
        SNSLog(@"PhotoPicker:photo is nil...");
    }
    return _pickedPhoto;
}

//get the picked photo with a given size
- (UIImage *)pickedPhotoWithSize:(CGSize)size
{
    if (_pickedPhoto == nil) 
    {
        SNSLog(@"PhotoPicker:photo is nil...");
        return _pickedPhoto;
    }
    [self resizePickedPhoto:size];
    return _pickedPhoto;
}

#pragma mark - file save && load

- (void)saveWithFileName:(NSString *)fileName quality:(CGFloat)quality
{
    
    if (_pickedPhoto == nil || fileName == nil) 
    {
        SNSLog(@"PhotoPicker:saving: photo or fileName nil");
    }
    
    //get path
    NSArray* pathDict = NSSearchPathForDirectoriesInDomains(PickedPhotoDictionary, NSUserDomainMask, YES);
    NSString* path = pathDict[0];
    
    //create floder path
    NSString* floderPath = [path stringByAppendingPathComponent:PickedPhotoFolderName];
    
    //remove old if exist
    if ([[NSFileManager defaultManager]isReadableFileAtPath:floderPath]) 
    {
        [[NSFileManager defaultManager] removeItemAtPath:floderPath error:nil];
    }
    [[NSFileManager defaultManager] createDirectoryAtPath:floderPath withIntermediateDirectories:YES attributes:nil error:nil];

    //full path
    NSString* fullPath = [floderPath stringByAppendingPathComponent:fileName];
    
    //jepg || png by file name extension
    NSString* fileType = [fileName pathExtension];
    
    //get data
    NSData* data = nil;
    if ([[fileType lowercaseString] isEqualToString:@"png"]) 
    {
        data = UIImagePNGRepresentation(_pickedPhoto);
    }
    else if ([[fileType lowercaseString] isEqualToString:@"jpg"]) 
    {
        data = UIImageJPEGRepresentation(_pickedPhoto, quality);
    }
    
    //write data
    [data writeToFile:fullPath atomically:YES];
    
}

- (UIImage *)loadWithFileName:(NSString *)fileName
{
    if (fileName == nil) 
    {
        SNSLog(@"PhotoPicker:loading: fileName nil");
    }
    
    //get path
    NSArray* pathDict = NSSearchPathForDirectoriesInDomains(PickedPhotoDictionary, NSUserDomainMask, YES);
    NSString* path = pathDict[0];
    
    //create floder path
    NSString* floderPath = [path stringByAppendingPathComponent:PickedPhotoFolderName];
    
    //full path
    NSString* fullPath = [floderPath stringByAppendingPathComponent:fileName];
    
    //read data
    NSData* data = [[NSFileManager defaultManager] contentsAtPath:fullPath];
    UIImage* image = [UIImage imageWithData:data];
    
    return image;
}

#pragma mark - delegate method

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    // 修复iOS7中状态栏被异常显示的bug
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    Class classPLUIImage = NSClassFromString(@"PLUIImageViewController");
    if ([viewController isKindOfClass:classPLUIImage])
    {
        Class classPLTile = NSClassFromString(@"PLTileContainerView");
        for (UIView* subview in [viewController.view subviews])
        {
            if ([subview isKindOfClass:classPLTile])
            {
                Class classPLScroll = NSClassFromString(@"PLImageScrollView");
                for (UIView* subview1 in [subview subviews])
                {
                    if ([subview1 isKindOfClass:classPLScroll])
                    {
                        float fScale = 0.f;
                        Class classPLExpandable = NSClassFromString(@"PLExpandableImageView");
                        for (UIView* subview2 in [subview1 subviews])
                        {
                            if ([subview2 isKindOfClass:classPLExpandable])
                            {
                                float h = subview2.frame.size.height;
                                float d = subview2.transform.d;
                                float hTmp = 320.f;
                                if (IS_IPADUI)
                                {
                                    hTmp = 338.f;
                                }
                                if (h<hTmp)
                                {
                                    //计算最小的缩放值
                                    fScale = hTmp*d/h;
                                }
                                
                                break;
                            }
                        }
                        
                        if (!(fabs(fScale) < 0.000001f))
                        {
                            //fScale!=0.f
                            if ([subview1 isKindOfClass:[UIScrollView class]])
                            {
                                UIScrollView* p =(UIScrollView*)subview1;
                                p.minimumZoomScale = fScale;
                                [p setZoomScale:fScale animated:YES];
                                
                                WLLog(@"setZoomScale=%f", fScale);
                            }
                        }
                        
                        break;
                    }
                }
                break;
            }
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (_pickedPhoto != nil)
    {
        // Releae previous pick
        [_pickedPhoto release];
        _pickedPhoto = nil;
    }
    
    //得到编辑后的图像
    CGFloat compression = 1.f;
    CGFloat maxCompression = 0.1f;
    int maxImageSize = 150 * 1024;
    
    _pickedPhoto = [info[UIImagePickerControllerEditedImage] copy];
    
    NSData *imageData = UIImageJPEGRepresentation(_pickedPhoto, compression);
    
    while (imageData.length > maxImageSize && compression > maxCompression) {
        compression -= 0.05f;
        imageData = UIImageJPEGRepresentation(_pickedPhoto, compression);
    }
    
    [_pickedPhoto release];
    _pickedPhoto = [[UIImage imageWithData:imageData] copy];

    [self performSelectorOnMainThread:@selector(callBlock:) withObject:_block waitUntilDone:[NSThread isMainThread]];
    
    //返回parent view controller
    [picker dismissModalViewControllerAnimated:YES];
    
    if (_popoverController) {
        [_popoverController dismissPopoverAnimated:YES];
    }
}

- (void)callBlock:(BTBlock)theBlock
{
    theBlock([self pickedPhoto]);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //返回parent view controller
    [_picker dismissModalViewControllerAnimated:YES];
    if (_popoverController) {
        [_popoverController dismissPopoverAnimated:YES];
    }
}

#pragma mark - dealloc

-(void)dealloc
{
    
    
    if (_popoverController) {
        [_popoverController release];
        _popoverController = nil;
    }
    [_pickedPhoto release];
    _pickedPhoto = nil;
    
    [_picker release];
    _picker = nil;
    
    Block_release(_block);
    
    [super dealloc];
}

@end
