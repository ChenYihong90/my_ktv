//
//  PlayViewController.h
//  my_ktv
//
//  Created by User on 13-2-27.
//  Copyright (c) 2013年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "SongInfo.h"
#import "FileModel.h"
#import "LrcDown.h"
#import "soundLever.h"

typedef enum {
    SING_WITHOUT_MAKEUP,
    SING_WITH_MUSICAL,
    SING_WITH_PHONE
}SingType;

@class SpeakHereController;
@interface PlayViewController : UIViewController<AVAudioPlayerDelegate,AVAudioRecorderDelegate>
{
    LrcDown *lrcDown;
    AVAudioPlayer *accompanyPlayer;     //伴唱
    AVAudioPlayer *originalMusicPlayer;  //原唱
    NSUInteger index;
    NSTimer *timer;  //定时器
     NSTimer *timer2;  //原唱的定时器
    UILabel *label3;   //原唱里的Label
    
    NSMutableArray *recordArray;//存储录音配置文件数组
    AVAudioRecorder *myRecorder;
    NSMutableDictionary *recordDictionary;//存储录音配置文件数据
    double recordTime;//录音时长
    NSMutableArray *audioMixParams;//音频轨道数组
    NSMutableArray *meterLeverArray;
    
    id viewController;
    
    int totalGrade;//总评分
    int singleGrade;//单句评分
    double singleDuration;//单句时长
    NSTimer *singleTimer;//单句录音定时器，获取录音分贝
    NSTimer *soundLeverTimer;//波形定时器
    int singleIndex;
    double lowPassResults;
    
    IBOutlet SpeakHereController *speakHereController;
}

@property (nonatomic,retain)    IBOutlet SpeakHereController *speakHereController;
@property (nonatomic,strong) FileModel *fileInfo;
@property (strong,nonatomic) IBOutlet UILabel *lPlayOff;            //当前播放进度
@property (strong,nonatomic) IBOutlet UILabel *lSelectedLrcLabel;   //当前歌词
@property (strong,nonatomic) IBOutlet UILabel *lrcLabel;           //歌词
@property (strong,nonatomic) IBOutlet UILabel *lSecondLrcLabel;     //第二行歌词
@property (strong,nonatomic) IBOutlet UILabel *lSongName;          //歌曲名称
@property (strong,nonatomic) IBOutlet UILabel *lSingerName;        //歌手
@property (retain, nonatomic) IBOutlet UIImageView *albumImage;    //专辑图片
@property (unsafe_unretained, nonatomic) IBOutlet soundLever *soundLeverView;
@property (nonatomic,retain) IBOutlet UIImageView *backImageView;
@property (nonatomic,retain) IBOutlet UIImageView *downBar;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *gradeLabel;
@property (retain,nonatomic) NSMutableArray *recordArray;
@property (retain,nonatomic) NSMutableDictionary *recordDictionary;

@property (retain,nonatomic) NSMutableArray *audioMixParams;//音频轨道数组

@property (retain,nonatomic) id viewController;
@property (nonatomic) SingType singType;//演唱里类型


-(void)setUpAndAddAudioAtPath:(NSURL*)assetURL toComposition:(AVMutableComposition *)composition start:(CMTime)start dura:(CMTime)dura offset:(CMTime)offset songNum:(int)song;


@end
