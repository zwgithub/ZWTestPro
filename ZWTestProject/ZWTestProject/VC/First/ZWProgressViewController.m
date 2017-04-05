//
//  ZWProgressViewController.m
//  ZWTestProject
//
//  Created by caozhenwei on 17/3/27.
//  Copyright © 2017年 czw. All rights reserved.
//

#import "ZWProgressViewController.h"

@interface ZWProgressViewController ()

@end

@implementation ZWProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(32, 209, self.view.width - 63, 8)];
    progressView.progressViewStyle = UIProgressViewStyleDefault;
    progressView.progress = 1;
//    progressView.trackTintColor=[UIColor grayColor];
    progressView.progressTintColor=[UIColor darkGrayColor];
    [self.view addSubview:progressView];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(30, 200, self.view.width - 60, 20)];
    slider.backgroundColor = [UIColor clearColor];
    slider.value = 0.2;
    slider.minimumTrackTintColor = [UIColor greenColor];
    slider.maximumTrackTintColor = [UIColor clearColor];
    [self.view addSubview:slider];
}

- (void)onDeviceOrientationChange {
    NSLog(@"onDeviceOrientationChange");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
