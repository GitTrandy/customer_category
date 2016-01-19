//
//  SoundComDef.h
//  beatmasterSNS
//
//  Created by zhiying_redatoms on 12-12-4.
//
//

#ifndef beatmasterSNS_SoundComDef_h
#define beatmasterSNS_SoundComDef_h

//#import "SimpleAudioEngine.h"

#define MUSIC_BACKGROUND    @"BackgroundMusic.mp3" // 背景音乐
#define SFX_BUTTON          @"ButtonClick.mp3"     // 点击普通button时的音效
#define SFX_DING            @"Ding.mp3"            // “叮”
#define SFX_GAMEOVER        @"Gameover.mp3"        // 游戏结束时的音效
#define SFX_MAINVCICONCLICK @"PageIconClick.mp3" // 点击主页大图标
#define SFX_MAINVCICONSTOP  @"PageIconMove.mp3"  // 主页大图标滚动停止时播放
#define SFX_MOVESONG        @"MoveSong.mp3"        // 歌曲移动到
#define SFX_RETURN          @"return.mp3"          // 返回
#define SFX_POPVIEW         @"PopBox.mp3"         // 弹出框音效
#define SFX_POPTOPDOWN      @"DropDownBoxOpen.mp3"    // 下拉框-打开
#define SFX_POPTOPDOWNCLOSE @"DropDownBoxClose.mp3"
#define SFX_COUNTDOWN_01    @"Countdown_01.mp3"    // 3-2-1动画的音效
#define SFX_COUNTDOWN_02    @"Countdown_02.mp3"    // 3-2-1动画的音效
#define SFX_COUNTDOWN_03    @"Countdown_03.mp3"    // 3-2-1动画的音效
#define SFX_COUNTDOWN_GO    @"Countdown_go.mp3"    // 3-2-1动画的音效

#define SFX_CLICKMUSIC      @"clickedbtn.mp3"       //05-点击歌曲
#define SFX_CLICKPLAY       @"Play.mp3"        //06-点击PLAY
#define SFX_READSCORE       @"ReadScore.mp3"        //09-读取分数
#define SFX_VSANIMATION     @"VSAni.mp3"      //10-VS动画音效
#define SFX_CENTERVIEW      @"CenterView.mp3"       //11-中间窗口弹出
#define SFX_ALLCOMBO        @"AllCombo.mp3"         //12-allcombo
#define SFX_VICTORY_SIGNET  @"victoryStamp.mp3"
#define SFX_FAIL_SIGNET     @"FailStamp.mp3"
#define SFX_NEWMESSAGE      @"NewMsg.mp3"       //13-新消息
#define SFX_READONE         @"ReadOne.mp3"          //14-倒计时1
#define SFX_READTWO         @"ReadTwo.mp3"          //14-倒计时2
#define SFX_READTHREE       @"ReadThree.mp3"        //14-倒计时3
#define SFX_EXPROGRESS      @"LeftPartShow.mp3"       //15-左边成绩显示
#define SFX_RANKUP          @"Upgrade.mp3"           //16-升级
#define SFX_RANKUP_BATTLE   @"BattleUpgrade.mp3"         //对战升级
#define SFX_FRIEND_UPGRADE  @"FriendlyUpgrade.mp3"       //友好度亲密度+1

#define SFX_VICTORYBROVA    @"BattleWin.mp3"   // 15-胜利欢呼声
#define SFX_LOSTSOUND       @"BattleFail.mp3"    // 16-失败嘘声
#define SFX_CHANGECLOTHE    @"ChangeClothes.mp3"
#define SFX_DELETE          @"Delete.mp3"
#define SFX_WEAR            @"Wear.mp3"
#define SFX_GIFT_ERR        @"SendEggs.mp3"
#define SFX_GIFT_FLOWER     @"SendFlowers.mp3"
#define SFX_NEW_ACHIEMENT   @"GetAchievement.mp3"
#define SFX_MAINVC_SELF     @"ClickUserShow.mp3"
#define SFX_CLUB_FILTER     @"FilterLBS.mp3"

#define SFX_CLOSEWIN        @"Close.mp3"

#define SFX_ACTIVITY_DISK    @"ActivityDisk.mp3"    // 28-公告转盘
#define SFX_ACTIVITY_PET     @"ActivityPet.mp3"     // 29-公告扭蛋
#define SFX_ACTIVITY_PRIZE   @"ActivityPrize.mp3"   // 30-公告出商品

#define SFX_GAME_SKILL_CLOUD        @"GameSkillCloud.mp3"           //祥云
#define SFX_GAME_SKILL_MISS         @"GameSkillMiss.mp3"            //miss
#define SFX_GAME_SKILL_WHIRLWIND    @"GameSkillWhirlwind.mp3"       //旋风
#define SFX_GAME_SKILL_STAR         @"GameSkillStar.mp3"            //磁力星

#define SFX_COLORGRID               @"ColorGrid.mp3"                //彩色弹出框
#define SFX_PETLEVELUP              @"PetLevelup.mp3"               //宠物升级
#define SFX_COLORGRID2              @"ColorGrid2.mp3"               //新手送宠物框

/*
 ui background music
 */
//#define PreloadUIMusic(music) { [[SimpleAudioEngine sharedEngine] preloadUIBackgroundMusic:music]; }
//#define PlayUIMusic() { [[SimpleAudioEngine sharedEngine] playUIBackgroundMusic:MUSIC_BACKGROUND loop:YES]; }
//#define StopUIMusic() { [[SimpleAudioEngine sharedEngine] stopUIBackgroundMusic]; }

#define PreloadUIMusic(music) { }
#define PlayUIMusic() //{ [[DataManager shareDataManager] playUIBackgroundMusicList]; }
#define StopUIMusic() //{ [[DataManager shareDataManager] stopUIBackgroundMusicList]; }

#define PauseUIMusic() //{ [[SimpleAudioEngine sharedEngine] pauseUIBackgroundMusic]; }
#define ResumeUIMusic() //{ [[SimpleAudioEngine sharedEngine] resumeUIBackgroundMusic]; }
#define SetUIMusicEnable(isOn) //{ [[SimpleAudioEngine sharedEngine] setUIBackgroundEnabled:isOn]; }
#define IsUIMusicEnable //([[SimpleAudioEngine sharedEngine] isUIBackgroundEnabled]);

/*
 sound effect
 */
#define PreloadEffect(sfx) //{ [[SimpleAudioEngine sharedEngine] preloadEffect:sfx]; }
#define PlayMusicEffect(sfx) //{ [[SimpleAudioEngine sharedEngine] playEffect:sfx]; }

#import "DataManager.h"
 
#define PlayEffect(sfx) //\
{                                                                                       \
    if ([sfx isEqualToString:SFX_COUNTDOWN_01] || [sfx isEqualToString:SFX_COUNTDOWN_02] || [sfx isEqualToString:SFX_COUNTDOWN_03] || [[DataManager shareDataManager] getUserConfigurationOfType:UserSettingTypeMusicEffect] == UserSettingStatusOn) \
    {                                                                                   \
         PlayMusicEffect(sfx);                                                          \
    }                                                                                   \
}

/*
 common function
 */
#define InitAudioEngine() //{ [SimpleAudioEngine sharedEngine]; }
#define DeleteAudioEngine() //{ [SimpleAudioEngine end]; }

#endif
