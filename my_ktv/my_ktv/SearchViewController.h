//
//  SearchViewController.h
//  my_ktv
//
//  Created by User on 13-3-12.
//  Copyright (c) 2013年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultDelegate.h"
#import "SearchGetter.h"
#import "AppDelegate.h"

@interface SearchViewController : UIViewController<UITextFieldDelegate,SearchResultDelegate,UITableViewDelegate,UITableViewDataSource,DownloadDelegate>
{
    UITextField *textfield;
    UIView *resultView;
    SearchGetter *getter;
    NSMutableArray *resultArray;
        AppDelegate *appDelegate;
    id viewController;
}

@property (nonatomic,strong) IBOutlet UITextField *textfield;
@property (nonatomic,strong) IBOutlet UIView *resultView;
@property (nonatomic,strong) IBOutlet UILabel *sumLabel;
@property (nonatomic,strong) IBOutlet UITableView *tableView;
-(IBAction)search:(id)sender;

@end
