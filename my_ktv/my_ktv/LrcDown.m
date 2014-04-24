//
//  LrcDown.m
//  my_ktv
//
//  Created by User on 13-3-4.
//  Copyright (c) 2013年 User. All rights reserved.
//

#import "LrcDown.h"
#import "CommonHelper.h"

@implementation LrcDown
@synthesize lrcConnection;
@synthesize lrcDownload;
@synthesize musicLrcArray;
@synthesize lrc;
@synthesize lrcName;

//开始下载
-(void)startLrc:(NSString *)url{
    self.lrcDownload = [NSMutableData data];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] delegate:self];
    self.lrcConnection = conn;
    conn = nil;
}
//方法功能：歌词键值(存储的是时间)
- (NSMutableArray *)lrcKeys
{
    if (self.musicLrcArray == nil) {
        self.musicLrcArray = [NSMutableArray array];
    }
    if ([self.musicLrcArray count]<1) {
        NSArray __autoreleasing *ks = [[lrc.lyric allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 floatValue] > [obj2 floatValue];
        }];
        if (ks)
        {
            [self.musicLrcArray addObjectsFromArray:ks];
        }
    }
    return self.musicLrcArray;
}

-(void)lrcdownloadFinishedWithResult:(NSString*)result
{
    self.lrc = [JSLrcParser lrcValue:result];
    [self lrcKeys];

    
    //写入文件
    NSError *error;
     NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:[CommonHelper getLrcPath]])
    {
        [fileManager createDirectoryAtPath:[CommonHelper getLrcPath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [result writeToFile:[[CommonHelper getLrcPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",lrcName]] atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"error:%@",error);
    }

}

#pragma mark - NSURLConnectionDelegate
//方法功能：每次成功请求到数据后将调下此方法
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [lrcDownload appendData:data];
}

//方法功能：下载错误
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    lrcDownload = nil;
    [lrcConnection cancel];
    lrcConnection = nil;
}

//方法功能：下载成功
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *songLrcTemp = [[NSString alloc] initWithData:lrcDownload encoding:gbkEncoding];
    if (songLrcTemp) {
        NSRange temprange1 = [songLrcTemp rangeOfString:@"[CDATA["];
        if (temprange1.length != 0)
        {
            NSString *jsonTemp1 = [songLrcTemp substringFromIndex:temprange1.location + temprange1.length];
            NSRange temprange2 = [jsonTemp1 rangeOfString:@"]]"];
            NSString *jsonTemp2 = [jsonTemp1 substringToIndex:temprange2.location ];
            NSLog(@"歌词:%@",jsonTemp2);
            
            NSRange isGarbledTemp = [jsonTemp2 rangeOfString:@"&#"];
            
            if (isGarbledTemp.length != 0)
            {
                [self lrcdownloadFinishedWithResult:[[NSString alloc]initWithFormat:@"歌词暂无"]];
            }
            else
            {
                [self lrcdownloadFinishedWithResult:[[NSString alloc]initWithString:jsonTemp2]];
            }
          
        }
        else
        {
            [self lrcdownloadFinishedWithResult:[[NSString alloc]initWithFormat:@"歌词暂无"]];
        }
    }
    self.lrcDownload = nil;
    connection = nil;
    
}

@end
