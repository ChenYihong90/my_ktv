//
//  PlayRecordViewController.m
//  my_ktv
//
//  Created by User on 13-3-8.
//  Copyright (c) 2013年 User. All rights reserved.
//

#import "PlayRecordViewController.h"
#import "CommonHelper.h"

@interface PlayRecordViewController (){
    IBOutlet UIButton *playOrPauseButton;
    IBOutlet UISlider *currentSlider;
    IBOutlet UILabel *recordNameLabel;
    IBOutlet UILabel *currentDurationLabel;
    IBOutlet UILabel *recordDurationLabel;
    int timeCount;
}

@property (nonatomic,retain) AVAudioPlayer *player;
@property (nonatomic,retain) NSTimer *timer;
@end

@implementation PlayRecordViewController
@synthesize recordArray,recordIndex;
@synthesize player;
@synthesize timer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:251/255.0 blue:251/255.0 alpha:1.0];
    NSDictionary *dic = [recordArray objectAtIndex:recordIndex];
    recordNameLabel.text = [dic objectForKey:@"songName"];
}

-(void)viewDidAppear:(BOOL)animated{
    NSDictionary *dic = [recordArray objectAtIndex:recordIndex];
    NSNumber *recordId = (NSNumber *)[dic objectForKey:@"recordid"];
    NSString *recordFilePath =  [[CommonHelper getRecorderFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.wav",[recordId intValue]]];
    NSURL *url = [NSURL fileURLWithPath:recordFilePath];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    player.delegate = self;
    if (player && [player prepareToPlay]) {
        [player play];
        
        int min = player.duration/60;
        int sec = (int)(player.duration/1)%60;
        recordDurationLabel.text = [NSString stringWithFormat:@"%0.2d:%0.2d",min,sec];
        playOrPauseButton.selected = YES;
        timeCount = 0;
        currentSlider.minimumValue = 0;
        currentSlider.maximumValue = (int)player.duration;
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
    }
}

- (void)viewDidUnload
{
    [self setRecordArray:nil];
    recordDurationLabel = nil;
    playOrPauseButton = nil;
    recordNameLabel = nil;
    currentDurationLabel = nil;
    currentSlider = nil;
    [super viewDidUnload];
}

#pragma mark - 自定义方法
/*descrption:关闭按钮
 autor:huangzhenda
 time:2013-03-08
 */
- (IBAction)close:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
    [player stop];
}

/*descrption:播放按钮触发事件
 autor:huangzhenda
 time:2013-03-08
 */
- (IBAction)playOrPause:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.selected) {
        btn.selected = NO;
        [player pause];
        [timer invalidate];
    }else{
        btn.selected = YES;
        [player play];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];    }
}

- (IBAction)upRecord:(id)sender {
    if (self.recordIndex >=1) {
        self.recordIndex  -= 1;
    }
    [self playAudio:self.recordIndex];
}

- (IBAction)nextRecord:(id)sender {
    if (self.recordIndex < self.recordArray.count -1) {
        self.recordIndex  += 1;
    }else{
        self.recordIndex = self.recordArray.count -1;
    }
    [self playAudio:self.recordIndex];
}

- (IBAction)sliderValueChange:(id)sender {
    player.currentTime = currentSlider.value;
    int min = currentSlider.value/60;
    int sec = (int)(currentSlider.value/1)%60;
    currentDurationLabel.text = [NSString stringWithFormat:@"%0.2d:%0.2d",min,sec];
    
}

- (void)updateTime:(id)sender{
    if ([sender isKindOfClass:[NSTimer class]]) {
        int min = currentSlider.value/60;
        int sec = (int)(currentSlider.value/1)%60;
        currentDurationLabel.text = [NSString stringWithFormat:@"%0.2d:%0.2d",min,sec];
        currentSlider.value += 1;
    }
}

-(void)playAudio:(int)recordindex{
    [timer invalidate];
    currentDurationLabel.text = @"00:00";
    
    NSDictionary *dic = [recordArray objectAtIndex:recordindex];
    recordNameLabel.text = [dic objectForKey:@"songName"];
    
    NSString *recordFilePath =  [[CommonHelper getRecorderFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.wav",self.recordIndex]];
    NSURL *url = [NSURL fileURLWithPath:recordFilePath];
    if (player != nil) {
        player = nil;
    }
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    player.delegate = self;
    if (player && [player prepareToPlay]) {
        [player play];
        int min = player.duration/60;
        int sec = (int)(player.duration/1)%60;
        recordDurationLabel.text = [NSString stringWithFormat:@"%0.2d:%0.2d",min,sec];
        playOrPauseButton.selected = YES;
        timeCount = 0;
        currentSlider.value = 0;
        currentSlider.minimumValue = 0;
        currentSlider.maximumValue = (int)player.duration;
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
    }
}

#pragma mark -
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
                         withFlags:(NSUInteger)flags{
    if (flags == AVAudioSessionInterruptionFlags_ShouldResume && self.player != nil){
        [self.player play];
    }
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    currentDurationLabel.text = @"00:00";
    playOrPauseButton.selected = NO;
    currentSlider.value = 0;
    timeCount = 0;
    [timer invalidate];
}

@end
