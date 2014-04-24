//
//  KaraokePlatformViewController.m
//  my_ktv
//
//  Created by User on 13-2-25.
//  Copyright (c) 2013年 User. All rights reserved.
//

#import "KaraokePlatformViewController.h"
#import "CommonHelper.h"
#import "PlayViewController.h"
#import "SingleSongCell.h"
#import "MainViewController.h"
#import "Reachability.h"
#import "SVProgressHUD.h"
#import "PhoneSongsViewController.h"

@interface KaraokePlatformViewController ()
@end

@implementation KaraokePlatformViewController
@synthesize tableView;
@synthesize viewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:251/255.0 blue:251/255.0 alpha:1.0];
    tableViewArray =[[NSMutableArray alloc] initWithCapacity:0];
    [self loadMusicData];
}

-(void)viewWillAppear:(BOOL)animated
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.downloadDelegateFirst=self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView = nil;
}

#pragma mark - 自定义方法

//下载音乐列表
-(void)loadMusicData
{
    //不存在则下载，存在的话从文件中获取数据
    NSString *filePath = [CommonHelper getPlistPath];
    if (![CommonHelper isExistFile:filePath])
    {
        NSString *tempWifi = [self GetCurrntNet];
        if (![tempWifi isEqualToString:@"wifi"])
        {
            [SVProgressHUD showImage:[UIImage imageNamed:@"action_delete.png"] status:@"没有检查到Wifi信号"];
            return;
        }
        NSString *musicurlString;
        musicurlString =[NSString stringWithFormat:@"http://music.qq.com/musicbox/shop/v3/data/hit/hit_newsong.js"];
        MusicGetter *getter = [[MusicGetter alloc]init];
        getter.delegate = self;
        [getter getMusicListData:musicurlString];
    }
    else{
        NSMutableArray *tempArray = [NSMutableArray arrayWithContentsOfFile:filePath];
        for (NSMutableDictionary *dic in tempArray) {
            FileModel *fileInfo = [[FileModel alloc] init];
            fileInfo.mAlbumLink = [dic objectForKey:@"albumLink"];
            fileInfo.mAlbumName = [dic objectForKey:@"albumName"];
            fileInfo.mPlaytime = [dic objectForKey:@"playTime"];
            fileInfo.mSingerName = [dic objectForKey:@"singerName"];
            fileInfo.mSongLrcUrl = [dic objectForKey:@"songLrcUrl"];
            fileInfo.mSongUrl = [dic objectForKey:@"songUrl"];
            fileInfo.mSongName = [dic objectForKey:@"songName"];
            [tableViewArray addObject:fileInfo];
        }
    }
    
    
}

//方法功能：检查网络状况
-(NSString*)GetCurrntNet
{
    NSString* result = nil;
    Reachability *reachability =[Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reachability currentReachabilityStatus]) {
        case NotReachable:// 没有网络连接
            result=nil;
            break;
        case ReachableViaWWAN:// 使用3G网络
            result=@"3g";
            break;
        case ReachableViaWiFi:// 使用WiFi网络
            result=@"wifi";
            break;
    }
    return result;
}

#pragma mark - MusicGetterDelegate
-(void)musicList:(NSMutableArray *)result
{
    tableViewArray = result;
    [self.tableView reloadData];
    
}

