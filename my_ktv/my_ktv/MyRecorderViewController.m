//
//  MyRecorderViewController.m
//  my_ktv
//
//  Created by User on 13-3-7.
//  Copyright (c) 2013年 User. All rights reserved.
//

#import "MyRecorderViewController.h"
#import "CommonHelper.h"
#import "MainViewController.h"
#import "PlayRecordViewController.h"

@interface MyRecorderViewController ()
@property (nonatomic,retain) NSMutableArray *tableDataArray;
@end

@implementation MyRecorderViewController
@synthesize tableDataArray;
@synthesize viewController;
@synthesize tableView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:251/255.0 blue:251/255.0 alpha:1.0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *recorderPath = [CommonHelper getRecorderFolderPath];
    NSError *error = nil;
    
    //判断是否存在录音目录,没有则创建
    if (![CommonHelper isExistFile:recorderPath]) {
        [fileManager createDirectoryAtPath:recorderPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"%@",error);
        }
    }
    
    //判断是否存在录音的配置文件，有的话则提取，没有的话则创建
    NSString *plistPath = [recorderPath stringByAppendingPathComponent:@"recorder.plist"];
    if (![CommonHelper isExistFile:plistPath]) {
        [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
        NSMutableArray *arry = [[NSMutableArray alloc] init];
        [arry writeToFile:plistPath atomically:YES];
    }else{
        tableDataArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
    }
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark - 自定义方法
- (void)reloadDataSource{
    NSString *plistPath = [[CommonHelper getRecorderFolderPath] stringByAppendingPathComponent:@"recorder.plist"];
    tableDataArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
    [tableView reloadData];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 43;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"MyRecorderCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RecorderCell" owner:self options:nil];
        cell = [array lastObject];
    }
    UILabel *songNameLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:2];
    NSDictionary *dic = (NSDictionary *)[tableDataArray objectAtIndex:indexPath.row];
    songNameLabel.text = [dic objectForKey:@"songName"];
    timeLabel.text = [dic objectForKey:@"time"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PlayRecordViewController *playRecordViwCtr = [[PlayRecordViewController alloc] initWithNibName:@"PlayRecordViewController" bundle:nil];
    playRecordViwCtr.recordArray = tableDataArray;//录音的配置文件的数据
    playRecordViwCtr.recordIndex = indexPath.row;//当前检索位置
    MainViewController *mainViewCtr = (MainViewController *)viewController;//主界面
    [mainViewCtr presentModalViewController:playRecordViwCtr animated:YES];
    
}


//返回编辑按钮的名称
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

//点击编辑按钮调用此方法
- (void)tableView:(UITableView *)theTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *dic = [tableDataArray objectAtIndex:indexPath.row];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *recordFileName = [[CommonHelper getRecorderFolderPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",[dic objectForKey:@"recordid"]]];
        if ([CommonHelper isExistFile:recordFileName]) {
            [fileManager removeItemAtPath:recordFileName error:nil];//删除录音文件
        }
        NSString *plistPath = [[CommonHelper getRecorderFolderPath] stringByAppendingPathComponent:@"recorder.plist"];
        [tableDataArray removeObject:dic];//删除配置文件中的数
        for (int i=0;i<tableDataArray.count;i++) {
            NSMutableDictionary *dic = [tableDataArray objectAtIndex:i];
            NSString *recordName = [NSString stringWithFormat:@"%@.wav",[dic objectForKey:@"recordid"] ];
            NSString *newRecordName = [NSString stringWithFormat:@"%d.wav",i];
            NSString *recordPath = [[CommonHelper getRecorderFolderPath] stringByAppendingPathComponent:recordName];
            NSString *newRecordPath = [[CommonHelper getRecorderFolderPath] stringByAppendingPathComponent:newRecordName];
            [fileManager moveItemAtPath:recordPath toPath:newRecordPath error:nil];
            [dic setObject:[NSNumber numberWithInt:i] forKey:@"recordid"];
        }
        [tableDataArray writeToFile:plistPath atomically:YES];//重新配置文件
        [tableView reloadData];
    }
}

@end
