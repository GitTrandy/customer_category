//
//  ComTableView.h
//  BaseTableView
//
//  Created by 彭慧明 on 13-10-14.
//  Copyright (c) 2013年 彭慧明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComFreshTableView.h"

typedef enum
{
    _refreshDefalut = 0,    //无刷新模式
    _refreshHeader,         //只有下拉刷新
    _refreshFooter,         //只有上拉刷新
    _refreshAll,            //上下拉刷新都有
    
}RefreshStyle;              //刷新方式

typedef enum
{
    UnderBound,         //在tableview下面
    UnderContensize,    //在tableview的contensize下面
    
}RefrehFooterStyle;     //上拉刷新时刷新提示所处的位置

/******************************************************
 *                                                    *
 *  使用此tableview或者子类SNSTableView请遵守此协议       *
 *                                                    *
 ******************************************************/
@protocol ComTableViewDelegate <NSObject,UITableViewDelegate>
@optional
-(void) tableViewFreshingData:(UITableView *)table;
@end


/******************************************************
 *                                                    *
 *      tableview常规类,此工程请使用SNSTableView         *
 *                                                    *
 ******************************************************/
@interface ComTableView : UITableView<COM_RefreshTableViewDelegate>
{

}

@property (nonatomic, assign) CGFloat lineMargin;   //滚动条的偏移量
@property (nonatomic, readonly) UIImageView *lineView;  //滚动条
@property (nonatomic, assign) RefreshStyle freshStyle;  //刷新方式
@property (nonatomic, assign) id<ComTableViewDelegate> delegate;
@property (nonatomic, assign) RefrehFooterStyle footerStyle;    //上拉刷新刷新条的位置

-(id) initWithFrame:(CGRect)frame style:(UITableViewStyle)style andFreshStyle:(RefreshStyle) freshStyle;

//刷新完成数据之后页面级的回调方法(需要页面刷新完数据之后主调此方法)
-(void) freshDataOverCallBack;

#define COM_SCELE_H          ([[UIScreen mainScreen] bounds].size.width)/320.0f    // 对象高度系数
#define COM_HideTime  0.2f
// // 最小的line长度
#define COM_MinLineHeight (30.0f*COM_SCELE_H)
#define COM_SCALE               (((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)) ? 1.0f : (1024.0f/480.0f))

@end