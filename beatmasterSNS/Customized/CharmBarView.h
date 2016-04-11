//
//  CharmBarView.h
//  beatmasterSNS
//
//  Created by 刘旺 on 12-12-20.
//
//

#import <UIKit/UIKit.h>
#import "PopMessageView.h"


//魅力框类型
typedef enum _CharmViewType_
{
    CharmView_ProFileType,
    CharmView_ShopMailType,
    CharmView_PetType
}CharmViewType;


@interface CharmStruct : NSObject
{
    int     _charmLV;
    float   _charmPercent;
}

@property (nonatomic,assign) int charmLV;
@property (nonatomic,assign) float charmPercent;

@end

@interface CharmBarView : UIView<PopMessageViewDelegate>
{
    UIImageView*            _bgView;
    UILabel*                _lvLabel;
    UILabel*                _charmValueLabel;
    UIImageView*            _exBgView;
    UIImageView*            _exView;
    UILabel*                _popularLabel;
    UIImageView*            _directionView;
    UIColor*                _wordColor;
    UIColor*                _popularColor;
    int                     _originCharmValue;
    int                     _showCharmValue;
    CharmViewType           _type;
    PopMessageView*         _popMsgView;
}

@property (nonatomic, readonly)UILabel *charmValueLabel;

////创建魅力值框
//+ (UIView* ) createCharmView:(UIView*)view withCharmLevel:(int)charmLV withCharmValue:(int)charmValue withCharmPercent:(int)charmPercent withPopularityPercent:(int)pPercent withIsUp:(BOOL)isUp withCharmViewType:(CharmViewType) type;

//- (id)initWithFrame:(CGRect)frame  withCharmViewType:(CharmViewType)type withCharmLevel:(int)charmLV withCharmValue:(int)charmValue withPopularityPercent:(int)pPercent;

-(id)initWithFrame:(CGRect)frame withCharmViewType:(CharmViewType)type withCharmValue:(int)charmValue;

-(void)replaceCharmValue:(int)newCharmValue;

@end
