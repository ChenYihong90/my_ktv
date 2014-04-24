//
//  SearchGetter.h
//  my_ktv
//
//  Created by User on 13-3-14.
//  Copyright (c) 2013年 User. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchResultDelegate.h"

@interface SearchGetter : NSObject <NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property (nonatomic,strong) NSURLConnection *searchConnection;
@property (nonatomic,strong) NSMutableData *receivedData;
@property (nonatomic)id <SearchResultDelegate> delegate;

-(void)getSearchResultWithText:(NSString *)content;

@end
