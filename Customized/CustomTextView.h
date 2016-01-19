//
//  CustomTextView.h
//  beatmasterSNS
//
//  Created by wanglei on 13-8-12.
//
//

#import <UIKit/UIKit.h>
#import "GameBGView.h"

@protocol CustomTextViewEventDelegate <NSObject>
-(void)onClickReturnKey;
-(void)onTextDidChange;
-(void)onClickClear;
@end

@interface CustomTextView : UIView <UITextViewDelegate>
{
    id<CustomTextViewEventDelegate> _eventDelegate;
    UITextView* _textView;
    UILabel*    _textNum;      //当前字数
    
    int         _maxCount;     //最大字数
}

-(id)initWithFrame:(CGRect)frame maxCnt:(int)maxCnt bgType:(EGameBGType)bgType;
-(void)updateTextNum;

@property (retain, nonatomic) UITextView* textView;
@property (assign, nonatomic) id<CustomTextViewEventDelegate> eventDelegate;

@end
