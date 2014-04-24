//
//  MusicGetter.h
//  BobMusic
//
//  Created by Angus Bob on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicListDownloader.h"

//获取歌曲列表的单首歌曲信息

@protocol MusicGetterDelegate <NSObject>

-(void)musicList:(NSMutableArray *)result;

@end


@interface MusicGetter : NSObject<MusicListDownloaderDelegate>
{
    NSMutableArray *musicList;
    
    NSMutableArray *newArray;
    NSMutableArray *oldArray;
}

@property(nonatomic)id<MusicGetterDelegate>delegate;

-(void)getMusicListData:(NSString *)urlString;

@end
