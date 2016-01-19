//
//  CTLog.h
//  circle_iphone
//
//  Created by Andrew on 15/11/30.
//  Copyright © 2015年 ctquan. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  调试辅助类
 */
@interface CTLog : NSObject
@property (nonatomic,strong)NSMutableArray *owners;


#pragma mark - 对外接口

+(instancetype)defaultCTLog;

/** 只显示该开发者的调试日志 */
-(void)setLogOwner:(LogOwner)owner;

@end
