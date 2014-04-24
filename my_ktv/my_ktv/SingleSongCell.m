//
//  SingleSongCell.m
//  my_ktv
//
//  Created by User on 13-2-28.
//  Copyright (c) 2013年 User. All rights reserved.
//

#import "SingleSongCell.h"

@implementation SingleSongCell
@synthesize lSinger;
@synthesize lSong;
@synthesize btn;
@synthesize fileInfo;
//@synthesize songInfo;
#define ButtonFrame CGRectMake(265, 7, 50, 25)

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)willTransitionToState:(UITableViewCellStateMask)state{
    [super willTransitionToState:state];
    UIButton *clickButton = (UIButton *)[self viewWithTag:3];
    switch (state) {
        case 0:
            clickButton.frame = ButtonFrame;
            break;
        case 1:
            clickButton.frame = CGRectMake(ButtonFrame.origin.x - 33, ButtonFrame.origin.y, ButtonFrame.size.width, ButtonFrame.size.height);
            break;
        case 3:
            clickButton.frame = CGRectMake(ButtonFrame.origin.x - 90, ButtonFrame.origin.y, ButtonFrame.size.width, ButtonFrame.size.height);
            break;
        default:
            break;
    }
}

@end
