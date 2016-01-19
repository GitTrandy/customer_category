//
//  SNSSettingPopMenuController.m
//  beatmasterSNS
//
//  Created by Sunny on 13-12-26.
//
//

#import "SNSSettingPopMenuController.h"
#import "SNSPopMenu.h"
#import "UserSettingVC.h"
#import "DataManager.h"
@interface SNSSettingPopMenuController ()

@end

@implementation SNSSettingPopMenuController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect popMenuFrame = CGRectMake(0, 0, 122.0f * SNS_SCALE, 122.0f * SNS_SCALE);
//    if (IS_IPHONEUI)
//    {
//        popMenuFrame = CGRectMake(0, SCREEN_HEIGHT - 122.0f, 122.0f, 122.0f);
//    }
//    else if (IS_IPADUI)
//    {
//        popMenuFrame = CGRectMake(0, SCREEN_HEIGHT - 407.0f, 407.0f, 407.0f);
//    }
    SNSPopMenu *popMenu = [[SNSPopMenu alloc] initWithFrame:popMenuFrame];
    
    DataManager *dataManager = [DataManager shareDataManager];
    
    // 背景音乐开关
    SNSPopMenuItem *musicItem = [[SNSPopMenuItem alloc] initWithEnableImage:[UIImage imageNamed:@"SNSPopMenuItemMusicEnable"]
                                                               disableImage:[UIImage imageNamed:@"SNSPopMenuItemMusicDisable"]];
    musicItem.enable = [dataManager getUserConfigurationOfType:UserSettingTypeMusicSound];
    [musicItem setSelectHandler:^(BOOL enable) {
        PlayEffect(SFX_BUTTON);
        [dataManager setUserConfigurationOfType:UserSettingTypeMusicSound forStatus:(enum_UserSettingStatusType)enable];
        SetUIMusicEnable(enable);
        
        if (enable)
        {
            PlayUIMusic();
        }
        else
        {
            StopUIMusic();
        }
    }];
    
    [popMenu addItem:musicItem];
    

    // 音效开关
    SNSPopMenuItem *soundItem = [[SNSPopMenuItem alloc] initWithEnableImage:[UIImage imageNamed:@"SNSPopMenuItemSoundEnable"]
                                                               disableImage:[UIImage imageNamed:@"SNSPopMenuItemSoundDisable"]];
    soundItem.enable = [dataManager getUserConfigurationOfType:UserSettingTypeMusicEffect];
    [soundItem setSelectHandler:^(BOOL enable) {
        [dataManager setUserConfigurationOfType:UserSettingTypeMusicEffect forStatus:(enum_UserSettingStatusType)enable];
        if (enable)
        {
            PlayEffect(SFX_BUTTON);
        }
    }];
    
    [popMenu addItem:soundItem];
    
    // 设置按钮
    SNSPopMenuItem *settingItem = [[SNSPopMenuItem alloc] initWithEnableImage:[UIImage imageNamed:@"SNSPopMenuItemSetting"]
                                                                 disableImage:nil];
    [settingItem setSelectHandler:^(BOOL enable) {
        PlayEffect(SFX_BUTTON);
        
        UserSettingVC *settingVC = [[UserSettingVC alloc] init];
        settingVC.view.frame = SCREEN_FRAME;
        [self.navigationController pushViewControllerAnimatedWithFIFO:settingVC];
    }];
    
    [popMenu addItem:settingItem];
    
    [self.view addSubview:popMenu];
}

@end
