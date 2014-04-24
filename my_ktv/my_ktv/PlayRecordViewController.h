//
//  PlayRecordViewController.h
//  my_ktv
//
//  Created by User on 13-3-8.
//  Copyright (c) 2013年 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
//#import "LrcDown.h"

@interface PlayRecordViewController : UIViewController<AVAudioPlayerDelegate>{
//    LrcDown *lrcDown;
//    int index;

}
@property (nonatomic,retain) NSArray *recordArray;
@property (nonatomic,assign) int recordIndex;
//@property (strong,nonatomic) IBOutlet UILabel *lSelectedLrcLabel;   //当前歌词
//@property (strong,nonatomic) IBOutlet UILabel *lrcLabel;           //歌词
//@property (strong,nonatomic) IBOutlet UILabel *lSecondLrcLabel;     //第二行歌词
@end
