//
//  SNSColorPopView.m
//  beatmasterSNS
//
//  Created by chengsong on 13-11-26.
//
//

#import "SNSColorPopView.h"

@interface SNSColorPopView ()
// // 关闭按钮
@property(nonatomic,strong)CustomUIButton *closeBtn;
@property(nonatomic,assign)SNSColorPopViewStyle style;
@end

@implementation SNSColorPopView

-(id)initWithStyle:(SNSColorPopViewStyle)style
{
    self = [super initWithFrame:SCREEN_FRAME];
    if (self) {
        // // init codes
        self.style = style;
        self.backgroundColor = SNS_BLACKCOLOR_BG;
        
        [self createColorPopView];
    }
    
    return self;
}

-(void)createColorPopView
{
    // // 背景
    self.bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed_New:@"petTrainBG@2x.png"]];
    self.bgImgView.frame = SNSRect(0.f, 0.f, 372*SNS_SCALE, 252*SNS_SCALE);
    self.bgImgView.center = SNSPoint(self.frame.size.width/2.f, self.frame.size.height/2.f);
    self.bgImgView.userInteractionEnabled = YES;
    [self addSubview:self.bgImgView];
    
    // // 关闭按钮
    self.closeBtn = [CustomUIButton buttonWithNormalImage:@"petTrainCloseBtn00@2x.png"
                           highlightImage:@"petTrainCloseBtn01@2x.png"
                                   target:self
                                   action:@selector(colorCloseBtnClicked:)
                                    sound:SFX_BUTTON];
    _closeBtn.frame = SNSRect(self.bgImgView.frame.size.width-41.f*SNS_SCALE, 0.f*SNS_SCALE, 40.f*SNS_SCALE, 40.f*SNS_SCALE);
    [self.bgImgView addSubview:_closeBtn];
}

-(void)colorCloseBtnClicked:(id)sender
{
    [self removeFromSuperview];
}

#pragma mark - public methods
-(void)startAnimation
{
    PlayEffect(SFX_COLORGRID);
    self.bgImgView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView beginAnimations:@"ColorPopViewScale" context:nil];
    [UIView setAnimationDuration:0.2];
    self.bgImgView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [UIView commitAnimations];
    
}



@end
