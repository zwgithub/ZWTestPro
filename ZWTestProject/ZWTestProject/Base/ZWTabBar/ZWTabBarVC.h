//
//  ZWTabBarVC.h
//  ZWTestProject
//
//  Created by caozhenwei on 17/3/24.
//  Copyright © 2017年 czw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZWFirstVC;
@class ZWSecondVC;
@class ZWThirdVC;
@class ZWFourthVC;
@class ZWBaseNavVC;

@interface ZWTabBarVC : UITabBarController

@property (nonatomic, strong) ZWFirstVC *firstVC;
@property (nonatomic, strong) ZWSecondVC *secondVC;
@property (nonatomic, strong) ZWThirdVC *thirdVC;
@property (nonatomic, strong) ZWFourthVC *fourthVC;

@property (nonatomic, strong) ZWBaseNavVC *firstNavVC;
@property (nonatomic, strong) ZWBaseNavVC *secondNavVC;
@property (nonatomic, strong) ZWBaseNavVC *thirdNavVC;
@property (nonatomic, strong) ZWBaseNavVC *fourthNavVC;

@end
