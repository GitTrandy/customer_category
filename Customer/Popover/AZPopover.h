//
//  AZPopover.h
//  zhibuniao
//
//  Created by AndrewZhang on 15/9/26.
//  Copyright (c) 2015年 AndrewZhang. All rights reserved.
//

#import "DXPopover.h"

/** 继承DXPopover pop 编辑分租 删除分组  */
@interface AZPopover : DXPopover

/** 是否展示 */
@property (nonatomic,assign,readonly)BOOL isShow;

/** 单例 */
+(instancetype)sharePopOver;


@end
