//
//  LoadingView.m
//  beatmasterSNS
//
//  Created by  on 12-10-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView (private)
- (void)createData;
@end

@implementation LoadingView

@synthesize currentProcessStatus=_currentProcessStatus;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createData];
    }
    return self;
}

- (void)createData{
    CGSize viewSize = self.frame.size;
    
    _loadingActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _loadingActivityIndicator.frame = SNSRect(viewSize.width/2-18, viewSize.height/2-18, 37, 37);
    [self addSubview:_loadingActivityIndicator];
    
    _currentProcessStatus = [[UILabel alloc] initWithFrame:SNSRect(viewSize.width/2-100, viewSize.height/2-18+37+10, 200, 37)];
    _currentProcessStatus.backgroundColor = [UIColor clearColor];
    _currentProcessStatus.textColor = [UIColor whiteColor];
    _currentProcessStatus.font = [UIFont boldSystemFontOfSize:14];
    _currentProcessStatus.textAlignment = UITextAlignmentCenter;
    _currentProcessStatus.text = MultiLanguage(lvLLoadData);
    [self addSubview:_currentProcessStatus];
    
    //先隐藏，等loadingShow在显示
    [self setHidden:YES];
    
}

- (void)dealloc{
    [_loadingActivityIndicator release];
    [_currentProcessStatus release];
    
    [super dealloc];
}

- (void)loadingShow{
    
    [_loadingActivityIndicator startAnimating];
    [_currentProcessStatus setHidden:NO];
    [self setHidden:NO];
}

- (void)loadingHide{
    [_loadingActivityIndicator stopAnimating];
    [_currentProcessStatus setHidden:YES];
    [self setHidden:YES];
}

- (void)changeProcessStatus:(NSString *)newStatus
{
    _currentProcessStatus.text = newStatus;
}

@end
