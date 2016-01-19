//
//  PopTipsView.h
//  beatmasterSNS
//
//  Created by 彭慧明 on 13-9-2.
//
//

#import <UIKit/UIKit.h>

@class TouchTipsView;

@interface PopTipsView : UIView
{
    TouchTipsView *_target;
}

- (id)initWithFrame:(CGRect)frame withTarget:(TouchTipsView *)target;

@end
