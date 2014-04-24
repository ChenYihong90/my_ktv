//
//  HasPointViewController.h
//  my_ktv
//
//  Created by User on 13-3-6.
//  Copyright (c) 2013年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DownloadDelegate.h"

@interface HasPointViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,DownloadDelegate>
{
    AppDelegate *appDelegate;
      id viewController;
}

@property (nonatomic,strong)IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *finishedlist;        //已下载完成的文件列表（文件对象）
@property(nonatomic,strong) NSMutableArray *downinglist;          //正在下载的文件列表(ASIHttpRequest对象)
@property (nonatomic,retain) id viewController;

-(void)resetCell;

@end

