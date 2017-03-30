//
//  ZWTbaBarView.h
//  ZWTestProject
//
//  Created by caozhenwei on 17/3/24.
//  Copyright © 2017年 czw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWTbaBarView : UIView

@property (nonatomic, strong) NSArray *items;

- (id)initWithFrame:(CGRect)frame setTarget:(id)target andFunction:(SEL)selected;

@end
