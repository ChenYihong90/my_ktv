//
//  MusicGetter.m
//  BobMusic
//
//  Created by Angus Bob on 12-10-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MusicGetter.h"
#import "SBJson.h"
#import "FileModel.h"
#import "SongInfo.h"
#import "CommonHelper.h"

@implementation MusicGetter
@synthesize delegate;


//方法功能：设置获取音乐排行榜的链接
-(void)getMusicListData:(NSString *)urlString
{
    MusicListDownloader *downloader=[[MusicListDownloader alloc]init];
    downloader.delegate=self;
    [downloader startDownloadWithURLString:urlString];
}

#pragma - MusicListDownloaderDelegate
//方法功能：获取返回json，并解析
-(void)MusicdownloadFinishedWithResult:(NSString*)result
{
    newArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSRange temprange1 = [result rangeOfString:@"songlist:[{"];                 //获取 [ 的位置
    NSString *jsonTemp1 = [result substringFromIndex:temprange1.location ];    //开始截取    + temprange1.length
    NSRange temprange2 = [jsonTemp1 rangeOfString:@"}]"];                    //获取 ] 的位置
    NSString *jsonTemp2 = [jsonTemp1 substringToIndex:temprange2.location + 3];       //截取下标range2之前的字符串
    
    NSMutableString * tempjson = [[NSMutableString alloc]initWithString:jsonTemp2];
    NSRange rangeOne = NSMakeRange(0, [tempjson length]);
    [tempjson replaceOccurrencesOfString:@"songlist:[" withString:@"{\"songlist\":[" options:NSCaseInsensitiveSearch range:rangeOne];
    NSRange rangeThree = NSMakeRange(0, [tempjson length]);
    
    [tempjson replaceOccurrencesOfString:@"{id:\"" withString:@"{\"id\":\"" options:NSCaseInsensitiveSearch range:rangeThree];
    NSRange rangeFour = NSMakeRange(0, [tempjson length]);
    [tempjson replaceOccurrencesOfString:@", type:" withString:@",\"type\":\"" options:NSCaseInsensitiveSearch range:rangeFour];
    NSRange rangeFive = NSMakeRange(0, [tempjson length]);
    [tempjson replaceOccurrencesOfString:@", url:" withString:@"\",\"url\":" options:NSCaseInsensitiveSearch range:rangeFive];
    NSRange rangeSix = NSMakeRange(0, [tempjson length]);
    [tempjson replaceOccurrencesOfString:@", songName:\"" withString:@",\"songName\":\"" options:NSCaseInsensitiveSearch range:rangeSix];
    NSRange rangeSeven = NSMakeRange(0, [tempjson length]);
    [tempjson replaceOccurrencesOfString:@"\", singerId:" withString:@"\",\"singerId\":" options:NSCaseInsensitiveSearch range:rangeSeven];
    NSRange rangeEight = NSMakeRange(0, [tempjson length]);
    [tempjson replaceOccurrencesOfString:@"\", singerName:\"" withString:@"\",\"singerName\":\"" options:NSCaseInsensitiveSearch range:rangeEight];
    NSRange rangeNine = NSMakeRange(0, [tempjson length]);
    [tempjson replaceOccurrencesOfString:@"\", albumId:\"" withString:@"\",\"albumId\":\"" options:NSCaseInsensitiveSearch range:rangeNine];
    NSRange rangeTen = NSMakeRange(0, [tempjson length]);
    [tempjson replaceOccurrencesOfString:@"\", albumName:\"" withString:@"\",\"albumName\":\"" options:NSCaseInsensitiveSearch range:rangeTen];
    NSRange rangeEleven = NSMakeRange(0, [tempjson length]);
    [tempjson replaceOccurrencesOfString:@"\", albumLink:\"" withString:@"\",\"albumLink\":\"" options:NSCaseInsensitiveSearch range:rangeEleven];
    NSRange rangeTwelve = NSMakeRange(0, [tempjson length]);
    [tempjson replaceOccurrencesOfString:@"\", playtime:\"" withString:@"\",\"playtime\":\"" options:NSCaseInsensitiveSearch range:rangeTwelve];
    
    NSMutableArray *resultArray = [NSMutableArray array];
    SBJsonParser *parse = [[SBJsonParser alloc]init];
    NSError *error = nil;
    
    NSMutableDictionary *rootDic = [parse objectWithString:tempjson error:&error];
    NSMutableArray *songArray = [rootDic objectForKey:@"songlist"];
    
    for(NSMutableDictionary *member in songArray){
        FileModel *MusicInfo = [[FileModel alloc]init];
        NSString *tempId = [member objectForKey:@"id"];
        NSString *tempSongName = [member objectForKey:@"songName"];
        NSString *tempSingerName = [member objectForKey:@"singerName"];
        NSString *tempAlbumId = [member objectForKey:@"albumId"];
        NSString *tempPlaytime = [member objectForKey:@"playtime"];
        NSString *tempAlbumName = [member objectForKey:@"albumName"];
        
        MusicInfo.mSongName = tempSongName;       //歌曲名称
        MusicInfo.mSingerName = tempSingerName;   //歌手
         MusicInfo.mPlaytime = tempPlaytime;       //时长
         MusicInfo.mAlbumName = tempAlbumName;     //专辑名称
        
        NSString *songIdTemp;
        if (tempId.length < 7) {
            NSInteger songLength = tempId.length;
            if (songLength == 6) {
                songIdTemp = [NSString stringWithFormat:@"0%@",tempId];
            }else if (songLength == 5) {
                songIdTemp = [NSString stringWithFormat:@"00%@",tempId];
            }else if (songLength == 4) {
                songIdTemp = [NSString stringWithFormat:@"000%@",tempId];
            }else if (songLength == 3) {
                songIdTemp = [NSString stringWithFormat:@"0000%@",tempId];
            }else if (songLength == 2) {
                songIdTemp = [NSString stringWithFormat:@"00000%@",tempId];
            }
        }else {
            songIdTemp = tempId;
        }
        //        NSString *mSongUrlTemp = [NSString stringWithFormat:@"http://stream1%@.music..com/3%@.mp3",tempType,songIdTemp];
        
        NSString *mSongUrlTemp = [NSString stringWithFormat:@"http://y1.eoews.com/assets/ringtones/2012/6/29/36195/mx8an3zgp2k4s5aywkr7wkqtqj0dh1vxcvii287a.mp3"];
        
        MusicInfo.mSongUrl = mSongUrlTemp;        //歌曲链接
        
        NSInteger iTemptempAlbumId = [tempAlbumId integerValue];
        NSInteger iTempAlbum = fmod(iTemptempAlbumId,100);
        NSString *itempAlbumFmod = [NSString stringWithFormat:@"%d",iTempAlbum];
        NSString *mAlbumLinkTemp = [NSString stringWithFormat:@"http://imgcache.qq.com/music/photo/album/%@/albumpic_%@_0.jpg",itempAlbumFmod,tempAlbumId];
        MusicInfo.mAlbumLink = mAlbumLinkTemp;    //专辑封面链接
        
        
        NSInteger iTemptsongIdTemp = [songIdTemp integerValue];
        NSInteger iTempsong = fmod(iTemptsongIdTemp,100);
        NSString *itempsongFmod = [NSString stringWithFormat:@"%d",iTempsong];
        NSString *mSongLrcUrlTemp = [[NSString alloc]initWithFormat:@"http://music.qq.com/miniportal/static/lyric/%@/%@.xml",itempsongFmod,songIdTemp];
        MusicInfo.mSongLrcUrl = mSongLrcUrlTemp;  //歌词链接
       
       
        [resultArray addObject:MusicInfo];
        
//        SongInfo *info = [[SongInfo alloc] init];
//        info.mAlbumLink = mAlbumLinkTemp;
//        info.mAlbumName = tempAlbumName;
//        info.mPlaytime = tempPlaytime;
//        info.mSingerName = tempSingerName;
//        info.mSongName = tempSongName;
//        info.mSongLrcUrl = mSongLrcUrlTemp;
//        info.mSongUrl = mSongUrlTemp;
//        info.songId = tempId;
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:mAlbumLinkTemp forKey:@"albumLink"];
        [dic setObject:tempAlbumName forKey:@"albumName"];
        [dic setObject:tempPlaytime forKey:@"playTime"];
        [dic setObject:tempSingerName forKey:@"singerName"];
        [dic setObject:tempSongName forKey:@"songName"];
        [dic setObject:mSongLrcUrlTemp forKey:@"songLrcUrl"];
        [dic setObject:mSongUrlTemp forKey:@"songUrl"];
        [dic setObject:tempId forKey:@"id"];
    
        [newArray addObject:dic];
    }
    if(delegate){
        musicList= resultArray;
        [delegate musicList:musicList];
    }
    
    //将结果存入文件
    NSString *errorDesc;
     NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:newArray format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorDesc];

    NSString *infoPath = [CommonHelper getPlistPath];
    /*存文件*/
    if (plistData) {
        [plistData writeToFile:infoPath atomically:YES];
    }
    else {
        NSLog(@"%@",errorDesc);
    }
    
}
@end
