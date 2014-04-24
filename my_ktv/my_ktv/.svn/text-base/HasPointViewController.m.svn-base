//
//  HasPointViewController.m
//  my_ktv
//
//  Created by User on 13-3-6.
//  Copyright (c) 2013年 User. All rights reserved.
//

#import "HasPointViewController.h"
#import "SingleSongCell.h"
#import "PlayViewController.h"


@interface HasPointViewController ()

@end

@implementation HasPointViewController
@synthesize tableView;
@synthesize downinglist;
@synthesize finishedlist;
@synthesize viewController;

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
}

-(void)viewWillAppear:(BOOL)animated
{
    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.downloadDelegateSecond=self;
    
    if (self.downinglist == nil) {
        self.downinglist = [[NSMutableArray alloc] initWithCapacity:0];
    }
    if (self.finishedlist == nil) {
        self.finishedlist = [[NSMutableArray alloc] initWithCapacity:0];
    }
    self.downinglist = appDelegate.downinglist;
    self.finishedlist = appDelegate.finishedlist;
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - 自定义方法

-(void)resetCell{
    self.downinglist = appDelegate.downinglist;
    self.finishedlist = appDelegate.finishedlist;
    [self.tableView reloadData];
}

#pragma mark - UItableViewDelegate && UITableDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //听听别人怎么唱
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([self.downinglist count]+[self.finishedlist count]);
}

//先排列正在下载的，后排列下载完成的
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"MusicIdentifier";
    SingleSongCell *cell=(SingleSongCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
        NSArray *array=[[NSBundle mainBundle] loadNibNamed:@"SingleSongCell" owner:self options:nil];
        cell = [array lastObject];
    }
    //正在下载的
    if ([indexPath row] < [self.downinglist count]) {
        ASIHTTPRequest *theRequest=[self.downinglist objectAtIndex:indexPath.row];
        FileModel *theFileInfo=[theRequest.userInfo objectForKey:@"File"];
        cell.fileInfo = theFileInfo;
        cell.lSong.text = theFileInfo.mSongName;
        cell.lSinger.text = theFileInfo.mSingerName;
        int pro = (int)(([CommonHelper getProgress:[CommonHelper getFileSizeNumber:theFileInfo.fileSize] currentSize:[theFileInfo.fileReceivedSize floatValue]])*100);
        NSString *proStr = [NSString stringWithFormat:@"正在下载...%d%%",pro];
        [cell.btn setFrame:CGRectMake(165, 9, 150, 25)];
        [cell.btn setTitle:proStr forState:UIControlStateNormal];
        [cell.btn addTarget:self action:@selector(cancleDown:) forControlEvents:UIControlEventTouchUpInside];
         [cell.contentView addSubview:cell.btn];
        return cell;
    }
    //下载完成
    else if ([indexPath row] < ([self.downinglist count]+[self.finishedlist count]))
    {
        FileModel *theFileInfo=[self.finishedlist objectAtIndex:(indexPath.row -[self.downinglist count])];
        cell.fileInfo = theFileInfo;
        cell.lSong.text = theFileInfo.mSongName;
        cell.lSinger.text = theFileInfo.mSingerName;
        
        NSLog(@"====%@,%@,%@",theFileInfo.mSongUrl,theFileInfo.mSongLrcUrl,theFileInfo.mSongName);
        
        [cell.btn setTitle:@"演唱" forState:UIControlStateNormal];
         [cell.btn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [cell.btn setFrame:CGRectMake(265, 9, 50, 25)];
        [cell.btn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:cell.btn];
        
        return cell;
    }
    return nil;
}

//是否可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//点击返回编辑类型
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}


//返回编辑按钮的名称
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    SingleSongCell *cell = (SingleSongCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    CGRect r = cell.btn.frame;
    cell.btn.frame = CGRectMake(r.origin.x-55, r.origin.y, r.size.width,r.size.height);
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


//点击编辑按钮调用此方法
- (void)tableView:(UITableView *)theTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([indexPath row] < [self.downinglist count])
        {
            ASIHTTPRequest *theRequest=[self.downinglist objectAtIndex:indexPath.row];
            FileModel *theFileInfo=[theRequest.userInfo objectForKey:@"File"];
            [appDelegate cancelRequest:theFileInfo];
            [self.tableView reloadData];
        }
        else
        {
            FileModel *theFileInfo=[self.finishedlist objectAtIndex:(indexPath.row -[self.downinglist count])];
            NSError *error;
            NSString *filePath= [[CommonHelper getMusicFolderPath] stringByAppendingPathComponent:theFileInfo.fileName];
            if ( [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error]) {
                NSLog(@"删除%@成功",filePath);
            }
            [self.finishedlist removeObjectAtIndex:[indexPath row]-[self.downinglist count]];
            [self.tableView reloadData];
        }
    }
} 

#pragma -
//  取消下载
-(void)cancleDown:(UIButton *)sender
{
    NSLog(@"cancleDown");
    SingleSongCell * cell = (SingleSongCell *)[[sender superview] superview];
    [appDelegate cancelRequest:cell.fileInfo];
    [self.tableView reloadData];
    
    if (cell.fileInfo.isDownloading == NO &&cell.fileInfo.isFinish == NO) {
        [sender setTitle:@"免费点歌" forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"download.png"] forState:UIControlStateNormal];
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
                [tableView reloadData];
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
                    [cell.btn setFrame:CGRectMake(185, 9, 130, 25)];
                    [cell.btn addTarget:self action:@selector(cancleDown:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
    }
}

@end
