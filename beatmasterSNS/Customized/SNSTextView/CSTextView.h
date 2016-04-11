//
//  CSTextView.h
//  CoreTextTest
//
//  Created by chengsong on 13-10-9.
//  Copyright (c) 2013年 chengsong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "CSTextParser.h"
#import "CSColorConvert.h"
#import "CSTextButton.h"

//*********************//
//    图文混排View      //
@protocol CSTextViewDelegate;
@interface CSTextView : UIView

// // 格式定义的完整的字符串(格式定义参看CSTextParser.h)
@property(nonatomic,strong)NSString *originalString;
// // 非特定格式的字符串的字体
@property(nonatomic,strong)UIFont *normalFont;
// // 非特定格式的字符串或下滑线的颜色
@property(nonatomic,strong)UIColor *normalColor;
// // CSTextView的文本对齐方式，默认是左对齐
@property(nonatomic,assign)CSTextAlignment textAlignment;
// // CSTextView的分行方式，默认是字分行
@property(nonatomic,assign)CSLineBreakMode textLineBreakMode;
// // 点击事件代理
@property(nonatomic,weak)id<CSTextViewDelegate>   delegate;
// // 字符串分析之后的数据集合
@property(nonatomic,strong)CSTextCompoment *csTextCompoment;

/**
 *  @brief: 取得在某个指定Size内自动适应的最小Size
 *  @param: containSize
 *          指定的Size大小，width不超过Size的width，height不超过Size的height(建议9999)
 *  @return:能包含文字的最小Size
 */
-(CGSize)doGetMinSizeInContainSize:(CGSize)containSize;
/**
 *  @brief:  取得每行的字符串和该行的所有属性集合
 *  @return: 以行为单位的数组，每一个元素都是一个CSTextCompoment，包含该行的所有属性信息。
 */
-(NSArray *)doGetLinesAttrCompomentsArr;

@end

//*************************************//
//    图文混排View中可点击的点击事件代理    //
@protocol CSTextViewDelegate <NSObject>
@optional
/*
 *  @brief: 可点击对象被点击之后的回调
 *  @param: view
 *          当前所代理的CSTextView
 *  @param: clickType
 *          点击的对象的类型，用户自己定义的，自己解析
 *  @param: info
 *          用户给每个点击对象附带的信息，用户自己用的，没有就是nil
 */
-(void)CSTextView:(CSTextView *)view clickedWithType:(NSString *)clickType withInfo:(NSString *)info;

@end
