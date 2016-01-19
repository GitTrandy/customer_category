//
//  PopTipsView.m
//  beatmasterSNS
//
//  Created by 彭慧明 on 13-9-2.
//
//

#import "PopTipsView.h"
#import "TouchTipsView.h"

@implementation PopTipsView

- (id)initWithFrame:(CGRect)frame withTarget:(TouchTipsView *)target
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _target = target;
    }
    return self;
}

-(void) dealloc
{
    [super dealloc];
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    
    if (self.superview && _target)
    {
        [_target dismissPopTipsView];
    }
    
    return FALSE;
}

@end
