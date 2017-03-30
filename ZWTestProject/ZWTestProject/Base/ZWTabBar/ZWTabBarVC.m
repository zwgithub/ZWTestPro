//
//  ZWTabBarVC.m
//  ZWTestProject
//
//  Created by caozhenwei on 17/3/24.
//  Copyright © 2017年 czw. All rights reserved.
//

#import "ZWTabBarVC.h"
#import "ZWBaseNavVC.h"
#import "ZWFirstVC.h"
#import "ZWSecondVC.h"
#import "ZWThirdVC.h"
#import "ZWFourthVC.h"
#import "ZWTbaBarView.h"
#import "ZWTabBarItem.h"

@interface ZWTabBarVC ()

@property (nonatomic, strong) ZWTbaBarView *tabBarView;
@property (nonatomic, assign) NSInteger lastIndex;

@end

@implementation ZWTabBarVC

- (id)init {
    self = [super init];
    if (self) {
        _lastIndex = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTabBarControllers];
    [self drawTabBarBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)createTabBarControllers {
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:4];
    
    _firstVC = [[ZWFirstVC alloc] init];
    _firstNavVC = [[ZWBaseNavVC alloc] initWithRootViewController:_firstVC];
    [viewControllers addObject:_firstNavVC];
    
    _secondVC = [[ZWSecondVC alloc] init];
    _secondNavVC = [[ZWBaseNavVC alloc] initWithRootViewController:_secondVC];
    [viewControllers addObject:_secondNavVC];
    
    _thirdVC = [[ZWThirdVC alloc] init];
    _thirdNavVC = [[ZWBaseNavVC alloc] initWithRootViewController:_thirdVC];
    [viewControllers addObject:_thirdNavVC];
    
    _fourthVC = [[ZWFourthVC alloc] init];
    _fourthNavVC = [[ZWBaseNavVC alloc] initWithRootViewController:_fourthVC];
    [viewControllers addObject:_fourthNavVC];
    
    self.viewControllers = [NSArray arrayWithArray:viewControllers];
    
    self.selectedIndex = 0;
}

- (void)drawTabBarBackground {
    _tabBarView = [[ZWTbaBarView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 49) setTarget:self andFunction:@selector(buttonClicked:)];
    [self.tabBar addSubview:_tabBarView];
    [self.tabBar bringSubviewToFront:_tabBarView];
}

- (void)buttonClicked:(id)sender {
    ZWTabBarItem *afterBtn = sender;
    if (_lastIndex == afterBtn.tag) {
        return;
    }
    
    ZWTabBarItem *beforBtn = [_tabBarView.items objectAtIndex:_lastIndex];
    [beforBtn setClickedBackground:NO];
    [afterBtn setClickedBackground:YES];
    
    self.selectedIndex = afterBtn.tag;
    _lastIndex = (int)afterBtn.tag;
}

- (BOOL)shouldAutorotate {
    ZWBaseNavVC *navVc = (ZWBaseNavVC *)self.selectedViewController;
    return navVc.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    ZWBaseNavVC *navVc = (ZWBaseNavVC *)self.selectedViewController;
    return navVc.topViewController.supportedInterfaceOrientations;
}

@end
