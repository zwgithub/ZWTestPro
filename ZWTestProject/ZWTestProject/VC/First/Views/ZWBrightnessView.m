//
//  ZWBrightnessView.m
//  ZWTestProject
//
//  Created by caozhenwei on 17/4/1.
//  Copyright © 2017年 czw. All rights reserved.
//

#import "ZWBrightnessView.h"

@interface ZWBrightnessView ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *brightnessImageView;
@property (nonatomic, strong) UIView *unitContentView;
@property (nonatomic, strong) NSMutableArray *unitMutableArray;

@end

@implementation ZWBrightnessView

+ (instancetype)sharedBrightnessView {
    static ZWBrightnessView *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZWBrightnessView alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 155, 155);
        self.layer.cornerRadius  = 10;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0.8;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 20)];
        label.text = @"亮度";
        label.font = [UIFont systemFontOfSize:12.0f];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        self.label = label;
        
        UIImage *image = [UIImage imageNamed:@"player_brightness"];
        UIImageView *brightnessImageView = [[UIImageView alloc] initWithImage:image];
        CGFloat width = 110;
        brightnessImageView.frame = CGRectMake((self.width - width) * 0.5, (self.height - width) * 0.5, width, width);
        brightnessImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:brightnessImageView];
        self.brightnessImageView = brightnessImageView;
        
        UIView *unitContentView = [[UIView alloc] initWithFrame:CGRectMake(8, self.brightnessImageView.bottom, self.width - 16, 7)];
        [self addSubview:unitContentView];
        unitContentView.backgroundColor = [UIColor blackColor];
        self.unitContentView = unitContentView;
        
        [self createBrightnessUnit];
        
        [[UIScreen mainScreen] addObserver:self forKeyPath:@"brightness" options:NSKeyValueObservingOptionNew context:NULL];
        
        self.alpha = 0;
    }
    return self;
}

- (void)dealloc {
    [[UIScreen mainScreen] removeObserver:self forKeyPath:@"brightness"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = CGRectMake(0, 0, self.width, 20);
    
    CGFloat width = 110;
    self.brightnessImageView.frame = CGRectMake((self.width - width) * 0.5, (self.height - width) * 0.5, width, width);
    
    self.unitContentView.frame = CGRectMake(8, self.brightnessImageView.bottom, self.width - 16, 7);
}

- (void)updateView:(NSNotification *)notify {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

//
- (void)createBrightnessUnit {
    self.unitMutableArray = [NSMutableArray arrayWithCapacity:16];
    CGFloat tipW = (self.unitContentView.width - 17) / 16;
    CGFloat tipH = 5;
    CGFloat tipY = 1;
    
    for (int i = 0; i < 16; i++) {
        CGFloat tipX = i * (tipW + 1) + 1;
        UIImageView *image = [[UIImageView alloc] init];
        image.backgroundColor = [UIColor whiteColor];
        image.frame = CGRectMake(tipX, tipY, tipW, tipH);
        [self.unitContentView addSubview:image];
        [self.unitMutableArray addObject:image];
    }
    [self updateUnitContentView:[UIScreen mainScreen].brightness];
}

- (void)updateUnitContentView:(CGFloat)sound {
    CGFloat stage = 1 / 15.0;
    NSInteger level = sound / stage;
    for (int i = 0; i < self.unitMutableArray.count; i++) {
        UIImageView *img = self.unitMutableArray[i];
        if (i <= level) {
            img.hidden = NO;
        } else {
            img.hidden = YES;
        }
    }
}


#pragma mark- KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    CGFloat sount = [change[@"new"] floatValue];
    NSLog(@"sount:%f",sount);
    
    if (self.alpha == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.alpha == 1) {
                    [UIView animateWithDuration:0.3 animations:^{
                        self.alpha = 0;
                    }];
                }
            });
        }];
    }
    [self updateUnitContentView:sount];
}

@end
