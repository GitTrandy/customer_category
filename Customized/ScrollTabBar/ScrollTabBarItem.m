//Sunny
//8.8

#import "ScrollTabBarItem.h"
#import "SoundComDef.h"

@interface ScrollTabBarItem()

- (void)tapRecognizerCallBack:(UITapGestureRecognizer *)recognizer;
- (void)layout;

@end


@implementation ScrollTabBarItem

#pragma mark - property

@synthesize backgroundImageView = _backgroundImageView;

@synthesize image = _image;
@synthesize selectedImage = _selectedImage;
@synthesize maskImage = _maskImage;
@synthesize imageInsets = _imageInsets;

@synthesize selected = _selected;
@synthesize block = _block;
@synthesize frameIsSet = _frameIsSet;

@synthesize isVertical = _isVertical;

#pragma mark - create

- (id)init
{
    self = [super init];
    if (self) 
    {
        //init default value
        _imageInsets = UIEdgeInsetsZero;
        _selected = NO;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // mask image view
        _maskImageView = [[UIImageView alloc] init];
        _maskImageView.autoresizingMask = UIViewAutoresizingNone;
        [self addSubview:_maskImageView];
        
        //add tap recognizer
//        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizerCallBack:)];
//        _tapRecognizer.numberOfTouchesRequired = 1U;
//        _tapRecognizer.numberOfTapsRequired = 1U;
//        [self addGestureRecognizer:_tapRecognizer];
        
        //backgroundView
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_backgroundImageView];
        
        //image view
        _image_View = [[UIImageView alloc] init];
        _image_View.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_image_View];
        
        //
        _frameIsSet = NO;        
    }
    self.exclusiveTouch = YES;
    return self;
}

+ (id)item
{
    return [[[ScrollTabBarItem alloc] init] autorelease];
}

+ (id)itemWithImage:(UIImage *)image selected:(UIImage *)selectedImage
{
    ScrollTabBarItem* item = [[[ScrollTabBarItem alloc] init] autorelease];
    [item setBackgroundImage:image forState:UIControlStateNormal];
    [item setBackgroundImage:selectedImage forState:UIControlStateHighlighted];

    item.frame = CGRectMake(0, 0, image.size.width*SNS_SCALE, image.size.height*SNS_SCALE);
    return item;
}

+ (id)itemWithImageName:(NSString *)imageName selected:(NSString *)selectedImageName
{
    return [self itemWithImage:[UIImage imageNamed_New:imageName] selected:[UIImage imageNamed_New:selectedImageName]];
}

+ (id)itemWithImageNameAndFrame:(CGRect)frame common:(NSString *)commonImageName highlighted:(NSString *)highlightedImageName selected:(NSString *)selectedIamgeName mask:(NSString *)maskImageName{
    ScrollTabBarItem *item = [ScrollTabBarItem itemWithImageName:commonImageName selected:selectedIamgeName];
    
    item.frame = frame;
    item.frameIsSet = YES;
    item.maskImage = [UIImage imageNamed_New:maskImageName];
    
    item.selectedImage = [UIImage imageNamed_New:highlightedImageName];
    
    return item;
}

+(id)itemWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName selected:(NSString *)selectedImageName
{
    ScrollTabBarItem *item = [[[ScrollTabBarItem alloc]init]autorelease];
    UIImage *norImg = [UIImage imageNamed_New:imageName];
    UIImage *highlightImg = [UIImage imageNamed_New:highlightImageName];
    UIImage *selectImg = [UIImage imageNamed_New:selectedImageName];
    CGSize size = norImg.size;
    item.frame = CGRectMake(0, 0, size.width*SNS_SCALE, size.height*SNS_SCALE);
    [item setBackgroundImage:norImg forState:UIControlStateNormal];
    [item setBackgroundImage:highlightImg forState:UIControlStateHighlighted];
    item.selectedImage = selectImg;
    
    return item;
}

#pragma mark - public

- (void)setImage:(UIImage *)image
{
    if (_image != image) 
    {
        [_image release];
        _image = [image retain];
        
        if (!_selected) 
        {
            _image_View.image = image;
        }
        
    }
}

- (void)setSelectedImage:(UIImage *)image
{
    if (_selectedImage != image) 
    {
        [_selectedImage release];
        _selectedImage = [image retain];
        
        if (_selected) 
        {
            _image_View.image = image;
            
        }
    }
}

- (void)setImageInsets:(UIEdgeInsets)imageInsets
{
    _imageInsets = imageInsets;
    [self layout];
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    if(!selected && _image)
    {
        _image_View.image = _image;
    }
    else if (selected && _selectedImage) 
    {
        _image_View.image = _selectedImage;
    }
    else
    {
        _image_View.image = nil;
    }

    if (_maskImage) {
        if (NO == selected) {
            _maskImageView.image = nil;
        }
        else{
            _maskImageView.image = _maskImage;
            [self sendSubviewToBack:_maskImageView];
        }
        _maskImageView.frame = SNSRect(0, 0, _maskImage.size.width*SNS_SCALE, _maskImage.size.height*SNS_SCALE);
    }
    
}

- (void)setFrameKeepRatioWithWidth:(CGFloat)width
{
    if (YES == _frameIsSet) {
        return;
    }
    
    CGFloat ratio = 1.0f;
    if (_image) 
    {
        ratio = _image.size.width / _image.size.height;
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, width / ratio);
    
}

- (void)setFrameKeepRatioWithHeight:(CGFloat)height
{
    CGFloat ratio = 1.0f;
    if (_image) 
    {
        ratio = _image.size.width / _image.size.height;
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, height, height * ratio);
}

- (void)executeSelectedBlock
{
    if (_block) 
    {
        _block(self);
    }
}

#pragma mark - override

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self layout];
}

#pragma mark - private

- (void)layout
{
    _image_View.frame = UIEdgeInsetsInsetRect(self.bounds, _imageInsets);
}

#pragma mark - callback

- (void)tapRecognizerCallBack:(UITapGestureRecognizer *)recognizer
{
        
    if (recognizer.state == UIGestureRecognizerStateRecognized) 
    {
        // play effect
//        PlayEffect(SFX_BUTTON);
        
        // 执行回调
        [self executeSelectedBlock];
    }
}


#pragma mark - dealloc

- (void)dealloc
{
    //class variable
    [_tapRecognizer release];
    [_image_View release];
    
    [_maskImageView release];
    
    //property
    [_backgroundImageView release];
    [_image release];
    [_selectedImage release];
    Block_release(_block);
    SNSLog(@"ScrollTabBarItem dealloc");
    [super dealloc];
}


#pragma mark-
#pragma mark touch event

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_isVertical)
    {
        [self performSelector:@selector(executeSelectedBlockWhenTouchEnded)  withObject:nil afterDelay:0.18];
    }
    else
    {
        [self executeSelectedBlockWhenTouchEnded];
    }
}

-(void)executeSelectedBlockWhenTouchEnded
{
    self.highlighted = NO;
    [self executeSelectedBlock];
}

@end




//adapter
@implementation ScrollTabBarItem (ScrollTabBarItemDeprecated)

- (id)initWithImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage
{
    self = [self init];
    [self setImage:normalImage];
    [self setSelectedImage:highlightedImage];
    return self;
}

+ (id)initWithImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage
{
    return [self itemWithImage:normalImage selected:highlightedImage];
}

@end


