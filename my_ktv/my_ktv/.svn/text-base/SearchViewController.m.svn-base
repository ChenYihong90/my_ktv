//
//  SearchViewController.m
//  my_ktv
//
//  Created by User on 13-3-12.
//  Copyright (c) 2013年 User. All rights reserved.
//

#import "SearchViewController.h"
#import "SBJson.h"
#import "SearchInfo.h"
#import "SingleSongCell.h"
#import "CommonHelper.h"
#import "PlayViewController.h"


@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize textfield;
@synthesize resultView;
@synthesize sumLabel;
@synthesize tableView;

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
    appDelegate.downloadDelegateFirst=self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.textfield = nil;
    self.resultView = nil;
    self.sumLabel = nil;
    self.tableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 自定义方法

-(IBAction)search:(id)sender
{
    [textfield resignFirstResponder];
    [self searchInfoWithText:textfield.text];
}

-(IBAction)back:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)searchInfoWithText:(NSString *)text
{
    if (text == nil||[text isEqualToString:@""])
	{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"搜索内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
	}
	else
	{
        getter = [[SearchGetter alloc] init];
        getter.delegate = self;
		[getter getSearchResultWithText:text];
	}
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

#pragma mark - SearchResultDelegate
-(void)searchFinishWithResult:(NSString*)result
{
    resultArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSLog(@"YesOrNo:%d",[result hasPrefix:@"searchCallBack"]);
                    
    if ([result rangeOfString:@"songlist:[{"].length <= 0 )
    {
        resultArray = nil;
    }
    else
    {
     NSRange temprange1 = [result rangeOfString:@"songlist:[{"];               //获取 [ 的位置
    NSString *jsonTemp1 = [result substringFromIndex:temprange1.location ];    //开始截取    + temprange1.length
    NSRange temprange2 = [jsonTemp1 rangeOfString:@"}]"];                    //获取 ] 的位置
    NSString *jsonTemp2 = [jsonTemp1 substringToIndex:temprange2.location + 3];       //截取下标range2之前的字符串
    
    NSMutableString * tempjson = [[NSMutableString alloc]initWithString:jsonTemp2];
    
    NSRange rangeOne = NSMakeRange(0, [tempjson length]);
    [tempjson replaceOccurrencesOfString:@"songlist:[" withString:@"{\"songlist\":[" options:NSCaseInsensitiveSearch range:rangeOne];
    NSRange rangeTwo = NSMakeRange(0, [tempjson length]);
    [tempjson replaceOccurrencesOfString:@"{idx:\"" withString:@"{\"idx\":\"" options:NSCaseInsensitiveSearch range:rangeTwo];
    NSRange rangeThree = NSMakeRange(0, [tempjson length]);
    [tempjson replaceOccurrencesOfString:@",song_id:\"" withString:@",\"song_id\":\"" options:NSCaseInsensitiveSearch range:rangeThree];
    NSRange rangeFour = NSMakeRange(0, [tempjson length]);
    [tempjson replaceOccurrencesOfString:@",song_name:\"" withString:@",\"song_name\":\"" options:NSCaseInsensitiveSearch range:rangeFour];
    NSRange rangeFive = NSMakeRange(0, [tempjson length]);
    [tempjson replaceOccurrencesOfString:@",album_name:\"" withString:@",\"album_name\":\"" options:NSCaseInsensitiveSearch range:rangeFive];
    NSRange rangeSix = NSMakeRange(0, [tempjson length]);
    [tempjson replaceOccurrencesOfString:@",singer_name:\"" withString:@",\"singer_name\":\"" options:NSCaseInsensitiveSearch range:rangeSix];
    NSRange rangeSeven = NSMakeRange(0, [tempjson length]);
    [tempjson replaceOccurrencesOfString:@",location:\"" withString:@",\"location\":\"" options:NSCaseInsensitiveSearch range:rangeSeven];
    NSRange rangeEight = NSMakeRange(0, [tempjson length]);
    [tempjson replaceOccurrencesOfString:@",singer_id:\"" withString:@",\"singer_id\":\"" options:NSCaseInsensitiveSearch range:rangeEight];
    NSRange rangeNine = NSMakeRange(0, [tempjson length]);
    [tempjson replaceOccurrencesOfString:@",album_id:\"" withString:@",\"album_id\":\"" options:NSCaseInsensitiveSearch range:rangeNine];
    NSRange rangeTen = NSMakeRange(0, [tempjson length]);
    [tempjson replaceOccurrencesOfString:@",price:\"" withString:@",\"price\":\"" options:NSCaseInsensitiveSearch range:rangeTen];
    
    
    SBJsonParser *parse = [[SBJsonParser alloc]init];
    NSError *error = nil;
    NSMutableDictionary *rootDic = [parse objectWithString:tempjson error:&error];
    NSMutableArray *songArray = [rootDic objectForKey:@"songlist"];
    NSLog(@"rootDic:%@",rootDic);
    
    for(NSMutableDictionary *member in songArray){
        SearchInfo *info = [[SearchInfo alloc] init];
        info.Idx= [member objectForKey:@"idx"];
        info.songId = [member objectForKey:@"song_id"];
        info.songName = [member objectForKey:@"song_name"];
        info.albumName = [member objectForKey:@"album_name"];
        info.singerName = [member objectForKey:@"singer_name"];
        info.location = [member objectForKey:@"location"];
        info.singerId = [member objectForKey:@"singer_id"];
        info.albumId = [member objectForKey:@"album_id"];
        [resultArray addObject:info];
    }
    }
    int sum = [resultArray count];
    sumLabel.text = [[NSString alloc] initWithFormat:@"搜索到%d条信息",sum];
    [self.tableView reloadData];
    

}
#pragma mark - UItableViewDelegate && UITableDataSource
- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    return ;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [resultArray count];
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier =@"SearchIdentifier";
    SingleSongCell *cell=(SingleSongCell *)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
        NSArray *array=[[NSBundle mainBundle] loadNibNamed:@"SingleSongCell" owner:self options:nil];
        cell = [array lastObject];
    }
    SearchInfo *info = [[SearchInfo alloc] init];
    info = [resultArray objectAtIndex:[indexPath row]];
    cell.lSong.text = info.songName;
    cell.lSinger.text = info.singerName;
    
    cell.fileInfo = [[FileModel alloc] init];
    cell.fileInfo.mSingerName = info.songName;
    cell.fileInfo.mSongName = info.singerName;
    cell.fileInfo.fileName = [NSString stringWithFormat:@"%@ - %@.mp3",info.singerName,info.songName];
  cell.fileInfo.mSongUrl = [NSString stringWithFormat:@"http://y1.eoews.com/assets/ringtones/2012/6/29/36195/mx8an3zgp2k4s5aywkr7wkqtqj0dh1vxcvii287a.mp3"];
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
    NSLog(@"===%@,%@",cell.fileInfo.mSingerName,cell.fileInfo.mSongName);
    
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
                [cell.btn addTarget:self action:@selector(cancleDown:) forControlEvents:UIControlEventTouchUpInside];
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

@end
