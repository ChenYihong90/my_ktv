//
//  MusicListDownloader.h
//  BobMusic
//
//  Created by Angus Bob on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol MusicListDownloaderDelegate <NSObject>
-(void)MusicdownloadFinishedWithResult:(NSString*)result;
@end

@interface MusicListDownloader : NSObject<NSURLConnectionDelegate>{
    NSMutableData *receivedData;
    NSURLConnection *downloadConnection; 
    id<MusicListDownloaderDelegate> delegate;
}

@property(strong,nonatomic)NSMutableData *receivedData;         //接收到的数据
@property(strong,nonatomic)NSURLConnection *downloadConnection; //下载连接
@property(strong,nonatomic)id<MusicListDownloaderDelegate> delegate;   //委托

-(id)init;
-(void)startDownloadWithURLString:(NSString *)urlString;
-(void)cancelDownload;

@end
