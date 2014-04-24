//
//  AppDelegate.m
//  my_ktv
//
//  Created by User on 13-2-22.
//  Copyright (c) 2013年 User. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@implementation AppDelegate
@synthesize window;
@synthesize viewController;
@synthesize openingViewController;
@synthesize downinglist;
@synthesize finishedlist;
@synthesize musicFileSize;
@synthesize downloadDelegateFirst;
@synthesize downloadDelegateSecond;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NSThread sleepForTimeInterval:2];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIViewController *theViewController = [[UIViewController alloc] init];
    self.viewController = theViewController;
    [self.window addSubview:viewController.view];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        OpeningViewController *openController = [[OpeningViewController alloc] initWithNibName:@"OpeningViewController" bundle:nil];
        openController.modalTransitionStyle =UIModalTransitionStyleCoverVertical;
        openController.delegate = self;
        [self.viewController presentModalViewController:openController animated:NO];
    }else{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        MainViewController *mainView = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
        mainView.modalTransitionStyle =UIModalTransitionStyleCoverVertical;
        mainView.view.frame = CGRectMake(0, 20, 320, 460);
        [self.viewController.view addSubview:mainView.view];
    }

    
    [[self window] makeKeyAndVisible];
    self.downinglist = [[NSMutableArray alloc] initWithCapacity:0];
    self.finishedlist = [[NSMutableArray alloc] initWithCapacity:0];
    [self loadFinishedfiles];
    [self deleteTempFile];

    //更改UISegmentedControl样式
    UIImage *segmentSelected =
    [[UIImage imageNamed:@"segcontrol_sel.png"]
     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, -1, 15)];
    UIImage *segmentUnselected =
    [[UIImage imageNamed:@"segcontrol_uns.png"]
     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15,-1, 15)];
    UIImage *segmentSelectedUnselected =
    [UIImage imageNamed:@"segcontrol_sel_uns.png"];
    UIImage *segUnselectedSelected =
    [UIImage imageNamed:@"segcontrol_uns_sel.png"];
    UIImage *segmentUnselectedUnselected =
    [UIImage imageNamed:@"segcontrol_uns_uns.png"];
    
    [[UISegmentedControl appearance] setBackgroundImage:segmentUnselected
                                               forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setBackgroundImage:segmentSelected
                                               forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [[UISegmentedControl appearance] setDividerImage:segmentUnselectedUnselected
                                 forLeftSegmentState:UIControlStateNormal
                                   rightSegmentState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    
    [[UISegmentedControl appearance] setDividerImage:segmentSelectedUnselected
                                 forLeftSegmentState:UIControlStateSelected
                                   rightSegmentState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    
    [[UISegmentedControl appearance] setDividerImage:segUnselectedSelected
                                 forLeftSegmentState:UIControlStateNormal
                                   rightSegmentState:UIControlStateSelected
                                          barMetrics:UIBarMetricsDefault];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

#pragma mark - OpenViewControllerDelegate
-(void)goToMainViewController{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    MainViewController *mainView = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    mainView.modalTransitionStyle =UIModalTransitionStyleCoverVertical;
    mainView.view.frame = CGRectMake(0, 20, 320, 460);
    [self.viewController.view addSubview:mainView.view];
}

#pragma mark - 自定义方法
//方法功能：获取本地资源文件
-(void)loadFinishedfiles
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    NSArray *filelist=[fileManager contentsOfDirectoryAtPath:[CommonHelper getMusicFolderPath] error:&error];
//    NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *documentDir = [CommonHelper getMusicFolderPath];

    
    if(!error)
    {
        NSLog(@"loadFinishedfiles error:%@",[error description]);
    }
    for(NSString *fileName in filelist)
    {
        if([fileName rangeOfString:@"."].location<100)              //出去Temp文件夹
        {
            NSString *path = [documentDir stringByAppendingPathComponent:fileName];
            NSString *lastComponent = [path lastPathComponent];
            NSString *pathLessFilename = [path stringByDeletingLastPathComponent];
            NSString *originalPath = [pathLessFilename stringByAppendingPathComponent: lastComponent];
            NSString *pathExtension = [[path pathExtension] lowercaseString];
            if ([pathExtension isEqualToString:@"mp3"])
            {
                FileModel *finishedFile=[[FileModel alloc] init];
                finishedFile.fileName=fileName;
                NSString *songStr = [[[fileName componentsSeparatedByString:@" - "].lastObject componentsSeparatedByString:@"."] objectAtIndex:0];
                NSString *singerStr = [[fileName componentsSeparatedByString:@" - "] objectAtIndex:0];
                finishedFile.mSongName = songStr;
                finishedFile.mSingerName = singerStr;
                
                NSInteger length=[[fileManager contentsAtPath:[[CommonHelper getMusicFolderPath] stringByAppendingPathComponent:fileName]] length];    //根据文件名获取文件的大小
                
                finishedFile.fileRoute = originalPath;
                finishedFile.fileSize=[CommonHelper getFileSizeString:[NSString stringWithFormat:@"%d",length]];
                
                [self.finishedlist addObject:finishedFile];
                
            }
        }
    }
}
//删除Temp文件
-(void)deleteTempFile
{
    NSError *error;
    NSString *tempPath=[CommonHelper getTempFolderPath];
    
    if ( [[NSFileManager defaultManager] removeItemAtPath:tempPath error:&error]) {
        NSLog(@"删除%@成功",tempPath);
    }
}
//开始下载
-(void)beginRequest:(FileModel *)fileInfo
{
    //如果不存在则创建临时存储目录、音乐存放目录
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:[CommonHelper getTempFolderPath]])
    {
        [fileManager createDirectoryAtPath:[CommonHelper getTempFolderPath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if(![fileManager fileExistsAtPath:[CommonHelper getMusicFolderPath]])
    {
        [fileManager createDirectoryAtPath:[CommonHelper getMusicFolderPath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
//    for(ASIHTTPRequest *tempRequest in self.downinglist)
//    {
//        if([[NSString stringWithFormat:@"%@",tempRequest.url] isEqual:fileInfo.mSongUrl])
//        {
//            [tempRequest clearDelegatesAndCancel];
//            NSLog(@"cancelRequest========");
//            [tempRequest cancel];
//            fileInfo.isDownloading = NO;
//            [self.downinglist removeObject:tempRequest];
//            break;
//        }
//    }
   
    
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:fileInfo.mSongUrl]];
    request.delegate=self;
// 下载后的存放目录
    [request setDownloadDestinationPath:[[CommonHelper getMusicFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileInfo.fileName]]];
//  下载的临时目录
    [request setTemporaryFileDownloadPath:[[CommonHelper getTempFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",fileInfo.fileName]]];
    [request setDownloadProgressDelegate:self];
    [request setAllowResumeForFileDownloads:YES];//支持断点续传
    [request setUserInfo:[NSDictionary dictionaryWithObject:fileInfo forKey:@"File"]];//设置上下文的文件基本信息
    [request setTimeOutSeconds:30.0f];
    [request startAsynchronous];  
    fileInfo.isDownloading = YES;
    [self.downinglist addObject:request];
}

//方法功能：取消下载
-(void)cancelRequest:(FileModel *)fileInfo 
{
    //将temp文件删除，请求删除
    for(ASIHTTPRequest *tempRequest in self.downinglist)
    {
        if([[NSString stringWithFormat:@"%@",tempRequest.url] isEqual:fileInfo.mSongUrl])
        {
          [tempRequest clearDelegatesAndCancel];
            NSLog(@"cancelRequest========");
            [tempRequest cancel];
             fileInfo.isDownloading = NO;
            [self.downinglist removeObject:tempRequest];
            break;
        }
    }
    
        
    NSError *error;
    NSString *tempPath=[[CommonHelper getTempFolderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",fileInfo.fileName]];
    
    NSInteger index=[fileInfo.fileName rangeOfString:@"."].location;
    NSString *name=[fileInfo.fileName substringToIndex:index];
    NSString *rtfPath = [[CommonHelper getTempFolderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.rtf",name]];
    
    if ( [[NSFileManager defaultManager] removeItemAtPath:tempPath error:&error]) {
        NSLog(@"删除%@成功",tempPath);
    }
    if ( [[NSFileManager defaultManager] removeItemAtPath:rtfPath error:&error]) {
        NSLog(@"删除%@成功",rtfPath);
    }
    
}
//保存已下载好的列表FileInfo
-(void)saveFinishedList
{
    //将结果存入文件
    NSString *errorDesc;
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for (FileModel *fileInfo in self.finishedlist) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:fileInfo.mAlbumLink forKey:@"albumLink"];
        [dic setObject:fileInfo.mAlbumName forKey:@"albumName"];
        [dic setObject:fileInfo.mPlaytime forKey:@"playTime"];
        [dic setObject:fileInfo.mSingerName forKey:@"singerName"];
        [dic setObject:fileInfo.mSongName forKey:@"songName"];
        [dic setObject:fileInfo.mSongLrcUrl forKey:@"songLrcUrl"];
        [dic setObject:fileInfo.mSongUrl forKey:@"songUrl"];
        [array addObject:dic];
    }
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:array format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorDesc];
    
    NSString *infoPath = [[CommonHelper getDocumentPath] stringByAppendingPathComponent:@"finish.plist"];
    /*存文件*/
    if (plistData) {
        [plistData writeToFile:infoPath atomically:YES];
    }
    else {
        NSLog(@"%@",errorDesc);
    }
}

#pragma mark - ASIHttpRequest回调委托
//方法功能：出错，如果是等待超时，则继续下载
-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error=[request error];
    NSLog(@"requestFailed!%@",error);
}
//方法功能：获取资源文件大小
-(void)requestReceivedResponseHeaders:(ASIHTTPRequest *)request
{
    NSLog(@"requestReceivedResponseHeaders");
    FileModel *fileInfo=[request.userInfo objectForKey:@"File"];
    fileInfo.fileSize = [CommonHelper getFileSizeString:[[request responseHeaders] objectForKey:@"Content-Length"]];
}

//方法功能：获取已下载资源大小
-(void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    NSLog(@"didReceiveBytes");
    FileModel *fileInfo=[request.userInfo objectForKey:@"File"];
    
    NSData *fileData=[[NSFileManager defaultManager] contentsAtPath:[[CommonHelper getTempFolderPath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",fileInfo.fileName]]];
    NSInteger receivedDataLength=[fileData length];
    fileInfo.fileReceivedSize=[NSString stringWithFormat:@"%d",receivedDataLength];
    
    if([self.downloadDelegateFirst respondsToSelector:@selector(updateCellProgress:FileSize:)])
    {
        if (musicFileSize)
        {
            [self.downloadDelegateFirst updateCellProgress:request FileSize:musicFileSize];
        }
        else
        {
            [self.downloadDelegateFirst updateCellProgress:request FileSize:@"稍等"];
        }
    }
    
    if([self.downloadDelegateSecond respondsToSelector:@selector(updateCellProgress:FileSize:)])
    {
        if (musicFileSize)
        {
            [self.downloadDelegateSecond updateCellProgress:request FileSize:musicFileSize];
        }
        else
        {
            [self.downloadDelegateSecond updateCellProgress:request FileSize:@"稍等"];
        }
        
    }
}

//方法功能：获取下载资源大小
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"##.00M;"];
    musicFileSize = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[[responseHeaders valueForKey:@"Content-Length"] floatValue]/1024/1024]];
    if (musicFileSize) {
        FileModel *fileInfo=[request.userInfo objectForKey:@"File"];
        fileInfo.fileSize = musicFileSize;
    }
}

//方法功能：将正在下载的文件请求ASIHttpRequest从队列里移除，并将其配置文件删除掉,然后向已下载列表里添加该文件对象
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"requestFinished");
    FileModel *fileInfo=(FileModel *)[request.userInfo objectForKey:@"File"];
    NSInteger index=[fileInfo.fileName rangeOfString:@"."].location;
    NSString *name=[fileInfo.fileName substringToIndex:index];;
    NSString *configPath=[[CommonHelper getTempFolderPath] stringByAppendingPathComponent:[name stringByAppendingString:@".rtf"]];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    if([fileManager fileExistsAtPath:configPath])//如果存在临时文件的配置文件
    {
        [fileManager removeItemAtPath:configPath error:&error];
    }
    if(!error)
    {
        NSLog(@"error %@",[error description]);
    }
    
    if([self.downloadDelegateFirst respondsToSelector:@selector(finishedDownload:)])
    {
        [self.downloadDelegateFirst finishedDownload:request];
    }
    if([self.downloadDelegateSecond respondsToSelector:@selector(finishedDownload:)])
    {
        [self.downloadDelegateSecond finishedDownload:request];
    }
    
    [self.downinglist removeObject:request];
    [self.finishedlist addObject:fileInfo];
}
@end
