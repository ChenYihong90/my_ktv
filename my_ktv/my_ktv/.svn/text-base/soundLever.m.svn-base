//
//  soundLever.m
//  Recorder
//
//  Created by User on 13-3-1.
//  Copyright (c) 2013年 User. All rights reserved.
//

#import "soundLever.h"

@implementation soundLever
@synthesize meterLever,meterLeverArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
    
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 2.0);
    CGContextMoveToPoint(context, 0, 40);
    NSNumber *y;
    float x = 0;
//    CGPoint myLines[20];
    for (int i =0; i<meterLeverArray.count; i++) {
        y = [meterLeverArray objectAtIndex:i];
//        myLines[i] = CGPointMake(x, [y doubleValue]);
        CGContextAddLineToPoint(context, x, [y doubleValue]);
        x = x+20;
    }
    CGContextStrokePath(context);
}

@end
