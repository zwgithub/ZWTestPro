//
//  ZWProgressView.m
//  ZWTestProject
//
//  Created by caozhenwei on 17/4/5.
//  Copyright © 2017年 czw. All rights reserved.
//

#import "ZWProgressView.h"

@interface ZWProgressView ()

@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation ZWProgressView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.height = 20;
        UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(2, 9, self.width - 3, 8)];
        progressView.progressViewStyle = UIProgressViewStyleDefault;
        progressView.progress = 0;
        progressView.progressTintColor=[UIColor darkGrayColor];
        [self addSubview:progressView];
        self.progressView = progressView;
        
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, self.width, 20)];
        slider.backgroundColor = [UIColor clearColor];
        slider.minimumTrackTintColor = [UIColor greenColor];
        slider.maximumTrackTintColor = [UIColor clearColor];
        [self addSubview:slider];
        self.slider = slider;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.progressView.frame = CGRectMake(2, 9, self.width - 3, 8);
    self.slider.frame = CGRectMake(0, 0, self.width, 20);
}

- (void)setCache:(CGFloat)cache {
    self.progressView.progress = cache;
}

- (void)setCurrentTime:(CGFloat)value {
    if (self.isSlidingFlag == YES) {
        return;
    }
    self.slider.value = value;
}

@end
