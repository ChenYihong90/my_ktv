//
//  CommonHelper.m
//  BobMusic
//
//  Created by Angus Bob on 12-11-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonHelper.h"

@implementation CommonHelper

//方法功能：格式化数据，将文件大小转化成M单位或者B单位
+(NSString *)getFileSizeString:(NSString *)size
{
    if([size floatValue]>=1024*1024)        //大于1M，则转化成M单位的字符串
    {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@"##.00M;"];
        return  [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[size floatValue]/1024/1024]];
    }
    else if([size floatValue]>=1024&&[size floatValue]<1024*1024)//不到1M,但是超过了1KB，则转化成KB单位
    {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@"##.00K;"];
        return  [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[size floatValue]/1024]];
    }
    else        //剩下的都是小于1K的，则转化成B单位
    {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@"##.00B;"];
        return  [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[size floatValue]]]; 
    }
}


//方法功能：经文件大小转化成不带单位的数字
+(float)getFileSizeNumber:(NSString *)size
{
    NSInteger indexM=[size rangeOfString:@"M"].location;
    NSInteger indexK=[size rangeOfString:@"K"].location;
    NSInteger indexB=[size rangeOfString:@"B"].location;
    if(indexM<1000)         //是M单位的字符串
    {
        return [[size substringToIndex:indexM] floatValue]*1024*1024;
    }
    else if(indexK<1000)    //是K单位的字符串
    {
        return [[size substringToIndex:indexK] floatValue]*1024;
    }
    else if(indexB<1000)    //是B单位的字符串
    {
        return [[size substringToIndex:indexB] floatValue];
    }
    else                    //没有任何单位的数字字符串
    {
        return [size floatValue];
    }
}

//方法功能：得到文件存储文件夹的路径
+(NSString *)getDocumentPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

//方法功能：得到临时文件存储文件夹的路径
+(NSString *)getTempFolderPath
{
    return [[self getDocumentPath] stringByAppendingPathComponent:@"Temp"];
}

//存放音乐的路径
+(NSString *)getMusicFolderPath
{
    return [[self getDocumentPath] stringByAppendingPathComponent:@"Music"];
}

//存放歌词的路径
+(NSString *)getLrcPath
{
    return [[self getDocumentPath] stringByAppendingPathComponent:@"Lrc"];
}

//存放伴奏音乐的路径
+(NSString *)getAccompanyFolderPath
{
  return [[self getDocumentPath] stringByAppendingPathComponent:@"Accompany"];
}


//存放音乐信息的路径
+(NSString *)getPlistPath
{
    return [[self getDocumentPath] stringByAppendingPathComponent:@"info.plist"];
}

//方法功能：得到录音文件存储文件夹的路径
+(NSString *)getRecorderFolderPath
{
    return [[self getDocumentPath] stringByAppendingPathComponent:@"Recorder"];
}

//存放手机音乐的路径
+(NSString *)getPhoneSongsPath
{
    return [[self getDocumentPath] stringByAppendingPathComponent:@"PhoneSongs"];
}

//方法功能：检查文件名是否存在
+(BOOL)isExistFile:(NSString *)fileName
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:fileName];
}

//方法功能：传入文件总大小和当前大小，得到文件的下载进度
+(float)getProgress:(float)totalSize currentSize:(float)currentSize
{
    return currentSize/totalSize;
}

//方法功能：创建文件
+(BOOL)createFile:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager createFileAtPath:filePath contents:nil attributes:nil];
}

//方法功能：删除文件
+(BOOL)removeFile:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:filePath error:nil];
}

@end