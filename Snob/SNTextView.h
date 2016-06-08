//
//  SNTextView.h
//  SnobMass
//
//  Created by 阿迪 on 16/6/7.
//  Copyright © 2016年 卷瓜. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SNTextViewDelegate <UITextViewDelegate>


@end

@interface SNTextView : UITextView
{
    NSString *_atText;
}

@property(nonatomic,weak) id<SNTextViewDelegate> delegate;

- (void)setAtText:(NSString *)text;
- (NSString *)atText;

- (BOOL)textView:(SNTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

@end
