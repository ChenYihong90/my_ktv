//
//  OpeningViewController.m
//  my_ktv
//
//  Created by User on 13-3-12.
//  Copyright (c) 2013年 User. All rights reserved.
//

#import "OpeningViewController.h"

#define PICLENGTH 320

@interface OpeningViewController ()

@end

@implementation OpeningViewController
@synthesize imagescrollView;
@synthesize pageControl;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    imagescrollView.showsHorizontalScrollIndicator = FALSE;
	imagescrollView.pagingEnabled=YES;
	imagescrollView.delegate=self;
	pageControl.enabled=FALSE;
	
	pageControl.numberOfPages = 4;
	pageControl.currentPage = 0;
	
	UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(0 * PICLENGTH, 0, PICLENGTH, 480)];
	[img setImage:[UIImage imageNamed:@"view1.jpg"]];
	[imagescrollView addSubview:img];
    
	UIImageView *img2=[[UIImageView alloc] initWithFrame:CGRectMake(1 * PICLENGTH, 0, PICLENGTH, 480)];
	[img2 setImage:[UIImage imageNamed:@"view2.jpg"]];
	[imagescrollView addSubview:img2];
	
	UIImageView *img3=[[UIImageView alloc] initWithFrame:CGRectMake(2 * PICLENGTH, 0, PICLENGTH, 480)];
	[img3 setImage:[UIImage imageNamed:@"view3.jpg"]];
	[imagescrollView addSubview:img3];
	
    UIImageView *img4=[[UIImageView alloc] initWithFrame:CGRectMake(3 * PICLENGTH, 0, PICLENGTH, 480)];
	[img4 setImage:[UIImage imageNamed:@"view4.jpg"]];
	[imagescrollView addSubview:img4];
    
	UIView *v4 = [[UIView alloc] initWithFrame:CGRectMake(4 * PICLENGTH, 0, PICLENGTH, 480)];
	v4.backgroundColor = [UIColor clearColor];
	[imagescrollView addSubview:v4];
	
	[imagescrollView setContentOffset:CGPointMake(0,0) animated:NO];
	[imagescrollView setContentSize:CGSizeMake(PICLENGTH*5, 0)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.imagescrollView = nil;
    self.pageControl = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	if (imagescrollView == scrollView)
	{
		if (over)
		{
			[self dismissModalViewControllerAnimated:YES];
            if ([delegate respondsToSelector:@selector(goToMainViewController)]) {
                [delegate goToMainViewController];
            }
        }
		else
		{
			pageControl.currentPage=scrollView.contentOffset.x/PICLENGTH;
		}
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (scrollView.contentOffset.x>PICLENGTH*3+50)
	{
		over=YES;
	}
}

@end
