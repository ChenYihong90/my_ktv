//
//  PhoneSongsViewController.m
//  my_ktv
//
//  Created by User on 13-3-21.
//  Copyright (c) 2013年 User. All rights reserved.
//

#import "PhoneSongsViewController.h"
#import "SingleSongCell.h"
#import "CommonHelper.h"
#import "PlayViewController.h"

@interface PhoneSongsViewController ()

@end

@implementation PhoneSongsViewController
@synthesize array;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:251/255.0 blue:251/255.0 alpha:1.0];
    
    for (NSDictionary *dic in array) {
       NSURL *assetURL =[dic objectForKey:@"url"];
        NSString *str =[NSString stringWithFormat:@"%@ - %@.mp3",[dic objectForKey:@"artist"],[dic objectForKey:@"title"]];
        NSString *exportPath = [[CommonHelper getPhoneSongsPath] stringByAppendingPathComponent:str];
        //不存在才转换文件
        if (![CommonHelper isExistFile:exportPath]) {
              [self convert:assetURL fileName:str];
        }
    }
    [tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    tableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 
-(void)convert:(NSURL*)assetURL fileName:(NSString *)fileName{
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
    
    NSError *assetError = nil;
    AVAssetReader *assetReader = [AVAssetReader assetReaderWithAsset:songAsset
                                                                error:&assetError] ;
    if (assetError) {
        NSLog (@"error: %@", assetError);
        return;
    }
    
    AVAssetReaderOutput *assetReaderOutput = [AVAssetReaderAudioMixOutput assetReaderAudioMixOutputWithAudioTracks:songAsset.tracks
                                                                                                      audioSettings: nil] ;
    if (! [assetReader canAddOutput: assetReaderOutput]) {
        NSLog (@"can't add reader output... die!");
        return;
    }
    [assetReader addOutput: assetReaderOutput];
    
    
   NSString *exportPath = [[CommonHelper getPhoneSongsPath] stringByAppendingPathComponent:fileName];
    NSURL *exportURL = [NSURL fileURLWithPath:exportPath];
    
    AVAssetWriter *assetWriter = [AVAssetWriter assetWriterWithURL:exportURL
                                                           fileType:AVFileTypeCoreAudioFormat
                                                              error:&assetError];
    if (assetError) {
        NSLog (@"error: %@", assetError);
        return;
    }
    
    AudioChannelLayout channelLayout;
    memset(&channelLayout, 0, sizeof(AudioChannelLayout));
    channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
    NSDictionary *outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                    [NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                                    [NSNumber numberWithInt:2], AVNumberOfChannelsKey,
                                    [NSData dataWithBytes:&channelLayout length:sizeof(AudioChannelLayout)],AVChannelLayoutKey,
                                    [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                    [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                    [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                    [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                    nil];
    
    AVAssetWriterInput *assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio
                                                                               outputSettings:outputSettings] ;
    
    if ([assetWriter canAddInput:assetWriterInput]) {
        [assetWriter addInput:assetWriterInput];
    }
    else {
        NSLog (@"can't add asset writer input... die!");
        return;
    }
    assetWriterInput.expectsMediaDataInRealTime = NO;
    
    [assetWriter startWriting];
    [assetReader startReading];
    AVAssetTrack *soundTrack = [songAsset.tracks objectAtIndex:0];
    CMTime startTime = CMTimeMake (0, soundTrack.naturalTimeScale);
    [assetWriter startSessionAtSourceTime: startTime];
    
    __block UInt64 convertedByteCount = 0;
    dispatch_queue_t mediaInputQueue =
    dispatch_queue_create("mediaInputQueue", NULL);
    [assetWriterInput requestMediaDataWhenReadyOnQueue:mediaInputQueue
                                            usingBlock: ^
     {
         while (assetWriterInput.readyForMoreMediaData) {
             CMSampleBufferRef nextBuffer = [assetReaderOutput copyNextSampleBuffer];
             if (nextBuffer) {
                 // append buffer
                 [assetWriterInput appendSampleBuffer: nextBuffer];
                 // update ui
                 convertedByteCount += CMSampleBufferGetTotalSampleSize (nextBuffer);
                 NSNumber *convertedByteCountNumber = [NSNumber numberWithLong:convertedByteCount];
                 [self performSelectorOnMainThread:@selector(updateSizeLabel:)
                                        withObject:convertedByteCountNumber
                                     waitUntilDone:NO];
                 
                 CFRelease(nextBuffer);
             }
             else
             {
                 // done!
                 [assetWriterInput markAsFinished];
                 [assetWriter finishWriting];
                 [assetReader cancelReading];
                 NSDictionary *outputFileAttributes = [[NSFileManager defaultManager]
                                                       attributesOfItemAtPath:exportPath
                                                       error:nil];
                 
                 NSLog (@"done. file size is %llu", [outputFileAttributes fileSize]);
                 NSNumber *doneFileSize = [NSNumber numberWithLong: [outputFileAttributes fileSize]];
                 [self performSelectorOnMainThread:@selector(updateCompletedSizeLabel:)
                                        withObject:doneFileSize
                                     waitUntilDone:NO];

                 break;
             }
         }
     }];
    dispatch_release(mediaInputQueue);
    NSLog (@"bottom of convertTapped:");
}

//直接把文件内容分块读入内存，主要用于音频解析
//-(void)loadToMemory:(NSURL*)asset_url
//{
//    NSError *reader_error=nil;
//    AVURLAsset *item_choosed_asset=[AVURLAsset URLAssetWithURL:asset_url options:nil];
//    AVAssetReader *item_reader=[AVAssetReader assetReaderWithAsset:item_choosed_asset error:&reader_error];
//    if (reader_error) {
//        NSLog(@"failed to creat asset reader,reason:%@",[reader_error description]);
//        return;
//    }
//    NSArray *asset_tracks=[item_choosed_asset tracks];
//    AVAssetReaderAudioMixOutput *item_reader_output=[AVAssetReaderAudioMixOutput assetReaderAudioMixOutputWithAudioTracks:asset_tracks audioSettings:nil];
//    if ([item_reader canAddOutput:item_reader_output]) {
//        [item_reader addOutput:item_reader_output];
//    }else {
//        NSLog(@"the reader can not add the output");
//    }
//    
//    UInt64 total_converted_bytes;
//    UInt64 converted_count;
//    UInt64 converted_sample_num;
//    size_t sample_size;
//    short* data_buffer=nil;
//    CMBlockBufferRef next_buffer_data=nil;
//    
//    [item_reader startReading];
//    while (item_reader.status==AVAssetReaderStatusReading) {
//        CMSampleBufferRef next_buffer=[item_reader_output copyNextSampleBuffer];
//        if (next_buffer) {
//            
//            total_converted_bytes=CMSampleBufferGetTotalSampleSize(next_buffer);//next_buffer的总字节数；
//            sample_size=CMSampleBufferGetSampleSize(next_buffer, 0);//next_buffer中序号为0的sample的大小；
//            converted_sample_num=CMSampleBufferGetNumSamples(next_buffer);//next_buffer中所含sample的总个数；
//            
//            NSLog(@"the number of samples is %f",(float)converted_sample_num);
//            NSLog(@"the size of the sample is %f",(float)sample_size);
//            NSLog(@"the size of the whole buffer is %f",(float)total_converted_bytes);
//            
//            //copy the data to the data_buffer varible;
//            //这种方法中，我们每获得一次nextSampleBuffer后就对其进行解析，而不是把文件全部载入内存后再进行解析；
//            //AVAssetReaderOutput 的copyNextSampleBuffer方法每次读取8196个sample的数据(最后一次除外)，这些数据是以short型存放在内存中(两字节为一单元)
//            //每个sample的大小和音频的声道数相关，可以用CMSampleBufferGetSampleSize来获得，所以每次调用copyNextSampleBuffer后所获得的数据大小为8196*sample_size(byte);
//            //据此，我们申请data_buffer时每次需要的空间也是固定的，为(8196*sample_size)/2个short型内存(每个short占两字节);
//            if (!data_buffer) {
//                data_buffer= new short[4096*sample_size];
//            }
//            next_buffer_data=CMSampleBufferGetDataBuffer(next_buffer);
//            OSStatus buffer_status=CMBlockBufferCopyDataBytes(next_buffer_data, 0, total_converted_bytes, data_buffer);
//            if (buffer_status!=kCMBlockBufferNoErr) {
//                NSLog(@"something wrong happened when copying data bytes");
//            }
//            
//            /*
//             此时音频的数据存储在data_buffer中，这些数据是音频原始数据（未经任何压缩），可以对其进行解析或其它操作
//             */
//            
//        }else {
//            NSLog(@"total sameple size %lld", converted_count);
//            size_t total_data_length=CMBlockBufferGetDataLength(item_buffer);
//            NSLog(@"item buffer length is %f",(float)total_data_length);
//            break;
//        }
//    }
//    
//    if (item_reader.status==AVAssetReaderStatusCompleted) {
//        NSLog(@"read over......");
//    }else {
//        NSLog(@"read failed;");
//    }
//}

#pragma mark - 自定义方法
-(IBAction)back:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"MusicIdentifier";
    SingleSongCell *cell=(SingleSongCell *)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
        NSArray *arr=[[NSBundle mainBundle] loadNibNamed:@"SingleSongCell" owner:self options:nil];
        cell = [arr lastObject];
    }
    int i = [indexPath row];
    cell.lSinger.text = [[array objectAtIndex:i] objectForKey:@"artist"];
    cell.lSong.text = [[array objectAtIndex:i] objectForKey:@"title"];
    cell.fileInfo = [[FileModel alloc] init];
    cell.fileInfo.fileName = [NSString stringWithFormat:@"%@ - %@.mp3", cell.lSinger.text,cell.lSong.text];
    [cell.btn setTitle:@"演唱" forState:UIControlStateNormal];
    [cell.btn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [cell.btn setFrame:CGRectMake(265, 9, 50, 25)];
    [cell.btn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)play:(id)sender
{
    SingleSongCell * cell = (SingleSongCell *)[[sender superview] superview];
    FileModel *info = cell.fileInfo;
    PlayViewController *playViewController = [[PlayViewController alloc] init];
    playViewController.singType = SING_WITH_PHONE;
    playViewController.fileInfo = info;
    [playViewController setModalPresentationStyle:UIModalPresentationFormSheet];
    [playViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [viewController presentModalViewController:playViewController animated:YES];
    playViewController = nil;
}

@end
