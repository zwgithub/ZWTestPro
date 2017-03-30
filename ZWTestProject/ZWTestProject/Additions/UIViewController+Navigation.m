//
//  UIViewController+Navigation.m
//  ZWTestProject
//
//  Created by caozhenwei on 17/3/27.
//  Copyright © 2017年 czw. All rights reserved.
//

#import "UIViewController+Navigation.h"

@implementation UIViewController (Navigation)

- (void)setRightNavWithTitle:(NSString *)title action:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    button.frame = CGRectMake(0, 0, 60, 40);
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    //    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -45)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.backgroundColor = [UIColor clearColor];
    [button sizeToFit];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    CGFloat screenScale = [UIScreen mainScreen].scale;
    if (screenScale == 2.0) {
        negativeSpacer.width = (-16+24/screenScale);
    } else if (screenScale == 3.0) {
        negativeSpacer.width = (-20+24/screenScale);
    }
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,backItem,nil];
}


@end
