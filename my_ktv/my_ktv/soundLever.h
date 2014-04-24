//
//  soundLever.h
//  Recorder
//
//  Created by User on 13-3-1.
//  Copyright (c) 2013年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface soundLever : UIView{
    double meterLever;
    NSMutableArray *meterLeverArray;
}

@property(nonatomic,assign)double meterLever;
@property (nonatomic,retain) NSMutableArray *meterLeverArray;
@end
