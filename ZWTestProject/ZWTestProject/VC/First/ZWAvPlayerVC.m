//
//  ZWAvPlayerVC.m
//  ZWTestProject
//
//  Created by caozhenwei on 17/3/24.
//  Copyright © 2017年 czw. All rights reserved.
//
//  视频播放测试
//

#import "ZWAvPlayerVC.h"
#import "ZWPlayerView.h"

@interface ZWAvPlayerVC () <ZWPlayerViewDelegate>

@property (nonatomic, strong) ZWPlayerView *playerView;

@end

@implementation ZWAvPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setRightNavWithTitle:@"全屏" action:@selector(fullScreenAction)];
    
    NSURL *videoUrl = [NSURL URLWithString:@"http://v.jxvdy.com/sendfile/w5bgP3A8JgiQQo5l0hvoNGE2H16WbN09X-ONHPq3P3C1BISgf7C-qVs6_c8oaw3zKScO78I--b0BGFBRxlpw13sf2e54QA"];
//    NSURL *videoUrl = [NSURL URLWithString:@"http://7xqhmn.media1.z0.glb.clouddn.com/femorning-20161106.mp4"];
    videoUrl = [NSURL URLWithString:@"http://baobab.wdjcdn.com/14525705791193.mp4"];
    ZWPlayerView *playerView = [[ZWPlayerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    playerView.delegate = self;
    playerView.videoURL = videoUrl;
    [playerView configZWPlayerView];
    playerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:playerView];
    self.playerView = playerView;
    
    [self.playerView toOrientation:UIInterfaceOrientationLandscapeLeft];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)fullScreenAction {
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
//    NSNumber *orientationUnknown = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
//    [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
//    
//    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
//    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
//    NSNumber *orientationUnknown = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
//    [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
//    
//    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
//    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}

#pragma mark- ZWPlayerViewDelegate
- (void)ZWPlayerViewDelegateBackButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
