//
//  ZWPlayerView.h
//  ZWTestProject
//
//  Created by caozhenwei on 17/3/24.
//  Copyright © 2017年 czw. All rights reserved.
//

#import "ZWBaseView.h"

@protocol ZWPlayerViewDelegate;

@interface ZWPlayerView : ZWBaseView

@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, weak) id <ZWPlayerViewDelegate> delegate;

- (void)configZWPlayerView;
- (void)toOrientation:(UIInterfaceOrientation)orientation;

@end

@protocol ZWPlayerViewDelegate <NSObject>

- (void)ZWPlayerViewDelegateBackButtonAction;

@end
