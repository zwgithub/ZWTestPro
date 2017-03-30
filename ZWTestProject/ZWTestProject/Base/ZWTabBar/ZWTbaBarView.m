//
//  ZWTbaBarView.m
//  ZWTestProject
//
//  Created by caozhenwei on 17/3/24.
//  Copyright © 2017年 czw. All rights reserved.
//

#import "ZWTbaBarView.h"
#import "ZWTabBarItem.h"


#define TABBAR_ITEM_COUNT 4

@implementation ZWTbaBarView

- (id)initWithFrame:(CGRect)frame setTarget:(id)target andFunction:(SEL)selectedFun {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor whiteColor];
    
    if (self) {
        NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:0];
        CGFloat itemWidth = [UIScreen mainScreen].bounds.size.width / TABBAR_ITEM_COUNT;
        for (int i = 0; i < TABBAR_ITEM_COUNT; i ++) {
            ZWTabBarItem *item = [[ZWTabBarItem alloc] initWithFrame:CGRectMake(i*itemWidth, 0, itemWidth, frame.size.height)];
            [item loadIcon:[self checkAndSetImage:i] selectedIcon:[self checkAndSetSelectedImage:i] andLoadTitle:[self checkAndSetName:i]];
            [items addObject:item];
            [item setTaget:target selectedFunction:selectedFun];
            item.tag = i;
            if (i == 0) {
                [item setClickedBackground:YES];
            }
            [self addSubview:item];
        }
        self.items = [NSArray arrayWithArray:items];
    }
    return self;
}

- (UIImage *)checkAndSetImage:(int)whitchIcon {
    switch (whitchIcon) {
        case 0:
            return [UIImage imageNamed:@"tabbar_normal.png"];
            break;
        case 1:
            return [UIImage imageNamed:@"tabbar_normal.png"];
            break;
        case 2:
            return [UIImage imageNamed:@"tabbar_normal.png"];
            break;
        case 3:
            return [UIImage imageNamed:@"tabbar_normal.png"];
            break;
        case 4:
            return [UIImage imageNamed:@"tabbar_normal.png"];
            break;
        default:
            return nil;
            break;
    }
}

- (UIImage *)checkAndSetSelectedImage:(int)whitchIcon {
    switch (whitchIcon) {
        case 0:
            return [UIImage imageNamed:@"tabbar_selected.png"];
            break;
        case 1:
            return [UIImage imageNamed:@"tabbar_selected.png"];
            break;
        case 2:
            return [UIImage imageNamed:@"tabbar_selected.png"];
            break;
        case 3:
            return [UIImage imageNamed:@"tabbar_selected.png"];
            break;
        case 4:
            return [UIImage imageNamed:@"tabbar_selected.png"];
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)checkAndSetName:(int)whitchIcon {
    switch (whitchIcon) {
        case 0:return @"测试";
            break;
        case 1:return @"测试";
            break;
        case 2:return @"测试";
            break;
        case 3:return @"测试";
            break;
        case 4:return @"测试";
            break;
        default:return nil;
            break;
    }
}

@end