#pragma mark - UItableViewDelegate && UITableDataSource
- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    return;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == 0)
    {
//        if (mediaPickerCtr != nil) {
//            mediaPickerCtr = nil;
//        }
//        //        if (musicPlayerCtr != nil) {
//        //            musicPlayerCtr = nil;
//        //        }
//        mediaPickerCtr = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAny];
//        if (mediaPickerCtr != nil){
//            NSLog(@"Successfully instantiated a media picker.");
//            mediaPickerCtr.delegate = self;
//            mediaPickerCtr.allowsPickingMultipleItems = NO;
//            
//        }else{
//            NSLog(@"Faild instantiated a media picker");
//        }
//        //        musicPlayerCtr = [MPMusicPlayerController applicationMusicPlayer];
//        //
//        //        [viewController presentModalViewController:mediaPickerCtr animated:YES];
//        
//        
//        PhoneSongsViewController *theViewController = [[PhoneSongsViewController alloc] init];
//        theViewController.array = phoneSongs;
//        [viewController presentModalViewController:theViewController animated:YES];
        
        phoneSongs = [[NSMutableArray alloc] initWithCapacity:0];
        MPMediaQuery *myPlaylistsQuery = [MPMediaQuery songsQuery];
        NSArray *playlists = [myPlaylistsQuery collections];
        for (MPMediaPlaylist *playlist in playlists) {
            NSArray *songs = [playlist items];
            for (MPMediaItem *song in songs) {
                 NSURL *url =[song valueForProperty:MPMediaItemPropertyAssetURL];             //歌曲URL
                NSString *title = [song valueForProperty: MPMediaItemPropertyTitle];          //获取歌曲标题
                NSString *songTag = [song valueForKey:MPMediaItemPropertyPodcastTitle];       //第几首歌
                NSString *artist =[song valueForProperty:MPMediaItemPropertyArtist];         //获取歌手姓名
                NSString *albumTitle = [song valueForProperty:MPMediaItemPropertyAlbumTitle];     //获取专辑标题
                
                NSLog(@"%@,%@,%@,%@,%@",url,title,songTag,artist,albumTitle);
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
                [dic setObject:url forKey:@"url"];
                [dic setObject:title forKey:@"title"];
                [dic setObject:songTag forKey:@"tag"];
                [dic setObject:artist forKey:@"artist"];
                [dic setObject:albumTitle forKey:@"album"];
                [phoneSongs addObject:dic];
            }  
        }
        PhoneSongsViewController *theViewController = [[PhoneSongsViewController alloc] init];
        theViewController.array = phoneSongs;
        [viewController presentModalViewController:theViewController animated:YES];
        
    }
    else
    {
        //弹出视图
        //        FileModel *theFile = [[FileModel alloc] init];
        //        theFile = [tableViewArray objectAtIndex:indexPath.row - 1];
        //
        //        UIView *poperView = [[UIView alloc] initWithFrame:CGRectMake(80, 160, 176, 115)];
        //        poperView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_pop.png"]];
        //        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 150, 21)];
        //        label.backgroundColor = [UIColor clearColor];
        //
        //        NSInteger theTime = [theFile.mPlaytime integerValue];
        //        NSString *minutes;
        //        NSString *seconds;
        //        int min = theTime/60;
        //        minutes = [NSString stringWithFormat:@"%d",min];
        //        int sec = theTime % 60;
        //        seconds = [NSString stringWithFormat:@"%2d",sec];
        //
        //        label.text = [NSString stringWithFormat:@"时长 %@:%@",minutes,seconds];
        //        [poperView addSubview:label];
        //
        //        [self.view addSubview:poperView];
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableViewArray count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == 0)
    {
        static NSString *CellIdentifier =@"PhoneIdentifier";
        UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = @"演唱手机里的歌曲伴唱";
        [cell.textLabel setFont:[UIFont systemFontOfSize:15.0]];
        [cell.textLabel setTextColor:[UIColor colorWithRed:208/255.0 green:119/255.0 blue:11/255.0 alpha:1.0]];
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
        [image setFrame:CGRectMake(5, 42, 305, 1)];
        [cell addSubview:image];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    else
    {
        static NSString *CellIdentifier =@"MusicIdentifier";
        SingleSongCell *cell=(SingleSongCell *)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell==nil)
        {
            NSArray *array=[[NSBundle mainBundle] loadNibNamed:@"SingleSongCell" owner:self options:nil];
            cell = [array lastObject];
        }
        
        cell.fileInfo = [[FileModel alloc] init];
        cell.fileInfo = [tableViewArray objectAtIndex:indexPath.row - 1];
        cell.fileInfo.fileName = [NSString stringWithFormat:@"%@ - %@.mp3",cell.fileInfo.mSingerName,cell.fileInfo.mSongName];
        
        cell.lSong.text = cell.fileInfo.mSongName;
        cell.lSinger.text = cell.fileInfo.mSingerName;
        
        NSString *targetPath=[[CommonHelper getMusicFolderPath]stringByAppendingPathComponent: cell.fileInfo.fileName];
        NSString *tempPath = [[CommonHelper getTempFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",cell.fileInfo.fileName]];
        
        if([CommonHelper isExistFile:targetPath])
        {
            
            [cell.btn setTitle:@"演唱" forState:UIControlStateNormal];
            [cell.btn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
            
            [cell.btn setFrame:CGRectMake(265, 9, 50, 25)];
            [cell.btn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if([CommonHelper isExistFile:tempPath])
        {
            [cell.btn addTarget:self action:@selector(cancleDown:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if((![CommonHelper isExistFile:targetPath]) && (![CommonHelper isExistFile:tempPath]))
        {
            cell.fileInfo.isFinish = NO;
            [cell.btn setTitle:@"免费点歌" forState:UIControlStateNormal];
            [cell.btn setImage:[UIImage imageNamed:@"download.png"] forState:UIControlStateNormal];
            [cell.btn setFrame:CGRectMake(235, 9, 80, 25)];
            [cell.btn addTarget:self action:@selector(down:) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

#pragma mark - MPMediaPickerController Delegate
//处理所选取的内容
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    phoneSongs = [[NSMutableArray alloc] initWithCapacity:0];
    for (MPMediaItem *thisItem in mediaItemCollection.items){
        NSURL *itemURL =[thisItem valueForProperty:MPMediaItemPropertyAssetURL];
        NSString *itemTitle =[thisItem valueForProperty:MPMediaItemPropertyTitle];           //获取歌曲标题
        NSString *itemArtist =[thisItem valueForProperty:MPMediaItemPropertyArtist];         //获取歌手姓名
        NSString *albumTitle = [thisItem valueForProperty:MPMediaItemPropertyAlbumTitle];     //获取专辑标题
        MPMediaItemArtwork *itemArtwork =
        [thisItem valueForProperty:MPMediaItemPropertyArtwork];       //为获取专辑封面做铺垫
        
        UIImage *image = [itemArtwork imageWithSize:CGSizeMake(300, 200)];    //专辑图片
        NSLog(@"Item URL = %@", itemURL);
        NSLog(@"Item Title = %@", itemTitle);
        NSLog(@"Item Artist = %@", itemArtist);
        NSLog(@"Item Artwork = %@", itemArtwork);
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
        [dic setObject:itemURL forKey:@"url"];
        [dic setObject:itemTitle forKey:@"title"];
        [dic setObject:itemArtist forKey:@"artist"];
        [dic setObject:albumTitle forKey:@"album"];
        [phoneSongs addObject:dic];
    }
     [musicPlayerCtr setQueueWithItemCollection:mediaItemCollection];
      [musicPlayerCtr play];
       [mediaPickerCtr dismissModalViewControllerAnimated:YES];
}

//处理选中后取消的动作
- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
      [mediaPickerCtr dismissModalViewControllerAnimated:YES];
}

#pragma mark -

//点击取消下载
-(void)down:(UIButton *)sender
{
    NSLog(@"down");
    SingleSongCell * cell = (SingleSongCell *)[[sender superview] superview];
    [appDelegate beginRequest:cell.fileInfo];
    
    if ( cell.fileInfo.isFinish == NO) {
        [sender addTarget:self action:@selector(cancleDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (cell.fileInfo.isFinish == YES){
        [sender setTitle:@"演唱" forState:UIControlStateNormal];
        [cell.btn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [cell.btn setFrame:CGRectMake(265, 9, 50, 25)];
        [sender addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    }
}

//  取消下载
-(void)cancleDown:(UIButton *)sender
{
    NSLog(@"cancleDown");
    SingleSongCell * cell = (SingleSongCell *)[[sender superview] superview];
    [appDelegate cancelRequest:cell.fileInfo];
    
    if (cell.fileInfo.isDownloading == NO &&cell.fileInfo.isFinish == NO) {
        [sender setTitle:@"免费点歌" forState:UIControlStateNormal];
        [cell.btn setImage:[UIImage imageNamed:@"download.png"] forState:UIControlStateNormal];
        [sender setFrame:CGRectMake(235, 9, 80, 25)];
        [sender addTarget:self action:@selector(down:) forControlEvents:UIControlEventTouchUpInside];
    }
}

//演唱
-(void)play:(UIButton *)sender
{
    SingleSongCell * cell = (SingleSongCell *)[[sender superview] superview];
    FileModel *info = cell.fileInfo;
    PlayViewController *playViewController = [[PlayViewController alloc] init];
    playViewController.singType = SING_WITH_MUSICAL;
    playViewController.fileInfo = info;
    [playViewController setModalPresentationStyle:UIModalPresentationFormSheet];
    [playViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [viewController presentModalViewController:playViewController animated:YES];
    playViewController = nil;
    
}


#pragma mark - DownloadDelegate

//方法功能：下载中...
-(void)updateCellProgress:(ASIHTTPRequest *)request FileSize:(NSString*)musicFileSize
{
    NSLog(@"updateCellProgress");
    FileModel *theFileInfo=[request.userInfo objectForKey:@"File"];
    theFileInfo.isFinish = NO;
    [self performSelectorOnMainThread:@selector(updateCellOnMainThread:) withObject:theFileInfo waitUntilDone:YES];
}

//方法功能：完成下载
-(void)finishedDownload:(ASIHTTPRequest *)request
{
    NSLog(@"finishedDownload");
    FileModel *theFileInfo=[request.userInfo objectForKey:@"File"];
    for (id obj in self.tableView.subviews) {
        if([obj isKindOfClass:[SingleSongCell class]]){
            SingleSongCell *cell = (SingleSongCell *)obj;
            if (cell.fileInfo.fileName == theFileInfo.fileName)
            {
                NSLog(@"finishedDownload");
                theFileInfo.isFinish = YES;
                [cell.btn setTitle:@"演唱" forState:UIControlStateNormal];
                [cell.btn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
                [cell.btn setFrame:CGRectMake(265, 9, 50, 25)];
                [cell.btn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    
}

//方法功能：根据下载进度,修改信息
-(void)updateCellOnMainThread:(FileModel *)theFileInfo
{
    for (id obj in self.tableView.subviews) {
        if([obj isKindOfClass:[SingleSongCell class]]){
            SingleSongCell *cell = (SingleSongCell *)obj;
            if (cell.fileInfo.isDownloading == YES) {
                if (cell.fileInfo.fileName == theFileInfo.fileName)
                {
                    NSLog(@"updateCellProgress");
                    int pro = (int)(([CommonHelper getProgress:[CommonHelper getFileSizeNumber:theFileInfo.fileSize] currentSize:[theFileInfo.fileReceivedSize floatValue]])*100);
                    NSString *proStr = [NSString stringWithFormat:@"正在下载...%d%%",pro];
                    [cell.btn setTitle:proStr forState:UIControlStateNormal];
                    [cell.btn setImage:nil forState:UIControlStateNormal];
                    [cell.btn setFrame:CGRectMake(185, 9, 130, 25)];
                }
            }
        }
    }
}


//- (NSString *)downCellPath
//{
//    return [[CommonHelper getDocumentPath]stringByAppendingString:@"downCell.data"];
//}
//- (BOOL)saveChanges
//{
//    return [NSKeyedArchiver archiveRootObject:self.finishedArray
//                                       toFile:[self downCellPath]];
//}
@end
