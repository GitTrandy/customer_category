//
//  CSUITableView.m
//  beatmasterSNS
//
//  Created by chengsong on 12-10-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CSUITableView.h"

@interface CSUITableView()
// // cell 宽度
-(CGFloat)getWidthOfCellWithIndex:(int)index;
// // index对应的cell
-(UITableViewCell *)getCellWithIndex:(int)index;
// // tableview总宽度
-(CGFloat)getContentWidth;
// // 设置所有cell的位置
-(void)refreshAllCellsPos;
// // 第一个 最后一个 显示的cell index
-(void)findFirstAndLastShowCellIndex;
// // 刷新TableView上显示的cells
-(void)refreshCellsInTableView;
@end

@implementation CSUITableView
@synthesize csDelegate = _csDelegate;
@synthesize csDataSourceDelegate = _csDataSourceDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _showCellPool = [[NSMutableDictionary alloc]init];
        _hideCellPool = [[NSMutableDictionary alloc]init];
        
        _indexFirst = 0;
        _indexLast = 0;
        _cellCount = 0;
        
        _cellPositionXArray = [[NSMutableArray alloc]init];
        _csDelegate = nil;
        _csDataSourceDelegate = nil;
    }
    return self;
}

#pragma mark - life circle methods
/*
 *  @brief: 系统函数，刷新布局用
 */
-(void)layoutSubviews
{
    if (_csDataSourceDelegate == nil)
    {
        SNSLog(@"error:csDataSourceDelegate == nil");
        return;
    }
    
    // // cells count
    if ([_csDataSourceDelegate respondsToSelector:@selector(numberOfCellsInCSUITableView:)])
    {
        _cellCount = [_csDataSourceDelegate numberOfCellsInCSUITableView:self];
    }
    // // set contentSize
    CGFloat contentWidth = MAX([self getContentWidth], self.bounds.size.width+1);// // +1 保证可以滑动
    self.contentSize = CGSizeMake(contentWidth, self.bounds.size.height);
//    if (_cellCount == 0)
//    {
//        return;
//    }
    // // refresh all cells position
    [self refreshAllCellsPos];
    
    // // find the cells should be showed
    [self findFirstAndLastShowCellIndex];
    
    // // refresh the cells in the table view
    [self refreshCellsInTableView];
    
    
}

/*
 *  @brief: scroll touch事件处理
 */
-(BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    if ([view isKindOfClass:[UIButton class]])
    {
        return YES;
    }
    //[super touchesShouldBegin:touches withEvent:event inContentView:view];
    if (event.type == UIEventTypeTouches)
    {
        if (_csDelegate != nil && [_csDelegate respondsToSelector:@selector(csUITableView:didSelectCellAtIndex:)])
        {
            int index = -1;
            UITouch *touch = [touches anyObject];
            CGPoint point = [touch locationInView:self];
            for (int i=0; i<[_cellPositionXArray count]; i++)
            {
                if ([_cellPositionXArray[i]floatValue]<=point.x)
                {
                    // // 最后一个比touch点小或等于的cell
                    index = i;
                }
                else
                {
                    break;
                }
            }
            if (index >= 0)
            {
                [_csDelegate csUITableView:self didSelectCellAtIndex:index];
            }
            
        }
    }
    //return YES;
    return [super touchesShouldBegin:touches withEvent:event inContentView:self];
}

//-(BOOL)touchesShouldCancelInContentView:(UIView *)view
//{
//    if ([view isKindOfClass:[UIButton class]])
//    {
//        return NO;
//    }
//    else {
//        return YES;
//    }
//}

-(void)dealloc
{
    [_showCellPool release];
    [_hideCellPool release];
    [_cellPositionXArray release];
    [super dealloc];
    SNSLog(@"%s",__FUNCTION__);
}

#pragma mark - public methods
/*
 *  @brief: 对使用过但没有显示的cell内存重用
 *  @param:
 *      cellType: 当前需要的cell类型，一般是一种，但是多种cell的时候需要区别
 */
-(UITableViewCell *)cellCanBeReusedWithCellType:(NSString *)cellType
{
    NSMutableSet *reuseCellsSet = (NSMutableSet *)_hideCellPool[cellType];
    if (reuseCellsSet == nil)
    {
        return nil;
    }
    UITableViewCell *reuseCell = [reuseCellsSet anyObject];
    if (reuseCell != nil)
    {
        [[reuseCell retain]autorelease];
        [reuseCellsSet removeObject:reuseCell];
        return reuseCell;
    }
    return nil;
}
/*
 *  @brief: TableView数据发生变化的时候
 */
