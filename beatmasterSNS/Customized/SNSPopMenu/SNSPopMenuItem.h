//
//  SNSPopMenuItem.h
//  beatmasterSNS
//
//  Created by Sunny on 13-12-26.
//
//

@interface SNSPopMenuItem : UIView

- (instancetype)initWithEnableImage:(UIImage *)enableImage disableImage:(UIImage *)disableImage;

@property (nonatomic, copy) void(^selectHandler)(BOOL enable);
@property (nonatomic) BOOL enable;


@end
