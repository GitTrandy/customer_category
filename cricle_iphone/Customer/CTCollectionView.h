//
//  CTCollectionView.h
//  circle_iphone
//
//  Created by trandy on 15/11/26.
//  Copyright © 2015年 ctquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTCollectionView : UIView

/**
 *  最大多选数量
 */
@property (nonatomic, assign)   NSInteger           maxSelectCount;

/**
 *  超出多选时提示文字
 */
@property (nonatomic, copy)     NSString            *noticeWord;

/**
 *  init
 *
 *  @param frame       collectionView frame
 *  @param allArray    可以选择的内容
 *  @param selectArray 默认选中的内容
 *  @param title       标题
 *
 *  @return instance
 */
- (instancetype)initWithFrame:(CGRect)frame allArray:(NSArray *)allArray selectArray:(NSArray *)selectArray title:(NSString *)title;

/**
 *  选中某个Item
 *
 *  @param block block回调
 */
- (void)didSelectItem:(void (^)(NSArray *selectArray,NSString *itemName))block;

/**
 *  关闭CollectionView
 *
 *  @param block block回调
 */
- (void)didCloseCollection:(void (^)(NSArray *selectArray,BOOL save))block;

@end
