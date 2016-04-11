//
//  ChatPhotoBrowse.h
//  circle_iphone
//
//  Created by trandy on 15/11/12.
//  Copyright © 2015年 ctquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatPhotoBrowse : UIView

- (instancetype)initWithEID:(NSString *)eID;
- (void)startAnimation;
- (void)setMsgIDArray:(NSArray<NSString *> *)msgIDArray withCurrentMsgID:(NSString *)currentID;

@end
