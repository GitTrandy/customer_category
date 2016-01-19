//
//  UpgradeInfoView.h
//  beatmasterSNS
//
//  Created by 刘旺 on 13-8-13.
//
//

#import <UIKit/UIKit.h>

#import "UpgradeInfo.h"

#define TAG_ITEM_1  10
#define TAG_ITEM_2  20
#define TAG_ITEM_3  30
#define TAG_ITEM_4  40

#define TAG_TEXT_1  11
#define TAG_TEXT_2  21
#define TAG_TEXT_3  31
#define TAG_TEXT_4  41

@protocol UpgradeViewCloseDelegate <NSObject>

-(void)closeClicked;

@end

//升级奖励动画
@interface UpgradeInfoView : UIView
{
    //升级后的等级
    int                         _level;
    //黑色背景
    UIView                      *_bgView;
    //中间内容框
    UIImageView                 *_contentView;
    //关闭按钮
    UIButton                    *_closeBtn;
    //文字view
    UIView                      *_titleView;
    //星星动画
    UIImageView                 *_starView;
    //升级奖励信息
    UpgradeInfo                 *_upgradeInfo;
    
    //UI
    NSMutableArray              *_itemArray;
    NSMutableArray              *_imageArray;
    NSMutableArray              *_textArray;
    
    id<UpgradeViewCloseDelegate> _delegate;
    
}

@property (nonatomic,assign) id<UpgradeViewCloseDelegate> delegate;

// init
- (id)initWithFrame:(CGRect)frame RankupLevel:(int)level withUInfo:(UpgradeInfo*)uInfo;

// 开始动画
- (void)beginAnimation;

@end
