//
//  PhoneSongsViewController.h
//  my_ktv
//
//  Created by User on 13-3-21.
//  Copyright (c) 2013年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

@interface PhoneSongsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
   IBOutlet UITableView *tableView;
    id viewController;
}

@property (nonatomic,strong) NSArray *array;
@end
