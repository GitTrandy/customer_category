//Sunny
//8.1

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
//#import "ActionBase.h"

@interface UIButton (Extension)

+ (UIButton *)buttonCustomWithFrame:(CGRect)frame normalImage:(UIImage *)normal highlightedImage:(UIImage *)highlighted;
+ (UIButton *)buttonWithView:(UIView *)view;
+ (UIButton *)buttonWithImageOfView:(UIView *)view;
- (void)stayAtState:(UIControlState)state;

@property (nonatomic, copy) void (^callbackBlock)(id);

@end


/*
 新的初始化button的方法
 */
@interface CustomUIButton : UIButton{
    UIActivityIndicatorView* _spinner;
    BOOL _isReadyToCallback;
}

@property (nonatomic, assign) id act_target;
@property (nonatomic, assign) SEL act_selector;
@property (nonatomic, copy) NSString* sfx_res;
@property (nonatomic, assign) BOOL toggle_key;

+(id)buttonWithNormalImage:(NSString*)normalImage highlightImage:(NSString*)highlightImage target:(id)target action:(SEL)action sound:(NSString*)sfx;
+(id)buttonWithNormalImage:(UIImage*)normalImage highlightImage:(UIImage*)highlightImage target:(id)target action:(SEL)action sound:(NSString *)sfx frame:(CGRect)frame;
+(id)toggleButtonWithNormalImage:(NSString*)normalImage selectImage:(NSString*)selectImage target:(id)target action:(SEL)action sound:(NSString*)sfx;

-(id)initWithNormalImage:(UIImage*)normalImage highlightImage:(UIImage*)highlightImage target:(id)target action:(SEL)action sound:(NSString*)sfx frame:(CGRect)frame;
//
- (void)startLoadingAnimation;
- (void)stopLoadingAnimation;

@end


/*
 TabButtonItem
 */
@interface TabButtonItem : UIButton

@property (nonatomic, assign) NSInteger itemIndex;

+(id)tabButtonItemWithFrame:(CGRect)frame normalImage:(NSString*)normalImage selectImage:(NSString*)selectImage itemIndex:(NSInteger)index;

@end


/*
 TabButtonGroup
 */
@interface TabButtonGroup : NSObject

@property (nonatomic, assign) id act_target;
@property (nonatomic, assign) SEL act_selector;
@property (nonatomic, copy) NSString* sfx_res;
@property (nonatomic, retain) NSMutableArray* tabItemsArray;

+(id)tabButtonsWithTarget:(id)target action:(SEL)action sound:(NSString*)sfx objectsArr:(NSMutableArray*)tabItemsArr;
-(void)switchToItem:(NSInteger)itemIndex;

@end

@interface ActiveButton : UIButton
{
    ActionItem *_animation;     //签到动画
    ImageFrame *_lightAnimBaseView; //动画view
    
    int _beginIndex;
    int _imageCount;
    CFTimeInterval _time;
    NSString *_aniKey;
}

@property (nonatomic, copy) NSString *aniKey;
@property (nonatomic, assign) BOOL isAnimation;
@property (nonatomic,assign) float delayTime;

+(id)ButtonWithTarget:(id)target action:(SEL)action aniKey:(NSString *)aniKey beginIdex:(int) begin imageCount:(int)count duration:(CFTimeInterval) duration;

-(void) startAnimation;
-(void) stopAnimation;

@end

@interface SignButton : ActiveButton
{
    ActionItem *_sanAnimation;
    ImageFrame *_sanImageView;
    NSString *_sanAniKey;
    int _sanBeginIndex;
    int _sanImageCount;
    CFTimeInterval _sanTime;
}

-(void) startSanAnimation;
-(void) stopSanAnimation;

//把三角形资源传进来开始的动画方法
-(void) startAnimationWithSanAniKey:(NSString *)aniKey beginIdex:(int) index imageCount:(int) count duration:(CFTimeInterval) duration;

@end