-(void)reloadData
{
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - private methods
/*
 *  @brief: 获取每个cell占的宽度
 */
-(CGFloat)getWidthOfCellWithIndex:(int)index
{
    CGFloat ret_float = 0.0f;
    if ([_csDataSourceDelegate respondsToSelector:@selector(csUITableView:widthOfCellAtIndex:)])
    {
        ret_float = [_csDataSourceDelegate csUITableView:self widthOfCellAtIndex:index];
    }
    return ret_float;
}

/*
 *  @brief: 获取所有cell的总宽度
 */
-(CGFloat)getContentWidth
{
    CGFloat ret_float = 0.0f;
    for (int i=0; i<_cellCount; i++)
    {
        ret_float += [self getWidthOfCellWithIndex:i];
    }
    return ret_float;
}

/*
 *  @brief: 刷新所有cell的位置
 */
-(void)refreshAllCellsPos
{
    // // cell位置 x 值
    CGFloat pos_x = 0.0f;
    
    if ([_cellPositionXArray count] != 0)
    {
        [_cellPositionXArray removeAllObjects];
    }
    
    for (int i=0; i<_cellCount; i++)
    {
        [_cellPositionXArray addObject:@(pos_x)];
        pos_x += [self getWidthOfCellWithIndex:i];
    }
}

/*
 *  @brief: 找到显示的cell的index
 */
-(void)findFirstAndLastShowCellIndex
{
    // // 左右边缘位置
    CGFloat leftBedge = self.contentOffset.x;
    CGFloat rightBedge = self.contentOffset.x + self.bounds.size.width;
    _indexFirst = -1;
    _indexLast = -1;
    for (int i=0; i<_cellCount; i++)
    {
        if ([_cellPositionXArray[i]floatValue] <= leftBedge)
        {
            // // 最后一个小于的就是第一个
            _indexFirst = i;
        }
        if([_cellPositionXArray[i]floatValue] < rightBedge)
        {
            // // 最后一个小于的就是最后一个
            _indexLast = i;
        }
    }
    //NSLog(@"%d - %d = %d",_indexLast,_indexFirst,_indexLast-_indexFirst);
}

-(UITableViewCell *)getCellWithIndex:(int)index
{
    if ([_csDataSourceDelegate respondsToSelector:@selector(csUITableView:cellAtIndex:)])
    {
        return [_csDataSourceDelegate csUITableView:self cellAtIndex:index];
    }
    else 
    {
        return nil;
    }
}

-(void)refreshCellsInTableView
{
    //SNSLog(@"%@",[_showCellPool allKeys]);
    // // 把显示pool中不需要显示的cell转移到备用pool中
    for (NSNumber *key in [_showCellPool allKeys])
    {
        if ([key intValue]<_indexFirst || [key intValue]>_indexLast)
        {
            UITableViewCell *needHideCell = _showCellPool[key];
            [[needHideCell retain]autorelease];
            [_showCellPool removeObjectForKey:key];
            
            NSMutableSet *hideCellSet = _hideCellPool[needHideCell.reuseIdentifier];
            if (hideCellSet == nil)
            {
                hideCellSet = [[[NSMutableSet alloc]init]autorelease];
                _hideCellPool[needHideCell.reuseIdentifier] = hideCellSet;
            }
            [hideCellSet addObject:needHideCell];
            [needHideCell removeFromSuperview];
        }
    }
    
    // // 当前显示的cell已经在显示pool中的重新调整位置
    // // 当前显示的cell不在显示pool中的加入显示pool中
    for (int i=_indexFirst; i<=_indexLast; i++)
    {
        if(i<0)continue;
        if ([[_showCellPool allKeys]containsObject:@(i)])
        {
            if (i<[_cellPositionXArray count])
            {
                ((UITableViewCell *)_showCellPool[@(i)]).frame = CGRectMake([_cellPositionXArray[i]floatValue], 0, [self getWidthOfCellWithIndex:i], self.bounds.size.height);
                
            }
//        NSLog(@"change %d",i);
        }
        else
        {
            UITableViewCell *needShowCell = [self getCellWithIndex:i];
            _showCellPool[@(i)] = needShowCell;
            needShowCell.frame = CGRectMake([_cellPositionXArray[i]floatValue], 0, [self getWidthOfCellWithIndex:i], self.bounds.size.height);
            [self addSubview:needShowCell];
//            NSLog(@"show %d",i);
        }
        
    }
    //SNSLog(@"first = %d, last = %d",_indexFirst,_indexLast);
    //SNSLog(@"%d, hide = %d, show = %d",[[[_hideCellPool allValues]lastObject]count]+[_showCellPool count],[[[_hideCellPool allValues]lastObject]count],[_showCellPool count]);
    
}

@end
