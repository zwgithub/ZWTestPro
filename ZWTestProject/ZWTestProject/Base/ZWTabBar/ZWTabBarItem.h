//
//  ZWTabBarItem.h
//  ZWTestProject
//
//  Created by caozhenwei on 17/3/24.
//  Copyright © 2017年 czw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWTabBarItem : UIButton

- (void)loadIcon:(UIImage *)icon selectedIcon:(UIImage *)selectedIcon andLoadTitle:(NSString *)title;
- (void)setTaget:(id)target selectedFunction:(SEL)selected;
- (void)setClickedBackground:(BOOL)isClicked;
//- (void)showBadgeIconAndNumber:(NSString *)number;

@end
