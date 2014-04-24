//
//  PlayViewController.m
//  my_ktv
//
//  Created by User on 13-2-27.
//  Copyright (c) 2013年 User. All rights reserved.
//

#import "PlayViewController.h"
#import "KaraokePlatformViewController.h"
#import "CommonHelper.h"
#import "RIButtonItem.h"
#import "UIAlertView+Blocks.h"
#import "MyRecorderViewController.h"

@interface PlayViewController ()

@end

@implementation PlayViewController
//@synthesize songInfo;
@synthesize soundLeverView;
@synthesize backImageView;
@synthesize downBar;
@synthesize gradeLabel;
@synthesize fileInfo;
@synthesize lPlayOff;
@synthesize lrcLabel;
@synthesize lSingerName;
@synthesize lSongName;
@synthesize lSecondLrcLabel;
@synthesize lSelectedLrcLabel;
@synthesize albumImage;
@synthesize singType;
@synthesize recordArray,recordDictionary,audioMixParams;
@synthesize viewController;
@synthesize speakHereController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置背景图片的阴影
    backImageView.layer.shadowRadius = 5;
    backImageView.layer.shadowOpacity = 0.8;
    
    downBar.layer.shadowOpacity = 0.3;
    downBar.layer.shadowRadius = 1;
    
    if (singType == SING_WITH_MUSICAL)
    {
        index = 0;
        self.lSongName.text = self.fileInfo.mSongName;
        self.lSingerName.text = self.fileInfo.mSingerName;
        //    self.albumImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.fileInfo.mAlbumLink]]];
        
        NSString *lrcPath = [[CommonHelper getLrcPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",self.fileInfo.fileName]];
        
        if (![CommonHelper isExistFile:lrcPath])
        {
            lrcDown = [[LrcDown alloc] init];
            lrcDown.lrcName = self.fileInfo.fileName;
            [lrcDown startLrc:self.fileInfo.mSongLrcUrl];
        }
        else
        {
            
            NSString *result = [NSString stringWithContentsOfFile:lrcPath encoding:NSUTF8StringEncoding error:nil];
            lrcDown = [[LrcDown alloc] init];
            lrcDown.lrc = [JSLrcParser lrcValue:result];
            NSMutableString *s = [NSMutableString string];
            for (id key in [lrcDown lrcKeys])
            {
                [s appendString:[lrcDown.lrc.lyric objectForKey:key]];
                [s appendString:@"\n"];
            }
        }
    }
    
    self.albumImage.image = [UIImage imageNamed:@"album_default.jpg"];
    
    meterLeverArray = [[NSMutableArray alloc] initWithCapacity:55];
    for(int i = 0;i<20;i++){
        [meterLeverArray addObject:[NSNumber numberWithDouble:40]];
    }
    soundLeverTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateLever:) userInfo:nil repeats:YES];
    
    if (singType == SING_WITH_MUSICAL)
    {
        UIButton *origialBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [origialBtn setBackgroundImage:[UIImage imageNamed:@"down_bar_button_pressed.png"] forState:UIControlStateNormal];
        [origialBtn setFrame:CGRectMake(9, 423, 58, 33)];
        [origialBtn setTitle:@"原唱" forState:UIControlStateNormal];
        [origialBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
        [origialBtn addTarget:self action:@selector(playOriginalMusic:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:origialBtn];
    }
    
    //初始化：如果这个忘了的话，可能会第一次播放不了
    
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    
    OSStatus error;
    UInt32 category = kAudioSessionCategory_PlayAndRecord;
    error = AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    error = AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,sizeof (audioRouteOverride),&audioRouteOverride);
    if (error) printf("couldn't set audio category!");
    AudioSessionSetActive(true);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *songName;
    if (singType == SING_WITH_MUSICAL)
    {
        songName = [fileInfo.fileName substringWithRange:NSMakeRange(0, fileInfo.fileName.length -4)];
        NSString * fileName = [[CommonHelper getMusicFolderPath] stringByAppendingPathComponent:fileInfo.fileName];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:fileName];
        NSError *error = nil;
        accompanyPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
        NSLog(@"%@",fileURL);
        NSLog(@"error:%@",error);
        accompanyPlayer.delegate = self;
        [accompanyPlayer prepareToPlay];
        [accompanyPlayer play];
    }
    else if (singType == SING_WITH_PHONE)
    {
        songName = [fileInfo.fileName substringWithRange:NSMakeRange(0, fileInfo.fileName.length -4)];
        NSString * fileName = [[CommonHelper getPhoneSongsPath] stringByAppendingPathComponent:fileInfo.fileName];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:fileName];
        NSError *error = nil;
        accompanyPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
        NSLog(@"%@",fileURL);
        NSLog(@"error:%@",error);
        accompanyPlayer.delegate = self;
        [accompanyPlayer prepareToPlay];
        [accompanyPlayer play];
    }
    else
    {
        songName = @"清唱";
    }
    
    //开始录音
    NSError *error;
    NSString *recordPath;
    NSString *recordPlistPath = [[CommonHelper getRecorderFolderPath] stringByAppendingPathComponent:@"recorder.plist"];
    if (![CommonHelper isExistFile:recordPlistPath])
    {
        [CommonHelper createFile:recordPlistPath];
    }
    else
    {
        //获取录音配置文件
        recordArray = [NSMutableArray arrayWithContentsOfFile:recordPlistPath];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        
        //设置录音配置文件
        recordDictionary = [NSMutableDictionary dictionary];
        [recordDictionary setObject:[NSNumber numberWithInt:recordArray.count] forKey:@"recordid"];
        [recordDictionary setObject:songName forKey:@"songName"];
        [recordDictionary setObject:dateStr forKey:@"time"];
        
        if (singType == SING_WITH_MUSICAL) {
            recordPath = [[CommonHelper getRecorderFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"record%d.wav",recordArray.count]];
        }else{
            recordPath = [[CommonHelper getRecorderFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.wav",recordArray.count]];
        }
    }
    
    //设置保存路径
    NSURL *url = [NSURL fileURLWithPath:recordPath];
    //设置录音参数
    NSMutableDictionary *settingsDictionary = [NSMutableDictionary dictionaryWithCapacity:5];
    [settingsDictionary setValue:[NSNumber numberWithInteger:kAudioFormatULaw] forKey:AVFormatIDKey];
    [settingsDictionary setValue:[NSNumber numberWithInteger:8000.0f] forKey:AVSampleRateKey];
    [settingsDictionary setValue:[NSNumber numberWithInteger:8] forKey:AVLinearPCMBitDepthKey];
    [settingsDictionary setValue:[NSNumber numberWithInteger:1] forKey:AVNumberOfChannelsKey];
    [settingsDictionary setValue:[NSNumber numberWithInteger:AVAudioQualityLow] forKey:AVEncoderAudioQualityKey];
    [settingsDictionary setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [settingsDictionary setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    myRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:settingsDictionary error:&error];
    
    if (error)
    {
        NSLog(@"error:%@",error);
    }
    else
    {
        if (myRecorder !=nil && [myRecorder prepareToRecord])
        {
            [myRecorder record];
            myRecorder.meteringEnabled = YES;
            recordTime = 0;
            
        }
    }
    
    timer = [NSTimer
             scheduledTimerWithTimeInterval:0.1
             target:self
             selector:@selector(updateProgress:)
             userInfo:nil
             repeats:YES];
    
}

- (void)viewDidUnload
{
    [self setBackImageView:nil];
    [self setDownBar:nil];
    [self setGradeLabel:nil];
    [self setSoundLeverView:nil];
    [super viewDidUnload];
    [timer invalidate];
    timer = nil;
    [accompanyPlayer stop];
    accompanyPlayer = nil;
    self.lPlayOff = nil;
    self.lSelectedLrcLabel = nil;
    self.lrcLabel = nil;
    self.lSecondLrcLabel = nil;
    self.lSongName = nil;
    self.lSingerName = nil;
    self.albumImage = nil;
    self.recordDictionary = nil;
    self.recordArray = nil;
    
    
    [soundLeverTimer invalidate];
}


#pragma mark - 自定义方法

//
-(void)updateLever:(NSTimer *)sender{
    //    if (sender == soundLeverTimer) {
    //        [myRecorder updateMeters];
    //        const double ALPHA = 0.05;
    //        double peakPowerForChannel = pow(10, (0.05 * [myRecorder peakPowerForChannel:0]));
    //        lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;
    //
    //        [meterLeverArray removeObjectAtIndex:0];
    //        //        for (id i in meterLeverArray) {
    //        //            [array addObject:i];
    //        //        }
    //        NSMutableArray *array = [NSMutableArray arrayWithArray:meterLeverArray];
    //
    //        meterLeverArray = nil;
    //        meterLeverArray = array;
    
    //        if (lowPassResults > 0.2){
    //            self.soundLeverView.meterLever = lowPassResults *10;
    //            [meterLeverArray addObject:[NSNumber numberWithDouble:lowPassResults*100]];
    //        }else{
    //            self.soundLeverView.meterLever = 0;
    //            [meterLeverArray addObject:[NSNumber numberWithDouble:40]];
    //        }
    //
    //        self.soundLeverView.meterLeverArray = meterLeverArray;
    //        [soundLeverView setNeedsDisplay];
    //    }
}

//方法功能：返回点歌台页面
-(IBAction)close:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    [accompanyPlayer stop];
    accompanyPlayer = nil;
    [timer invalidate];
    timer = nil;
    [singleTimer invalidate];
    singleTimer = nil;
    
    NSString *recordPath;
    if (singType == SING_WITH_MUSICAL) {
        recordPath = [[CommonHelper getRecorderFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"record%d.wav",recordArray.count]];
    }else{
        recordPath = [[CommonHelper getRecorderFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.wav",recordArray.count]];
    }
    [CommonHelper removeFile:recordPath];
}

//方法功能：播放原唱歌曲
-(IBAction)playOriginalMusic:(id)sender
{
    [self pauseAnimation];
    
    [myRecorder pause];
    [accompanyPlayer pause];
    NSString *songName;
    songName = [fileInfo.fileName substringWithRange:NSMakeRange(0, fileInfo.fileName.length -4)];
    NSString * fileName = [[CommonHelper getMusicFolderPath] stringByAppendingPathComponent:fileInfo.fileName];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:fileName];
    NSError *error = nil;
    originalMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
    NSLog(@"%@",fileURL);
    NSLog(@"error:%@",error);
    originalMusicPlayer.delegate = self;
    [originalMusicPlayer prepareToPlay];
    [originalMusicPlayer play];
    
    timer2 = [NSTimer
              scheduledTimerWithTimeInterval:0.1
              target:self
              selector:@selector(updateLabel:)
              userInfo:nil
              repeats:YES];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    view.backgroundColor = [UIColor colorWithRed:36/255.0 green:48/255.0 blue:57/255.0 alpha:0.5];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(108, 178, 104, 104)];
    view2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_view.png"]];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(4, 3, 100, 21)];
    label1.text = @"50秒原唱试听";
    label1.font = [UIFont boldSystemFontOfSize:12];
    label1.backgroundColor = [UIColor clearColor];
    label1.textAlignment = UITextAlignmentCenter;
    label1.textColor = [UIColor colorWithRed:208/255.0 green:119/255.0 blue:11/255.0 alpha:1.0];
    [view2 addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(4, 27, 100, 21)];
    label2.text = [NSString stringWithFormat:@"%@ - %@",fileInfo.mSongName,fileInfo.mSingerName];
    label2.font = [UIFont boldSystemFontOfSize:12];
    label2.backgroundColor = [UIColor clearColor];
    label2.textAlignment = UITextAlignmentCenter;
    label2.textColor = [UIColor colorWithRed:208/255.0 green:119/255.0 blue:11/255.0 alpha:1.0];
    [view2 addSubview:label2];
    
    label3 = [[UILabel alloc] initWithFrame:CGRectMake(4, 51, 100, 21)];
    double progress = (double)originalMusicPlayer.currentTime;
    label3.text = [NSString stringWithFormat:@"%@/00:50",[self timeStringWithNumber:(int)progress]];
    label3.font = [UIFont boldSystemFontOfSize:12];
    label3.backgroundColor = [UIColor clearColor];
    label3.textAlignment = UITextAlignmentCenter;
    label3.textColor = [UIColor colorWithRed:208/255.0 green:119/255.0 blue:11/255.0 alpha:1.0];
    [view2 addSubview:label3];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setFrame:CGRectMake(12, 72, 80, 25)];
    [btn setTitleColor:[UIColor colorWithRed:208/255.0 green:119/255.0 blue:11/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btn setTitle:@"继续演唱" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(continuePlay:) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:btn];
    
    [view addSubview:view2];
    [self.view addSubview:view];
}

- (void)updateLabel:(NSTimer *)updatedTimer
{
    double progress = (double)originalMusicPlayer.currentTime;
    label3.text = [NSString stringWithFormat:@"%@/00:50",[self timeStringWithNumber:(int)progress]];
    
}

//方法功能：继续演唱
-(void)continuePlay:(UIButton *)sender
{
    [self resumeAnimation];
    
    [originalMusicPlayer stop];
    originalMusicPlayer = nil;
    [timer2 invalidate];
    
    [accompanyPlayer prepareToPlay];
    [accompanyPlayer play];
    
    [[[[[[sender  superview] superview] superview] subviews] lastObject] removeFromSuperview];
    for (UIView *view in [[[sender  superview] superview]  subviews]) {
        [view removeFromSuperview];
    }
    
    [myRecorder record];
}

//方法功能：完成录音
- (IBAction)commitRecord:(id)sender {
    
    RIButtonItem *cancelItem = [RIButtonItem item];
    cancelItem.label = @"取消";
    
    RIButtonItem *commitItem = [RIButtonItem item];
    commitItem.label = @"确定";
    commitItem.action = ^
    {
        [myRecorder stop];
        [singleTimer invalidate];
        [timer invalidate];
        //执行方法体
        if (singType == SING_WITH_MUSICAL) {
            AVMutableComposition *composition = [AVMutableComposition composition];
            audioMixParams = [[NSMutableArray alloc] initWithObjects:nil];
            
            //Add Audio Tracks to Composition
            NSString *recordPath = [CommonHelper getRecorderFolderPath];
            NSString *path = [recordPath stringByAppendingPathComponent:[NSString stringWithFormat:@"record%d.wav",recordArray.count]];
            NSLog(@"===record::%@",path);
            NSURL *assetURL1 = [NSURL fileURLWithPath:path];
            
            AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL1 options:nil];
            CMTime startTime = CMTimeMakeWithSeconds(0, 1);
            CMTime trackDuration = songAsset.duration;
            [self setUpAndAddAudioAtPath:assetURL1 toComposition:composition start:startTime dura:trackDuration offset:CMTimeMake(0, 44100) songNum:1];
            
            NSString * fileName = [[CommonHelper getMusicFolderPath] stringByAppendingPathComponent:fileInfo.fileName];
            NSLog(@"===fileName:%@",fileName);
            NSURL *assetURL2 = [NSURL fileURLWithPath:fileName];
            [self setUpAndAddAudioAtPath:assetURL2 toComposition:composition start:startTime dura:trackDuration offset:CMTimeMake(0, 44100) songNum:2];
            
            AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
            audioMix.inputParameters = [NSArray arrayWithArray:audioMixParams];
            
            //If you need to query what formats you can export to, here's a way to find out
            NSLog (@"compatible presets for songAsset: %@",
                   [AVAssetExportSession exportPresetsCompatibleWithAsset:composition]);
            
            AVAssetExportSession *exporter = [[AVAssetExportSession alloc]
                                              initWithAsset: composition
                                              presetName:AVAssetExportPresetAppleM4A];
            exporter.audioMix = audioMix;
            exporter.outputFileType = @"com.apple.m4a-audio";
            NSString *exportFile = [recordPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.wav",recordArray.count]];
            
            // set up export
            if ([[NSFileManager defaultManager] fileExistsAtPath:exportFile]) {
                [[NSFileManager defaultManager] removeItemAtPath:exportFile error:nil];
            }
            NSURL *exportURL = [NSURL fileURLWithPath:exportFile];
            exporter.outputURL = exportURL;
            
            // do the export
            [exporter exportAsynchronouslyWithCompletionHandler:^{
                int exportStatus = exporter.status;
                switch (exportStatus) {
                    case AVAssetExportSessionStatusFailed:{
                        NSError *exportError = exporter.error;
                        NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                        break;
                    }
                        
                    case AVAssetExportSessionStatusCompleted:
                        [CommonHelper removeFile:path];
                        NSLog (@"AVAssetExportSessionStatusCompleted"); break;
                    case AVAssetExportSessionStatusUnknown: NSLog (@"AVAssetExportSessionStatusUnknown"); break;
                    case AVAssetExportSessionStatusExporting: NSLog (@"AVAssetExportSessionStatusExporting"); break;
                    case AVAssetExportSessionStatusCancelled: NSLog (@"AVAssetExportSessionStatusCancelled"); break;
                    case AVAssetExportSessionStatusWaiting: NSLog (@"AVAssetExportSessionStatusWaiting"); break;
                    default:  NSLog (@"didn't get export status"); break;
                }
            }];
            
        }
        //将录音配置数据加入到配置文件中
        [recordArray addObject:recordDictionary];
        NSString *recordPlistPath = [[CommonHelper getRecorderFolderPath] stringByAppendingPathComponent:@"recorder.plist"];
        
        
        if([CommonHelper isExistFile:recordPlistPath]){
            [CommonHelper removeFile:recordPlistPath];
            [recordArray writeToFile:recordPlistPath atomically:YES];
        }
        
        
        [accompanyPlayer stop];
        MyRecorderViewController *myRecord = (MyRecorderViewController *)viewController;
        [myRecord reloadDataSource];
        [self dismissModalViewControllerAnimated:YES];
    };
    
    //判断框弹出
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"是否确定完成录制？" cancelButtonItem:cancelItem otherButtonItems:commitItem, nil];
    [alertView show];
}


