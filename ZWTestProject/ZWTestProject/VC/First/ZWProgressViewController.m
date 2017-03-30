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
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 150, self.view.width, 150)];
    progressView.progressViewStyle = UIProgressViewStyleDefault;
    progressView.progress = 0.5;
    progressView.trackTintColor=[UIColor grayColor];
    progressView.progressTintColor=[UIColor redColor];
    progressView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:progressView];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 200, self.view.width, 50)];
    slider.backgroundColor = [UIColor greenColor];
    [self.view addSubview:slider];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];

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
