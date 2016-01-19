//
//  SNSPopMenuItem.m
//  beatmasterSNS
//
//  Created by Sunny on 13-12-26.
//
//

#import "SNSPopMenuItem.h"

@interface SNSPopMenuItem ()
@property (nonatomic, strong) UIImage *enableImage;
@property (nonatomic, strong) UIImage *disableImage;

@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation SNSPopMenuItem

- (instancetype)initWithEnableImage:(UIImage *)enableImage disableImage:(UIImage *)disableImage
{
    self = [super init];
    if (self)
    {
        // 若disableImage没有则使用enableImage
        self.enableImage = enableImage;
        self.disableImage = disableImage ?: enableImage;
        
        self.frame = (CGRect){.size.width = enableImage.size.width * SNS_SCALE, .size.height = enableImage.size.height * SNS_SCALE};
        
        self.imageView = [[UIImageView alloc] initWithImage:enableImage];
        self.imageView.frame = self.bounds;
        self.imageView.userInteractionEnabled = YES;
        [self addSubview:self.imageView];
        
        // touch event
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTouched:)];
        [self.imageView addGestureRecognizer:recognizer];
        
        self.enable = NO;
    }
    return self;
}

- (void)setEnable:(BOOL)enable
{
    _enable = enable;
    self.imageView.image = enable ? self.enableImage : self.disableImage;
}

- (void)itemTouched:(UITapGestureRecognizer *)recognizer
{
    self.enable = !self.enable;
    
    if (self.selectHandler)
    {
        self.selectHandler(self.enable);
    }
}

@end
