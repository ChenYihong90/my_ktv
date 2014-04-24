//
//  AppDelegate.h
//  my_ktv
//
//  Created by User on 13-2-22.
//  Copyright (c) 2013年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileModel.h"
#import "CommonHelper.h"
#import "ASIHTTPRequest.h"
#import "DownloadDelegate.h"
#import "ASINetworkQueue.h"
#import "OpeningViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,ASIHTTPRequestDelegate,ASIProgressDelegate,OpeningViewControllerDelegate>
{
    BOOL isFirst;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) UIViewController *viewController;
@property (strong, nonatomic) OpeningViewController *openingViewController;   //解说View
@property(nonatomic,strong) NSMutableArray *finishedlist;        //已下载完成的文件列表（文件对象）
@property(nonatomic,strong) NSMutableArray *downinglist;         //正在下载的文件列表(ASIHttpRequest对象)
@property(nonatomic,strong) NSString *musicFileSize;
@property(nonatomic,assign)id<DownloadDelegate> downloadDelegateFirst;
@property(nonatomic,assign)id<DownloadDelegate> downloadDelegateSecond;

-(void)beginRequest:(FileModel *)fileInfo;
-(void)cancelRequest:(FileModel *)fileInfo;

-(void)saveFinishedList;
@end
