//
//  ZWProgressView.h
//  ZWTestProject
//
//  Created by caozhenwei on 17/4/5.
//  Copyright © 2017年 czw. All rights reserved.
//

#import "ZWBaseView.h"

@interface ZWProgressView : ZWBaseView

@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, assign) BOOL isSlidingFlag;

- (void)setCache:(CGFloat)cache;

- (void)setCurrentTime:(CGFloat)value;

@end
