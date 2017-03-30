//
//  ZWBaseVC.m
//  ZWTestProject
//
//  Created by caozhenwei on 17/3/24.
//  Copyright © 2017年 czw. All rights reserved.
//

#import "ZWBaseVC.h"

@interface ZWBaseVC ()

@end

@implementation ZWBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.navTitleStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end