//方法功能：设置音频轨道的开始时间和结束时间，并将加入到混合音频轨道中
-(void)setUpAndAddAudioAtPath:(NSURL*)assetURL toComposition:(AVMutableComposition *)composition start:(CMTime)start dura:(CMTime)dura offset:(CMTime)offset songNum:(int)song{
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
    
    AVMutableCompositionTrack *track = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *sourceAudioTrack = [[songAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    
    NSError *error = nil;
    
    CMTime startTime = start;
    CMTime trackDuration = dura;
    CMTimeRange tRange = CMTimeRangeMake(startTime, trackDuration);
    
    //Set Volume
    AVMutableAudioMixInputParameters *trackMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
    if (song == 1) {
        [trackMix setVolume:0.9f atTime:startTime];
    }else{
        [trackMix setVolume:0.6f atTime:startTime];
    }
    [audioMixParams addObject:trackMix];
    
    //Insert audio into track  //offset CMTimeMake(0, 44100)
    [track insertTimeRange:tRange ofTrack:sourceAudioTrack atTime:offset error:&error];
}


- (void)updateProgress:(NSTimer *)updatedTimer
{
    if (singType == SING_WITH_MUSICAL) {
        double progress = (double)accompanyPlayer.currentTime;
        double duration = (double)accompanyPlayer.duration;
        if (duration > 0)
        {
            self.lPlayOff.text = [NSString stringWithFormat:@"正在录音：%@/%@",[self timeStringWithNumber:(int)progress],[self timeStringWithNumber:(int)duration]];
            [self totalTimeInterval:duration currentTimeInterval:progress];
        }
    }else{
        recordTime += 0.1;
        self.lPlayOff.text = [NSString stringWithFormat:@"正在录音：%@",[self timeStringWithNumber:recordTime]];
    }
}

//方法功能：播放时间换算成时间格式
-(NSString*)timeStringWithNumber:(float)theTime{
    NSString *minuteS;
    
    int minute=(theTime) / 60;
    if(theTime < 60){
        minuteS=@"00";
    }else if(minute < 10){
        minuteS=[NSString stringWithFormat:@"0%i",(minute)];
    }else{
        minuteS=[NSString stringWithFormat:@"%i",(minute)];
    }
    
    NSString *playTimeS;
    if(theTime - 60 * minute < 10){
        playTimeS=[NSString stringWithFormat:@"%@:0%0.0f",minuteS,theTime-60*minute];
    }else{
        playTimeS=[NSString stringWithFormat:@"%@:%0.0f",minuteS,theTime-60*minute];
    }
    return playTimeS;
}

-(void)gradeSong:(NSTimer *)sender{
    
    if (sender == singleTimer) {
        if (lowPassResults > 0.2 && lowPassResults < 0.8){
            singleGrade++;
        }
        
        int dex = singleIndex;
        double duration = 0.0;
        NSString *key = [lrcDown.musicLrcArray objectAtIndex:dex+1];
        duration = [key doubleValue] - [[lrcDown.musicLrcArray objectAtIndex:dex] doubleValue] ;
        double progress = (double)accompanyPlayer.currentTime;
        NSLog(@"Grading....");
        if (progress >= [key doubleValue] ) {
            singleIndex ++;
            NSLog(@"得分:%0.0f",singleGrade/duration);
            gradeLabel.text = [NSString stringWithFormat:@"演唱得分:%0.0f",singleGrade/duration];
            [singleTimer invalidate];
            singleTimer = nil;
            singleGrade = 0;
            NSLog(@"EndGrade....");
        }
        
    }
}

//方法功能：管理歌词动态
- (void)totalTimeInterval:(NSTimeInterval)total currentTimeInterval:(NSTimeInterval)timeInterval
{
    if ([lrcDown.musicLrcArray count] > index)
    {
        
        //1.得到当前行歌词开始出现的时间
        //2.当音乐时间>=当前行歌词开始出现的时间，进入定时器，开始进行评分
        //3.当当前音乐时间大于下一行歌词开始出现时间，定时器退出
        //        NSLog(@"----cuurentDuration:%f,musicLrcTime:%f",timeInterval,[[lrcDown.musicLrcArray objectAtIndex:index] doubleValue]);
        double lrctime =  [[lrcDown.musicLrcArray objectAtIndex:singleIndex] doubleValue];
        NSLog( @"currentime:%f,musiclrctime%f",timeInterval,lrctime);
        if (timeInterval >= lrctime) {
            if (singleTimer == nil) {
                singleGrade = 0;
                singleTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(gradeSong:) userInfo:nil repeats:YES];
                NSLog(@"bgeinGrade....");
            }
        }
        
        if ([[lrcDown.musicLrcArray objectAtIndex:index] doubleValue] <= timeInterval) {
            [self refreshView];
        }
        
        
    }
    
}

//方法功能：歌词效果控制,逐字描绘，两行交替显示
- (void)refreshView
{
    id key = [lrcDown.musicLrcArray objectAtIndex:index];
    NSString __autoreleasing *s = [lrcDown.lrc.lyric objectForKey:key];
    
    double duration = 0.0;
    CGSize size = [s sizeWithFont:self.lrcLabel.font
                constrainedToSize:(CGSize){self.lrcLabel.frame.size.width, NSIntegerMax}
                    lineBreakMode:self.lrcLabel.lineBreakMode];
    
    if (index < [lrcDown.musicLrcArray count] - 1) {
        id nextkey = [lrcDown.musicLrcArray objectAtIndex:index + 1];
        NSString __autoreleasing *nextS = [lrcDown.lrc.lyric objectForKey:nextkey];
        
        duration = [[lrcDown.musicLrcArray objectAtIndex:++index] doubleValue] - [key doubleValue];
        
        if (index %2 != 0) {
            self.lrcLabel.text = s;
            self.lSecondLrcLabel.text = nextS;
            self.lSelectedLrcLabel.text = s;
            self.lSelectedLrcLabel.frame =(CGRect){self.lrcLabel.frame.origin,self.lSelectedLrcLabel.frame.size};
            
            if (duration > 0.00001) {
                self.lSelectedLrcLabel.frame = (CGRect){self.lSelectedLrcLabel.frame.origin.x,self.lSelectedLrcLabel.frame.origin.y+11.5, {size.width, size.height}};
                [self addAnimations:duration];
                
            } else {
                self.lSelectedLrcLabel.frame = (CGRect){self.lSelectedLrcLabel.frame.origin, {size.width, size.height}};
            }
            
        }
        else{
            self.lrcLabel.text = nextS;
            self.lSecondLrcLabel.text = s;
            self.lSelectedLrcLabel.text = s;
            self.lSelectedLrcLabel.frame = (CGRect){self.lSecondLrcLabel.frame.origin,self.lSelectedLrcLabel.frame.size};
            
            if (duration > 0.00001) {
                self.lSelectedLrcLabel.frame = (CGRect){{(300 - size.width),self.lSelectedLrcLabel.frame.origin.y+11.5}, {size.width, size.height}};
                [self addAnimations:duration];
            } else {
                self.lSelectedLrcLabel.frame = (CGRect){self.lSelectedLrcLabel.frame.origin, {size.width, size.height}};
            }
        }
    }
}

- (void)addAnimations:(double)during
{
    CGRect bounds = CGRectMake((lSelectedLrcLabel.frame.origin.x + lSelectedLrcLabel.frame.size.width/2), self.lSelectedLrcLabel.frame.origin.y, 0, self.lSelectedLrcLabel.frame.size.height);
    NSLog(@"===++%f",bounds.origin.y);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    animation.duration = during;
    animation.fromValue = [NSValue valueWithCGRect:bounds];
    animation.toValue = [NSValue valueWithCGRect:self.lSelectedLrcLabel.bounds];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.delegate = self;
    animation.repeatCount = 1;
    [self.lSelectedLrcLabel.layer addAnimation:animation forKey:@"BoundsAnimation"];
    
    animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = during;
    animation.fromValue = [NSValue valueWithCGPoint:self.lSelectedLrcLabel.frame.origin];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(bounds.origin.x, bounds.origin.y)];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.delegate = self;
    animation.repeatCount = 1;
    [self.lSelectedLrcLabel.layer addAnimation:animation forKey:@"PositionAnimation"];
}

//暂停layer上面的动画
- (void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

//继续layer上面的动画
- (void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

- (void)pauseAnimation
{
    [self pauseLayer:lSelectedLrcLabel.layer];
}

- (void)resumeAnimation
{
    [self resumeLayer:lSelectedLrcLabel.layer];
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [timer invalidate];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)thePlayer
{
    [thePlayer pause];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags
{
    
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    
}

#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder{
    [myRecorder pause];
}

-(void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder{
    [myRecorder record];
}

@end
