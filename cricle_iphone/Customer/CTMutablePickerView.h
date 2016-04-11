//
//  CTMutablePickerView.h
//  circle_iphone
//
//  Created by sujie on 15/7/3.
//  Copyright (c) 2015年 ctquan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CTMutablePickerView;

@protocol CTMutablePickerViewDelegate <NSObject>

@required

- (void)saveSelectCallBack:(CTMutablePickerView *)picker data:(NSArray *)data;

@end

@interface CTMutablePickerView : UIView

@property (nonatomic, assign) CGRect pickerRect;                    //picker rect

@property (nonatomic, assign) float rowHeight;                      //行高

@property (nonatomic, strong) NSArray *dataSource;                  //数据源 格式  @[@[],@[],@[]]
@property (nonatomic, strong) NSArray *defaultDataArray;               //初始想要显示的数据

@property (nonatomic, weak) id<CTMutablePickerViewDelegate> delegate;

@property (nonatomic, strong) NSString* pickerTitle;

- (void)loadMainView NS_DEPRECATED_IOS(2_0, 2_0, "Please use show function instead");

- (void)show;

@end
