//
//  ZWTabBarItem.m
//  ZWTestProject
//
//  Created by caozhenwei on 17/3/24.
//  Copyright © 2017年 czw. All rights reserved.
//

#import "ZWTabBarItem.h"

@interface ZWTabBarItem ()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIImage *normalImg;
@property (nonatomic, strong) UIImage *selectedImg;

@end

@implementation ZWTabBarItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.icon];
        [self addSubview:self.label];
    }
    return self;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 26) * 0.5, 7, 26, 26)];
        _icon.backgroundColor = [UIColor clearColor];
    }
    return _icon;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, _icon.frame.size.height + _icon.frame.origin.y + 1, self.frame.size.width, 14)];
        _label.textColor = [UIColor colorWithRed:146.0 / 255.0 green:146.0 / 255.0 blue:146.0 / 255.0 alpha:1];
        _label.backgroundColor = [UIColor clearColor];
        _label.font = [UIFont systemFontOfSize:11];
        _label.text = @"111";
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

#pragma mark- public fun
- (void)loadIcon:(UIImage *)icon selectedIcon:(UIImage *)selectedIcon andLoadTitle:(NSString *)title {
    _icon.image = icon;
    self.normalImg = icon;
    self.selectedImg = selectedIcon;
    if ([title length] > 4) {
        _label.font = [UIFont systemFontOfSize:12.f];
    }
    _label.text = title;
}

- (void)setTaget:(id)target selectedFunction:(SEL)selected {
    [self addTarget:target action:selected forControlEvents:UIControlEventTouchDown];
}

- (void)setClickedBackground:(BOOL)isClicked {
    if (isClicked) {
        _label.textColor = [UIColor purpleColor];
        _icon.image = _selectedImg;
    } else {
        _label.textColor = [UIColor colorWithRed:146.0 / 255.0 green:146.0 / 255.0 blue:146.0 / 255.0 alpha:1];
        _icon.image = _normalImg;
    }
}

@end
