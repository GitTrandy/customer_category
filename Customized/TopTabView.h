//
//  TopTabView.h
//  beatmasterSNS
//
//  Created by 刘旺 on 13-8-23.
//
//

#import <UIKit/UIKit.h>

@protocol TopTabDelegate <NSObject>

-(void)clickedAtIndex:(int)index;

-(void)noNetWorkConnect;

@end

@interface TopTabView : UIView
{
    id<TopTabDelegate>      _delegate;
    
    UIImageView             *_bgView;
    
    NSMutableArray          *_tabImageArray;
    int                     _selectIndex;
}

@property (nonatomic,assign) id<TopTabDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withImageArr:(NSMutableArray*)array showIndex:(int)index;

- (void)changeSelectIndex:(int)index;

@end
