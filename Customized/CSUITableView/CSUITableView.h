//
//  CSUITableView.h
//  beatmasterSNS
//
//  Created by chengsong on 12-10-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/*
 *  @brief: 横向UITableView
 */
#import <UIKit/UIKit.h>

@protocol CSUITableViewDelegate;
@protocol CSUITableViewDataSourceDelegate;
@interface CSUITableView : UIScrollView
{
    // // 显示的cell池
    NSMutableDictionary     *_showCellPool;
    // // 不显示的，备用的cell池   并不是所有不显示的cell
    NSMutableDictionary     *_hideCellPool;
    
    // // 第一个/最后一个 显示cell的index
    int     _indexFirst;
    int     _indexLast;
    
    // // cell总数
    int     _cellCount;
    
    // // 所有cell在scrollview中的位置
    NSMutableArray          *_cellPositionXArray;
    
    // // delegate
    id<CSUITableViewDelegate>   _csDelegate;
    id<CSUITableViewDataSourceDelegate> _csDataSourceDelegate;
    
}

@property(nonatomic,assign)id<CSUITableViewDelegate> csDelegate;
@property(nonatomic,assign)id<CSUITableViewDataSourceDelegate>  csDataSourceDelegate;

// // cell重用
-(UITableViewCell *)cellCanBeReusedWithCellType:(NSString *)cellType;
// // 刷新数据
-(void)reloadData;
@end

@protocol CSUITableViewDataSourceDelegate <NSObject>
// // cell数
-(NSInteger)numberOfCellsInCSUITableView:(CSUITableView *)tableView;
// // 每个cell占用的宽度
-(CGFloat)csUITableView:(CSUITableView *)tableView widthOfCellAtIndex:(int)index;
// // 每个cell
-(UITableViewCell *)csUITableView:(CSUITableView *)tableView cellAtIndex:(int)index;

@end

@protocol CSUITableViewDelegate <NSObject>
// // 选择某个cell的点击事件
-(void)csUITableView:(CSUITableView *)tableView didSelectCellAtIndex:(int)index;

@end
