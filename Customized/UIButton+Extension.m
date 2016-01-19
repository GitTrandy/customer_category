//Sunny
//8.1


#import "UIButton+Extension.h"
#import <objc/runtime.h>
#import "SoundComDef.h"

@implementation UIButton (Extension)

#pragma mark - Button Block Extension

static char UIButtonExtensionCallBackKey;

//call back block
- (void)setCallbackBlock:(void (^)(id))callbackBlock
{
    [self addTarget:self action:@selector(callBack:) forControlEvents:UIControlEventTouchUpInside];

    return objc_setAssociatedObject(self, &UIButtonExtensionCallBackKey, callbackBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void(^)(id))callbackBlock
{
    return objc_getAssociatedObject(self, &UIButtonExtensionCallBackKey);
}

//private call back

- (void)callBack:(id)sender
{
    if (self.callbackBlock) 
    {
        self.callbackBlock(sender);
    }
}

+ (UIButton *)buttonCustomWithFrame:(CGRect)frame normalImage:(UIImage *)normal highlightedImage:(UIImage *)highlighted
{
    UIButton* button = [self buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:normal forState:UIControlStateNormal];
    [button setBackgroundImage:highlighted forState:UIControlStateHighlighted];
    button.frame = frame;
    return button;
}

+ (UIButton *)buttonWithView:(UIView *)view
{
    UIButton* button = [self buttonWithType:UIButtonTypeCustom];
    
    button.frame = view.frame;
    [button addSubview:view];
    view.userInteractionEnabled = NO;
    return button;
}

+ (UIButton *)buttonWithImageOfView:(UIView *)view
{
    //gen an autorelease button
    UIButton* button = [self buttonWithType:UIButtonTypeCustom];
    
    //gen image for view
    UIGraphicsBeginImageContext(view.bounds.size);
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 1.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //set image
    [button setImage:viewImage forState:UIControlStateNormal];
    
    return button;
}

- (void)stayAtState:(UIControlState)state
{
    [self setBackgroundImage:[self backgroundImageForState:state] forState:UIControlStateNormal];
    [self setBackgroundImage:[self backgroundImageForState:state] forState:UIControlStateHighlighted];
}

@end


/*
 新的初始化button的方法
 */

#pragma mark-
#pragma mark CustomUIButton

@implementation CustomUIButton

@synthesize act_target = _act_target;
@synthesize act_selector = _act_selector;
@synthesize sfx_res = _sfx_res;
@synthesize toggle_key = _toggle_key;

+(id)buttonWithNormalImage:(NSString*)normalImage highlightImage:(NSString*)highlightImage target:(id)target action:(SEL)action sound:(NSString *)sfx
{
    UIImage* normal = [UIImage imageNamed_New:normalImage];
    UIImage* highlight = [UIImage imageNamed_New:highlightImage];
    
    CGSize normalSize = normal.size;
    CGRect frame = CGRectMake(0.f, 0.f, normalSize.width, normalSize.height);
    
    if (nil == normal)
    {
        return nil;
    }
    
    CustomUIButton* button = [[CustomUIButton alloc] initWithNormalImage:normal highlightImage:highlight target:target action:action sound:sfx frame:frame];
    return [button autorelease];
}

+(id)buttonWithNormalImage:(UIImage*)normalImage highlightImage:(UIImage*)highlightImage target:(id)target action:(SEL)action sound:(NSString *)sfx frame:(CGRect)frame
{
    if (nil == normalImage)
    {
        return nil;
    }
    
    CustomUIButton* button = [[CustomUIButton alloc] initWithNormalImage:normalImage highlightImage:highlightImage target:target action:action sound:sfx frame:frame];
    return [button autorelease];
}

+(id)toggleButtonWithNormalImage:(NSString*)normalImage selectImage:(NSString*)selectImage target:(id)target action:(SEL)action sound:(NSString*)sfx
{
    UIImage* normal = [UIImage imageNamed_New:normalImage];
    
    CGSize normalSize = normal.size;
    CGRect frame = CGRectMake(0.f, 0.f, normalSize.width, normalSize.height);
    
    if (nil == normal)
    {
        return nil;
    }
    CustomUIButton* button = [[CustomUIButton alloc] initWithNormalImage:normal highlightImage:nil target:target action:action sound:sfx frame:frame];
    
    if (nil != button)
    {
        UIImage* select = [UIImage imageNamed_New:selectImage];
        [button setBackgroundImage:select forState:UIControlStateSelected];
        button.toggle_key = YES;
    }
    
    return [button autorelease];
}

-(id)initWithNormalImage:(UIImage*)normalImage highlightImage:(UIImage*)highlightImage target:(id)target action:(SEL)action sound:(NSString*)sfx frame:(CGRect)frame
{
    if (self = [super init])
    {        
        [self setBackgroundImage:normalImage forState:UIControlStateNormal];
        [self setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
        self.frame = frame;
        _isReadyToCallback = YES;
        
        // add action
        self.act_target = target;
        self.act_selector = action;
        self.sfx_res = sfx;
        self.toggle_key = NO;

        [self addTarget:self action:@selector(customCallBack:) forControlEvents:UIControlEventTouchUpInside];
        
        self.exclusiveTouch = YES;
    }
    
    return self;
}

-(void)customCallBack:(id)sender
{
    if (!_isReadyToCallback)
    {
        return;
    }
    
    if (_act_target && [_act_target respondsToSelector:_act_selector])
    {
        PlayEffect(_sfx_res);
        [_act_target performSelector:_act_selector withObject:sender];
    };
    
    // 如果是toggle button，要保持状态
    if (_toggle_key)
    {
        self.selected = !self.isSelected;
    }
    
    // 添加延时标记，防止频繁点击按钮
    self.userInteractionEnabled = NO;
    [self performSelector:@selector(customActionDelay) withObject:nil afterDelay:0.5f];
    _isReadyToCallback = NO;
}

-(void)customActionDelay
{
    self.userInteractionEnabled = YES;
    _isReadyToCallback = YES;
}

-(void)dealloc
{
    [self stopLoadingAnimation];
    
    [CustomUIButton cancelPreviousPerformRequestsWithTarget:self];
    [self removeTarget:self action:@selector(customCallBack:) forControlEvents:UIControlEventTouchUpInside];
    self.sfx_res = nil;
    
    [super dealloc];
}

///
- (void)startLoadingAnimation
{
    if (nil == _spinner)
    {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self addSubview:_spinner];
        _spinner.center = CGPointMake(self.frame.size.width / 2.f, self.frame.size.height / 2.f);
        [_spinner startAnimating];
        [_spinner release];
    }
}

- (void)stopLoadingAnimation
{
    if (nil != _spinner)
    {
        [_spinner stopAnimating];
        [_spinner removeFromSuperview];
        _spinner = nil;
    }
}

@end


/*
 TabButtonItem
 */
#pragma mark -
#pragma mark TabButtonItem

@implementation TabButtonItem

@synthesize itemIndex;

+(id)tabButtonItemWithFrame:(CGRect)frame normalImage:(NSString*)normalImage selectImage:(NSString*)selectImage itemIndex:(NSInteger)index
{
    UIImage* normal = [UIImage imageNamed_New:normalImage];
    UIImage* select = [UIImage imageNamed_New:selectImage];
    
    TabButtonItem* item = [[TabButtonItem alloc ] initWithFrame:frame normalImage:normal selectImage:select itemIndex:index];
    return [item autorelease];
}

-(id)initWithFrame:(CGRect)frame normalImage:(UIImage*)normalImage selectImage:(UIImage*)selectImage itemIndex:(NSInteger)index
{
    if (self = [super init])
    {
        [self setBackgroundImage:normalImage forState:UIControlStateNormal];
        [self setBackgroundImage:normalImage forState:UIControlStateHighlighted];
        [self setBackgroundImage:selectImage forState:UIControlStateSelected];
        self.frame = frame;
        self.itemIndex = index;
        
        self.exclusiveTouch = YES;
    }
    
    return self;
}

@end


/*
 TabButtonGroup
 */
#pragma mark-
#pragma mark TabButtonGroup

@implementation TabButtonGroup

@synthesize act_target = _act_target;
@synthesize act_selector = _act_selector;
@synthesize sfx_res = _sfx_res;
@synthesize tabItemsArray = _tabItemsArray;

+(id)tabButtonsWithTarget:(id)target action:(SEL)action sound:(NSString*)sfx objectsArr:(NSMutableArray*)tabItemsArr
{
    TabButtonGroup* tabGroup = [[TabButtonGroup alloc] initWithTarget:target action:action sound:sfx objects:tabItemsArr];
    return [tabGroup autorelease];
}

-(id)initWithTarget:(id)target action:(SEL)action sound:(NSString*)sfx objects:(NSMutableArray*)tabItemsArr
{
    if (self = [super init])
    {
        // add action
        self.act_target = target;
        self.act_selector = action;
        self.sfx_res = sfx;
        self.tabItemsArray = tabItemsArr;
        
        for (TabButtonItem* item in tabItemsArr)
        {
            [item addTarget:self action:@selector(customCallBack:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    return self;
}

-(void)customCallBack:(id)sender
{
    TabButtonItem* touchItem = (TabButtonItem*)sender;
    if (touchItem.selected) {
        return;
    }
    
    for (TabButtonItem* item in self.tabItemsArray)
    {
        item.selected = (item.itemIndex == touchItem.itemIndex);
        item.userInteractionEnabled = (item.itemIndex != touchItem.itemIndex);
    }
    
    if (_act_target && [_act_target respondsToSelector:_act_selector])
    {
        PlayEffect(_sfx_res);
        [_act_target performSelector:_act_selector withObject:sender];
    };
}

-(void)switchToItem:(NSInteger)itemIndex
{
    if (itemIndex < 0 || itemIndex >= self.tabItemsArray.count) {
        return;
    }
    
    for (TabButtonItem* item in self.tabItemsArray)
    {
        item.selected = (item.itemIndex == itemIndex);
        item.userInteractionEnabled = (item.itemIndex != itemIndex);
    }
    
    if (_act_target && [_act_target respondsToSelector:_act_selector])
    {
        TabButtonItem* targetItem = _tabItemsArray[itemIndex];
        [_act_target performSelector:_act_selector withObject:targetItem];
    };
}

-(void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    for (TabButtonItem* item in self.tabItemsArray)
    {
        [item removeTarget:self action:@selector(customCallBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.tabItemsArray = nil;
    self.sfx_res = nil;
    
    [super dealloc];
}

@end

@implementation ActiveButton
@synthesize aniKey = _aniKey;
@synthesize isAnimation = _isAnimation;
@synthesize delayTime = _delayTime;

+(id) ButtonWithTarget:(id)target action:(SEL)action aniKey:(NSString *)aniKey beginIdex:(int) begin imageCount:(int)count duration:(CFTimeInterval)duration
{
    return [[[self alloc] initWithTarget:target action:action aniKey:aniKey beginIdex:begin imageCount:count duration:duration] autorelease];
}

-(id) initWithTarget:(id)target action:(SEL)action aniKey:(NSString *)aniKey beginIdex:(int) begin imageCount:(int)count duration:(CFTimeInterval)duration
{
    if (self = [super init])
    {
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        NSString *str = [NSString stringWithFormat:aniKey,begin];
        UIImage *image = [UIImage imageNamed_New:str];
        [self setBackgroundImage:image forState:UIControlStateNormal];
        [self setBackgroundImage:nil forState:UIControlStateHighlighted];
        
        self.frame = SNSRect(0, 0, image.size.width*SNS_SCALE, image.size.height*SNS_SCALE);
        _beginIndex = begin;
        _imageCount = count;
        self.aniKey = aniKey;
        _animation = nil;
        _time = duration;
        _isAnimation = YES;
        
//        [self startAnimation];
    }
    return self;
}

-(void) startAnimation
{
    if (_animation == nil)
    {
        NSString *str = [NSString stringWithFormat:_aniKey,_beginIndex];
        UIImage *image = [UIImage imageNamed_New:str];
        _lightAnimBaseView = [[[ImageFrame alloc] initWithImage:image] autorelease];
        _lightAnimBaseView.frame = SNSRect(0, 0, image.size.width*SNS_SCALE, image.size.height*SNS_SCALE);
        [self addSubview:_lightAnimBaseView];
        
        ImagesAction* imageAction = [ImagesAction action:_lightAnimBaseView duration:_time formatKey:_aniKey beginIdx:_beginIndex imagesCount:_imageCount repeatCount:1 imageCache:true];
        if (_delayTime != 0.0f)
        {
            DelayAction* delayAction = [DelayAction action:_delayTime];
            _animation = [ActionItem actionItemsRepeatCount:RepeatForEver beginTime:0.f actionItems:imageAction, delayAction, nil];
        }
        else
        {
            _animation = [ActionItem actionItemsRepeatCount:RepeatForEver beginTime:0.f actionItems:imageAction, nil];
        }
        
        [_animation retain];
        [_animation startAction];
    }
}

-(void) stopAnimation
{
    if (_animation)
    {
        [_animation clearActions];
        [_animation release];
        _animation = nil;
        [_lightAnimBaseView removeFromSuperview];
    }
}

-(void) dealloc
{
    [self stopAnimation];
    self.aniKey = nil;
    [super dealloc];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self stopAnimation];
    [super touchesBegan:touches withEvent:event];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    PlayEffect(SFX_BUTTON);
    if (_isAnimation)
    {
        [self startAnimation];
    }
    [super touchesEnded:touches withEvent:event];
}

-(void) setEnabled:(BOOL)enabled
{
    if (enabled)
    {
        [self startAnimation];
    }
    else
    {
        [self stopAnimation];
    }
    [super setEnabled:enabled];
}

@end

@implementation SignButton
-(id) initWithTarget:(id)target action:(SEL)action aniKey:(NSString *)aniKey beginIdex:(int) begin imageCount:(int)count duration:(CFTimeInterval)duration
{
    if (self = [super initWithTarget:target action:action aniKey:aniKey beginIdex:begin imageCount:count duration:duration])
    {
        _sanAniKey = nil;
    }
    return self;
}

-(void) startAnimation
{
    if (_animation == nil)
    {
        NSString *str = [NSString stringWithFormat:_aniKey,0];
        UIImage *image = [UIImage imageNamed_New:str];
        _lightAnimBaseView = [[[ImageFrame alloc] initWithImage:image] autorelease];
        _lightAnimBaseView.frame = SNSRect(0, 0, image.size.width*SNS_SCALE, image.size.height*SNS_SCALE);
        [self addSubview:_lightAnimBaseView];
        
        ImagesAction* imageAction = [ImagesAction action:_lightAnimBaseView duration:_time formatKey:_aniKey beginIdx:_beginIndex imagesCount:_imageCount repeatCount:1 imageCache:true];
        _animation = [ActionItem actionItemsRepeatCount:RepeatForEver beginTime:0.f actionItems:imageAction, nil];
        [_animation retain];
        [_animation startAction];
        
        [self stopSanAnimation];
        if (_sanAniKey != nil)
        {
            [self startSanAnimationWithSanAniKey:_sanAniKey beginIdex:_sanBeginIndex imageCount:_sanImageCount duration:_sanTime];
        }
        else
        {
            [self startSanAnimation];
        }
        [self startSanAnimation];
    }
}

-(void) startAnimationWithSanAniKey:(NSString *)aniKey beginIdex:(int) index imageCount:(int) count duration:(CFTimeInterval) duration
{
    if (_animation == nil)
    {
        NSString *str = [NSString stringWithFormat:_aniKey,0];
        UIImage *image = [UIImage imageNamed_New:str];
        _lightAnimBaseView = [[[ImageFrame alloc] initWithImage:image] autorelease];
        _lightAnimBaseView.frame = SNSRect(0, 0, image.size.width*SNS_SCALE, image.size.height*SNS_SCALE);
        [self addSubview:_lightAnimBaseView];
        
        ImagesAction* imageAction = [ImagesAction action:_lightAnimBaseView duration:_time formatKey:_aniKey beginIdx:_beginIndex imagesCount:_imageCount repeatCount:1 imageCache:true];
        _animation = [ActionItem actionItemsRepeatCount:RepeatForEver beginTime:0.f actionItems:imageAction, nil];
        [_animation retain];
        [_animation startAction];
        
        [self stopSanAnimation];
        [self startSanAnimationWithSanAniKey:aniKey beginIdex:index imageCount:count duration:duration];
    }
}


-(void) startSanAnimation
{
    if (_sanAnimation == nil)
    {
        NSString *str = [NSString stringWithFormat:@"signSan_ani_%02d@2x.png",0];
        UIImage *image = [UIImage imageNamed_New:str];
        _sanImageView = [[[ImageFrame alloc] initWithImage:image] autorelease];
        _sanImageView.frame = SNSRect(0, 0, image.size.width*SNS_SCALE, image.size.height*SNS_SCALE);
        _sanImageView.center = SNSPoint(-_sanImageView.bounds.size.width/3*1 + 2*SNS_SCALE, self.bounds.size.height/2);
        [self addSubview:_sanImageView];
        
        ImagesAction* imageAction = [ImagesAction action:_sanImageView duration:_time formatKey:@"signSan_ani_%02d@2x.png" beginIdx:0 imagesCount:20 repeatCount:1 imageCache:true];
        _sanAnimation = [ActionItem actionItemsRepeatCount:RepeatForEver beginTime:0.f actionItems:imageAction, nil];
        [_sanAnimation retain];
        [_sanAnimation startAction];
    }
}

-(void) startSanAnimationWithSanAniKey:(NSString *)aniKey beginIdex:(int) index imageCount:(int) count duration:(CFTimeInterval) duration
{
    if (_sanAnimation == nil)
    {
        _sanAniKey = aniKey;
        _sanBeginIndex = index;
        _sanImageCount = count;
        _sanTime = duration;
        
        NSString *str = [NSString stringWithFormat:aniKey,0];
        UIImage *image = [UIImage imageNamed_New:str];
        _sanImageView = [[[ImageFrame alloc] initWithImage:image] autorelease];
        _sanImageView.frame = SNSRect(0, 0, image.size.width*SNS_SCALE, image.size.height*SNS_SCALE);
        _sanImageView.center = SNSPoint(-_sanImageView.bounds.size.width/3*1 + 2*SNS_SCALE, self.bounds.size.height/2);
        [self addSubview:_sanImageView];
        
        ImagesAction* imageAction = [ImagesAction action:_sanImageView duration:duration formatKey:aniKey beginIdx:index imagesCount:count repeatCount:1 imageCache:true];
        _sanAnimation = [ActionItem actionItemsRepeatCount:RepeatForEver beginTime:0.f actionItems:imageAction, nil];
        [_sanAnimation retain];
        [_sanAnimation startAction];
    }
}

-(void) stopSanAnimation
{
    if (_sanAnimation != nil)
    {
        [_sanAnimation clearActions];
        [_sanAnimation release];
        _sanAnimation = nil;
        [_sanImageView removeFromSuperview];
    }
}

-(void) stopAnimation
{
    [self stopSanAnimation];
    [super stopAnimation];
}

-(void) dealloc
{
    [self stopSanAnimation];
    [super dealloc];
}

@end