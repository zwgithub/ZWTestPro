//
//  ZWPlayerControlView.h
//  ZWTestProject
//
//  Created by caozhenwei on 17/3/28.
//  Copyright © 2017年 czw. All rights reserved.
//

#import "ZWBaseView.h"

@protocol ZWPlayerControlViewDelegate;

@interface ZWPlayerControlView : ZWBaseView

@property (nonatomic, assign) BOOL isShowControlViewFlag;
@property (nonatomic, weak) id<ZWPlayerControlViewDelegate> delegate;

//当前的播放状态
@property (nonatomic, assign) BOOL isPlayFlag;
//当前播放进度的时间
@property (nonatomic, strong) NSString *currentTime;
//总时间
@property (nonatomic, strong) NSString *totalTime;

//设置缓存进度
- (void)setCacheValue:(CGFloat)value;

//当前播放进度
- (void)setCurrentValue:(CGFloat)value;

@end

@protocol ZWPlayerControlViewDelegate <NSObject>

//单击事件
- (void)ZWPlayerControlViewSingleTap;
//返回按钮事件
- (void)ZWPlayerControlViewBackButonAction;
//播放或者暂停事件
- (void)ZWPlayerControlViewPlayFlag:(BOOL)playFlag;
//拖动开始
- (void)ZWPlayerControlViewProgressSliderTouchBegan:(UISlider *)slider;
//拖动中
- (void)ZWPlayerControlViewProgressSliderValueChanged:(UISlider *)slider;
//拖动结束
- (void)ZWPlayerControlViewProgressSliderTouchEnded:(UISlider *)slider;

@end
