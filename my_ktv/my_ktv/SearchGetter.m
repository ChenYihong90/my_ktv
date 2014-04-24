//
//  SearchGetter.m
//  my_ktv
//
//  Created by User on 13-3-14.
//  Copyright (c) 2013年 User. All rights reserved.
//

#import "SearchGetter.h"

@implementation SearchGetter
@synthesize searchConnection;
@synthesize receivedData;
@synthesize delegate;

-(void)getSearchResultWithText:(NSString *)content
{
    if (self.searchConnection == nil) {
        self.receivedData=[NSMutableData data];
        
        NSString *str = [NSString stringWithFormat:@"http://shopcgi.qqmusic.qq.com/fcgi-bin/shopsearch.fcg?value=%@|artist=%@&type=qry_song&out=json&page_no=1&page_record_num=20",content,content];
        const char *urlStr = [str UTF8String];
        NSString *url = [NSString stringWithUTF8String:urlStr];
        url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
        self.searchConnection=conn;
        
        if(self.searchConnection == nil)
        {
            NSLog(@"null");
            return;
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];//开启状态栏风火轮
    }
}
#pragma mark - NSURLConnectionDelegate

//方法功能：通过response的响应，判断是否连接存在
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
        NSDictionary *dictionary = [httpResponse allHeaderFields];
        NSLog(@"连接状态：%@",[dictionary valueForKey:@"Connection"]);
    }
}

//方法功能：通过data获得请求后，返回的数据，数据类型NSData
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

//方法功能：返回的错误信息
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.receivedData=nil;
    self.searchConnection=nil;
    NSLog(@"error:%@",error);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];//关闭状态栏风火轮
}

//方法功能：数据请求完毕，这个时候，用法是多线程的时候，通过这个通知，关部子线程
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *string = [[NSString alloc] initWithData:self.receivedData encoding:gbkEncoding];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];//关闭状态栏风火轮
    
    
    NSLog(@"result======: %@",string);
    
    if(self.delegate){
        [self.delegate searchFinishWithResult:string];
    }else {
        NSLog(@"Nil");
    }
    self.receivedData=nil;
    self.searchConnection=nil;
}

@end
