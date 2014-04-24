//
//  OpeningViewController.h
//  my_ktv
//
//  Created by User on 13-3-12.
//  Copyright (c) 2013年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OpeningViewControllerDelegate <NSObject>
- (void)goToMainViewController;
@end

@interface OpeningViewController : UIViewController<UIScrollViewDelegate> {
	UIScrollView *imagescrollView;
	UIPageControl *pageControl;
    BOOL over;
}
@property(nonatomic,retain) IBOutlet UIScrollView *imagescrollView;
@property(nonatomic,retain) IBOutlet UIPageControl *pageControl;
@property(nonatomic,retain) id<OpeningViewControllerDelegate> delegate;

@end
