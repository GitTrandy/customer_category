//
//  LoadingView.h
//  beatmasterSNS
//
//  Created by  on 12-10-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView{
    
    UIActivityIndicatorView *_loadingActivityIndicator;
    
    UILabel *_currentProcessStatus;
}

@property (nonatomic, retain) IBOutlet UILabel *currentProcessStatus;

- (void)loadingShow;
- (void)loadingHide;

- (void)changeProcessStatus:(NSString *)newStatus;

@end
