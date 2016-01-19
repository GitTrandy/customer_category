//
//  CTMutablePickerView.m
//  circle_iphone
//
//  Created by sujie on 15/7/3.
//  Copyright (c) 2015年 ctquan. All rights reserved.
//

#import "CTMutablePickerView.h"

@interface CTMutablePickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIPickerView *picker;       //pickerView
    NSMutableArray *backData;   //返回数据
    UIImage *saveImage;         //保存按钮图片
    UIImage *cancelImage;
    UIButton *saveBtn;          //保存按钮
    UIButton *cancelBtn;
    UILabel  *titleLabel;
    
    UIView *grayBg;
    
    UIView *pickerBg;
    
    UIView *buttonView;
    
}

@end

@implementation CTMutablePickerView

- (instancetype)init
{
    self = [super initWithFrame:DEVICE_RECT];
    if (self) {
        _rowHeight = 40;
        _pickerRect = CTRect(0, DEVICE_HEIGHT - 200, DEVICE_WIDTH, 200);
    }
    return self;
}

- (void)loadMainView
{
    [self show];
}

- (void)show
{
    backData = [[NSMutableArray alloc] initWithCapacity:0];
    if (self.defaultDataArray != nil && [self.defaultDataArray count] > 0) {
        for (int i = 0; i < _dataSource.count; i++) {
            [backData setObject:_defaultDataArray[i] atIndexedSubscript:i];
        }
    }else
    {
        //默认取每组第一个为默认数据
        for (int i = 0; i < _dataSource.count; i++) {
            [backData setObject:_dataSource[i][0] atIndexedSubscript:i];
        }
    }
    
    
    grayBg = [[UIView alloc] initWithFrame:DEVICE_RECT];
    grayBg.backgroundColor = CTColorMake(0, 0, 0, 0.6);
    [self addSubview:grayBg];
    
    pickerBg = [[UIView alloc] init];
    pickerBg.frame = CTRect(_pickerRect.origin.x,
                            DEVICE_HEIGHT,
                            _pickerRect.size.width,
                            DEVICE_HEIGHT - _pickerRect.origin.y);
    pickerBg.backgroundColor = [UIColor whiteColor];
    [self addSubview:pickerBg];
    
    //button view
    buttonView = [[UIView alloc] init];
    buttonView.frame = CTRect(0, 0, DEVICE_WIDTH, 44);
    buttonView.backgroundColor = CTColorMake(233, 233, 233, 1);
    [pickerBg addSubview:buttonView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CTRect(50*CT_SCALE, 0, 220*CT_SCALE, 50)];
    titleLabel.text = self.pickerTitle;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = CTColorMake(96, 96, 96, 1);
    titleLabel.font = [UIFont systemFontOfSize:16];
    [buttonView addSubview:titleLabel];
    
    saveImage = [UIImage imageNamed:@"SH_select_btn.png"];
    saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CTRect(DEVICE_WIDTH - saveImage.size.width,
                           0,
                           saveImage.size.width,
                           saveImage.size.height);
    [saveBtn setBackgroundImage:saveImage
                          forState:UIControlStateNormal];
    [saveBtn addTarget:self
                   action:@selector(saveClick:)
         forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:saveBtn];
    
    
    cancelImage = [UIImage imageNamed:@"SH_cancel_btn.png"];
    cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CTRect(0,
                             0,
                             cancelImage.size.width,
                             cancelImage.size.height);
    [cancelBtn setBackgroundImage:cancelImage
                       forState:UIControlStateNormal];
    [cancelBtn addTarget:self
                action:@selector(disAppearView)
      forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:cancelBtn];
    
    //content
    picker = [[UIPickerView alloc] init];
    picker.frame = CTRect(0, 44, _pickerRect.size.width, _pickerRect.size.height - 44);
    picker.delegate = self;
    picker.dataSource = self;
    [pickerBg addSubview:picker];
    
    //defaultDataArray
    if (self.defaultDataArray != nil && [self.defaultDataArray count] > 0) {
        for (int i = 0; i < [_dataSource count] ; i++) {
            for (int j = 0; j < [_dataSource[i] count]; j++) {
                if ([self.defaultDataArray[i] isEqualToString:_dataSource[i][j]]) {
                    [picker selectRow:j inComponent:i animated:YES];
                }
            }
        }
    }
    
    [self loadPickerAndSaveButton];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)loadPickerAndSaveButton
{
    [UIView animateWithDuration:0.25f
                     animations:^{
                         pickerBg.frame = CTRect(_pickerRect.origin.x,
                                                 _pickerRect.origin.y,
                                                 _pickerRect.size.width,
                                                 DEVICE_HEIGHT - _pickerRect.origin.y);
                     }];
}

#pragma mark - 保存回调
- (void)saveClick:(id)sender
{
    [UIView animateWithDuration:0.25f
                     animations:^{
                         pickerBg.frame = CTRect(_pickerRect.origin.x,
                                                 DEVICE_HEIGHT,
                                                 _pickerRect.size.width,
                                                 DEVICE_HEIGHT - _pickerRect.origin.y);
                     }
                     completion:^(BOOL b){
                         [_delegate saveSelectCallBack:self data:[backData copy]];
                         [self removeFromSuperview];
                     }];
}

#pragma mark - UIPickerViewDelegate and UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return _dataSource.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_dataSource[component] count];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, picker.frame.size.width, _rowHeight);
    label.text = self.dataSource[component][row];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return _rowHeight;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [backData setObject:self.dataSource[component][row] atIndexedSubscript:component];
}

#pragma mark - touchesBegan
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.view == grayBg) {
        [self disAppearView];
    }
}

- (void)disAppearView
{
    [UIView animateWithDuration:0.25f
                     animations:^{
                         pickerBg.frame = CTRect(_pickerRect.origin.x,
                                                 DEVICE_HEIGHT,
                                                 _pickerRect.size.width,
                                                 DEVICE_HEIGHT - _pickerRect.origin.y);
                     }
                     completion:^(BOOL b){
                         [self removeFromSuperview];
                     }];
}

@end
