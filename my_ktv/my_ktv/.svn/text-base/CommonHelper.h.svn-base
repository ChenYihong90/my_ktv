//
//  CommonHelper.h
//  BobMusic
//
//  Created by Angus Bob on 12-11-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonHelper : NSObject

+(NSString *)getFileSizeString:(NSString *)size;    //将文件大小转化成M单位或者B单位
+(float)getFileSizeNumber:(NSString *)size;         //经文件大小转化成不带单位ied数字
+(NSString *)getDocumentPath;                      //得到实际文件存储文件夹的路径
+(NSString *)getTempFolderPath;                     //得到临时文件存储文件夹的路径
+(NSString *)getMusicFolderPath;                     //存放音乐的路径
+(NSString *)getLrcPath;                             //存放歌词的路径
+(NSString *)getAccompanyFolderPath;                //存放伴奏音乐的路径
+(NSString *)getPlistPath;                          //存放音乐信息的路径
+(NSString *)getRecorderFolderPath;                 //存放录音的路径
+(NSString *)getPhoneSongsPath;                     //存放手机音乐的路径
+(BOOL)isExistFile:(NSString *)fileName;            //检查文件名是否存在
+(CGFloat) getProgress:(float)totalSize currentSize:(float)currentSize; //传入文件总大小和当前大小，得到文件的下载进度
+(BOOL)createFile:(NSString *)filePath;             //创建文件
+(BOOL)removeFile:(NSString *)filePath;             //删除文件

@end
