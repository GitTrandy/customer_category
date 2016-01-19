//
//  TopTabView.m
//  beatmasterSNS
//
//  Created by 刘旺 on 13-8-23.
//
//

#import "TopTabView.h"

@implementation TopTabView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame withImageArr:(NSMutableArray*)array showIndex:(int)index
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _tabImageArray = [array copy];
        _bgView = [[UIImageView alloc] initWithFrame:SNSRect(0, 0, frame.size.width, frame.size.height)];
        _bgView.image = _tabImageArray[index];
        _selectIndex = index;
        [self addSubview:_bgView];
        [_bgView release];
        
        float itemWidth = frame.size.width/[_tabImageArray count];
        for (int i = 0; i<[_tabImageArray count]; i++)
        {
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = SNSRect(i*itemWidth, 0, itemWidth, frame.size.height);
            btn.tag = i;
            [btn addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    return self;
}

-(void)itemClicked:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    SNSLog(@"item click at index: %d",btn.tag);
    if (_selectIndex == btn.tag) {
        SNSLog(@"item click at the same : %d",btn.tag);
    }else
    {
        PlayEffect(SFX_BUTTON);
        
        if (![DataManager shareDataManager].localNetworkManager.bHostReachable) {
            [_delegate noNetWorkConnect];
            return;
        }
        _selectIndex = btn.tag;
        _bgView.image = _tabImageArray[_selectIndex];
        [_delegate clickedAtIndex:btn.tag];
    }
}

-(void)changeSelectIndex:(int)index
{
    _selectIndex = index;
    _bgView.image = _tabImageArray[_selectIndex];
}

- (void)dealloc
{
    self.delegate = nil;
    [_tabImageArray release];
    
    SNSLogFunction;
    [super dealloc];
}

@end
