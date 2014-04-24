//
//  MainViewController.m
//  my_ktv
//
//  Created by User on 13-2-22.
//  Copyright (c) 2013年 User. All rights reserved.
//

#import "MainViewController.h"
#import "PlayViewController.h"
#import "SearchViewController.h"


@interface MainViewController ()

@end

@implementation MainViewController
@synthesize theView;
@synthesize segmentedController;

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
    	self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:251/255.0 blue:251/255.0 alpha:1.0];
    //设置导航条
//    navigationBar.topLineColor = [UIColor colorWithHex:0xFF3300];
//    navigationBar.gradientStartColor = [UIColor colorWithHex:0xFF3300];
//    navigationBar.gradientEndColor = [UIColor colorWithHex:0xFF3300];
//    navigationBar.bottomLineColor = [UIColor redColor];
//    navigationBar.tintColor = navigationBar.gradientEndColor;
//    navigationBar.roundedCornerRadius = 5;
//    navigationBar.shadowOpacity = 0.5;
    navigationBar.layer.shadowRadius = 5.0;
    navigationBar.layer.shadowOpacity = 0.8;

    downBar.layer.shadowOpacity = 0.3;
    downBar.layer.shadowRadius = 1;
    
    //设置选择器
    self.segmentedController.selectedSegmentIndex = 0;
    
    hasPoint = [[HasPointViewController alloc] initWithNibName:@"HasPointViewController" bundle:nil];
    hasPoint.viewController = self;
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"all_bag.png"]];
    hasPoint.tableView.backgroundView = view;
    hasPoint.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    hasPoint.tableView.backgroundColor = [UIColor clearColor];
    [self.theView addSubview:hasPoint.view];
    
    myRecorder = [[MyRecorderViewController alloc] initWithNibName:@"MyRecorderViewController" bundle:nil];
    [self.theView addSubview:myRecorder.view];
    myRecorder.viewController = self;
    
    //默认进入“点歌台”
    if(self.segmentedController.selectedSegmentIndex == 0) {
       platForm = [[KaraokePlatformViewController alloc] initWithNibName:@"KaraokePlatformViewController" bundle:nil];
        platForm.viewController = self;
        [self.theView addSubview:platForm.view];
        
        //隐藏编辑按钮
        editorButton.hidden = YES;
    }
}

- (void)viewDidUnload
{
    editorButton = nil;
    navigationBar = nil;
    [super viewDidUnload];
    self.theView = nil;
    self.segmentedController = nil;
}


#pragma mark - 自定义方法

//点击UISegmentedControl方法
-(IBAction)changeSegmentedController:(UISegmentedControl *)segmentedC
{
    switch (segmentedC.selectedSegmentIndex) {
        case 0:
            platForm.view.hidden = NO;
            hasPoint.view.hidden = YES;
            myRecorder.view.hidden = YES;
            editorButton.hidden = YES;
            [hasPoint.tableView reloadData];
            break;
        case 1:
        {
            platForm.view.hidden = YES;
            hasPoint.view.hidden = NO;
            myRecorder.view.hidden = YES;
            hasPoint.tableView.editing = NO;
            editorButton.hidden = NO;
            editorButton.selected = NO;
            [hasPoint resetCell];
        }
            break;
        case 2:
        {
            platForm.view.hidden = YES;
            hasPoint.view.hidden = YES;
            myRecorder.view.hidden = NO;
            myRecorder.tableView.editing = NO;
            [myRecorder reloadDataSource];
            editorButton.hidden = NO;
            editorButton.selected = NO;
        }
            break;
        default:
            break;
    }
}

//搜索
-(IBAction)search:(id)sender
{
    SearchViewController *searchViewCtr = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    [self presentModalViewController:searchViewCtr animated:YES];
    
}

//点击清唱按钮方法
- (IBAction)clearSing:(id)sender {
    PlayViewController *playViewCtr = [[PlayViewController alloc] initWithNibName:@"PlayViewController" bundle:nil];
    playViewCtr.singType = SING_WITHOUT_MAKEUP;
    playViewCtr.viewController = myRecorder;
    [self presentModalViewController:playViewCtr animated:YES];
}

//点击编辑按钮方法
- (IBAction)editor:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.selected) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
    switch (segmentedController.selectedSegmentIndex) {
        case 1:
            hasPoint.tableView.editing = btn.selected;
            break;
        case 2:
            myRecorder.tableView.editing = btn.selected;
            break;
        default:
            break;
    }
}

@end
