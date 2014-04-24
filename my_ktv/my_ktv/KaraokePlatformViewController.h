//
//  KaraokePlatformViewController.h
//  my_ktv
//
//  Created by User on 13-2-25.
//  Copyright (c) 2013年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MusicGetter.h"
#import "FileModel.h"
#import "AppDelegate.h"
#import "DownloadDelegate.h"

@interface KaraokePlatformViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MusicGetterDelegate,UIActionSheetDelegate,MPMediaPickerControllerDelegate,DownloadDelegate>
{
    NSMutableArray  *tableViewArray;  //存放FileModel
    AppDelegate *appDelegate;
    id viewController;
    MPMediaPickerController *mediaPickerCtr;
    MPMusicPlayerController *musicPlayerCtr;
    
    //手机里的伴唱的列表
    NSMutableArray *phoneSongs;
}
@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *downingArray;   //正在下载的cell
@property (nonatomic,strong) NSMutableArray *finishedArray;  //下载完的cell
@property (nonatomic,retain) id viewController;

//- (BOOL)saveChanges;


@end
