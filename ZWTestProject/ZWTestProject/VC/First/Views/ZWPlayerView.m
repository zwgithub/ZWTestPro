//
//  ZWPlayerView.m
//  ZWTestProject
//
//  Created by caozhenwei on 17/3/24.
//  Copyright © 2017年 czw. All rights reserved.
//

#import "ZWPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "ZWPlayerControlView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ZWBrightnessView.h"
#import "ZWProgressView.h"

@interface ZWPlayerView () <ZWPlayerControlViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVURLAsset *urlAsset;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) ZWPlayerControlView *controlView;

//滑动的时候是否为竖直方向
@property (nonatomic, assign) BOOL isVerticalMoved;
//是否在调节音量
@property (nonatomic, assign) BOOL isVolume;

//控制音量的滑杆
@property (nonatomic, strong) UISlider *volumeViewSlider;

@property (nonatomic, strong) ZWBrightnessView *brightnessView;

@end

@implementation ZWPlayerView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (ZWBrightnessView *)brightnessView {
    if (!_brightnessView) {
        _brightnessView = [ZWBrightnessView sharedBrightnessView];
    }
    return _brightnessView;
}

- (void)backButtonAction {
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    if (_delegate && [_delegate respondsToSelector:@selector(ZWPlayerViewDelegateBackButtonAction)]) {
        [_delegate ZWPlayerViewDelegateBackButtonAction];
    }
}

- (void)configZWPlayerView {
    
    self.urlAsset = [AVURLAsset assetWithURL:self.videoURL];
    // 初始化playerItem
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
    // 每次都重新创建Player，替换replaceCurrentItemWithPlayerItem:，该方法阻塞线程
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    // 初始化playerLayer
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.backgroundColor = [UIColor blackColor].CGColor;
    [self.layer addSublayer:self.playerLayer];
    self.playerLayer.frame = self.bounds;
    [self.player play];
    
    ZWPlayerControlView *controlView = [[ZWPlayerControlView alloc] initWithFrame:CGRectMake(0, 20, self.width, self.height)];
    controlView.delegate = self;
    [self addSubview:controlView];
    self.controlView = controlView;
    
    //添加播放进度计时器
    [self createTimer];
    
    //音量
    [self configVolume];
    
    //监测设备方向
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onStatusBarOrientationChange)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    [self addSubview:self.brightnessView];
}

- (void)setPlayerItem:(AVPlayerItem *)playerItem {
    if (_playerItem == playerItem) {
        return;
    }
    
    if (_playerItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
        [_playerItem removeObserver:self forKeyPath:@"status"];
        [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [_playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [_playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    }
    _playerItem = playerItem;
    if (playerItem) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
        [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        // 缓冲区空了，需要等待数据
        [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
        // 缓冲区有足够数据可以播放了
        [playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    }
}

//播放完了
- (void)moviePlayDidEnd {

}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
    self.controlView.frame = self.bounds;
    self.brightnessView.frame = CGRectMake((self.height - self.brightnessView.height) * 0.5, (self.width - self.brightnessView.width) * 0.5, self.brightnessView.width, self.brightnessView.height);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    self.playerItem = nil;
    self.player = nil;
    NSLog(@"释放了");
}

- (void)onDeviceOrientationChange {
    NSLog(@"屏幕方向改变");
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        return;
    }
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
        }
            break;
        case UIInterfaceOrientationPortrait:{
            [self toOrientation:UIInterfaceOrientationPortrait];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            [self toOrientation:UIInterfaceOrientationLandscapeLeft];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            [self toOrientation:UIInterfaceOrientationLandscapeRight];
        }
            break;
        default:
            break;
    }
}

- (void)toOrientation:(UIInterfaceOrientation)orientation {
    // 获取到当前状态条的方向
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    // 判断如果当前方向和要旋转的方向一致,那么不做任何操作
    if (currentOrientation == orientation) {
        return;
    }
    
    if (orientation != UIInterfaceOrientationPortrait) {
        self.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
        self.center = [UIApplication sharedApplication].keyWindow.center;
    }
    
    [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    // 更改了状态条的方向,但是设备方向UIInterfaceOrientation还是正方向的,这就要设置给你播放视频的视图的方向设置旋转
    // 给你的播放视频的view视图设置旋转
    self.transform = CGAffineTransformIdentity;
    self.transform = [self getTransformRotationAngle];
    // 开始旋转
    [UIView commitAnimations];
    NSLog(@"%@",self);
}

- (CGAffineTransform)getTransformRotationAngle {
    // 状态条的方向已经设置过,所以这个就是你想要旋转的方向
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    // 根据要进行旋转的方向来计算旋转的角度
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft){
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if(orientation == UIInterfaceOrientationLandscapeRight){
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    return CGAffineTransformIdentity;
}

- (void)onStatusBarOrientationChange {
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    NSLog(@"状态栏改变：%ld",currentOrientation);
    if (currentOrientation == UIInterfaceOrientationLandscapeRight) {
        [self toOrientation:UIInterfaceOrientationLandscapeRight];
    } else if (currentOrientation == UIInterfaceOrientationLandscapeLeft){
        [self toOrientation:UIInterfaceOrientationLandscapeLeft];
    } else if (currentOrientation == UIInterfaceOrientationPortrait) {
        [self toOrientation:UIInterfaceOrientationPortrait];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.player.currentItem) {
        if ([keyPath isEqualToString:@"status"]) {
            
            if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
                
                [self.layer insertSublayer:self.playerLayer atIndex:0];
                
                [self setNeedsLayout];
                [self layoutIfNeeded];
                
                UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesAction:)];
                panGes.delegate = self;
                [panGes setMaximumNumberOfTouches:1];
                [panGes setDelaysTouchesBegan:YES];
                [panGes setDelaysTouchesEnded:YES];
                [panGes setCancelsTouchesInView:YES];
                [self addGestureRecognizer:panGes];
                
            } else if (self.player.currentItem.status == AVPlayerItemStatusFailed) {
                
            }
        } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            //计算缓冲进度
            NSTimeInterval timeInterval = [self availableDuration];
            CMTime duration = self.playerItem.duration;
            CGFloat totalDuration = CMTimeGetSeconds(duration);
            NSLog(@"缓冲进度:%f",timeInterval / totalDuration);
            [self.controlView setCacheValue:timeInterval / totalDuration];
        } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            // 当缓冲是空的时候
            if (self.playerItem.playbackBufferEmpty) {
                
            }
            
        } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            
            // 当缓冲好的时候
            
        }
    }
}

#pragma mark - 滑动手势
- (void)panGesAction:(UIPanGestureRecognizer *)pan {
    CGPoint locationPoint = [pan locationInView:self];
    CGPoint veloctyPoint = [pan velocityInView:self];
    //NSLog(@"%@",NSStringFromCGPoint(veloctyPoint));
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) {
                NSLog(@"水平移动");
                self.isVerticalMoved = NO;
            } else if (x < y){
                NSLog(@"竖直移动");
                self.isVerticalMoved = YES;
                if (locationPoint.x > self.bounds.size.width * 0.5) {
                    self.isVolume = YES;
                } else {
                    self.isVolume = NO;
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            NSLog(@"**********正在拖动*************");
            if (self.isVerticalMoved == YES) {
                [self verticalMoved:veloctyPoint.y];
            } else {
                [self horizontalMoved:veloctyPoint.y];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{
            NSLog(@"取消滑动");
            break;
        }
            
        default:
            break;
    }
}

- (void)horizontalMoved:(CGFloat)value {

}

- (void)verticalMoved:(CGFloat)value {
    if (self.isVolume == YES) {
        self.volumeViewSlider.value -= value/10000;
    } else {
        [UIScreen mainScreen].brightness -= value/10000;
    }
}

#pragma mark - 计算缓冲进度

/**
 *  计算缓冲进度
 *
 *  @return 缓冲进度
 */
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

//播放进度
- (void)createTimer {
    __weak typeof(self) weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, 1) queue:nil usingBlock:^(CMTime time){
        AVPlayerItem *currentItem = weakSelf.playerItem;
        NSArray *loadedRanges = currentItem.seekableTimeRanges;
        if (loadedRanges.count > 0 && currentItem.duration.timescale != 0) {
            NSInteger currentTime = (NSInteger)CMTimeGetSeconds([currentItem currentTime]);
            NSInteger totalTime = (NSInteger)currentItem.duration.value / currentItem.duration.timescale;
            CGFloat value = CMTimeGetSeconds([currentItem currentTime]) / totalTime;
            [weakSelf.controlView setCurrentValue:value];
//            NSLog(@"播放的百分比：%f",value);
            NSInteger proMin = currentTime / 60;//当前秒
            NSInteger proSec = currentTime % 60;//当前分钟
            weakSelf.controlView.currentTime = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
            
            NSInteger durMin = totalTime / 60;//总秒
            NSInteger durSec = totalTime % 60;//总分钟
            weakSelf.controlView.totalTime = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
        }
    }];
}

- (void)configVolume {
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    _volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]) {
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]) {
            _volumeViewSlider = (UISlider *)view;
            break;
        }
    }
}

#pragma mark- ZWPlayerControlViewDelegate
- (void)ZWPlayerControlViewSingleTap {
    
}

- (void)ZWPlayerControlViewBackButonAction {
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.brightnessView removeFromSuperview];
    self.brightnessView.alpha = 0;
    [self backButtonAction];
}

- (void)ZWPlayerControlViewPlayFlag:(BOOL)playFlag {
    if (playFlag == YES) {
        [self.player play];
    } else {
        [self.player pause];
    }
}

//拖动开始
- (void)ZWPlayerControlViewProgressSliderTouchBegan:(UISlider *)slider {

}
//拖动中
- (void)ZWPlayerControlViewProgressSliderValueChanged:(UISlider *)slider {
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        CGFloat totalTime = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
        CGFloat dragedSeconds = floorf(totalTime * slider.value);
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
        [self.playerItem seekToTime:dragedCMTime];
        [self.controlView setCurrentValue:dragedSeconds/totalTime];
        NSInteger proMin = dragedSeconds / 60;//当前秒
        NSInteger proSec = (NSInteger)dragedSeconds % 60;//当前分钟
        self.controlView.currentTime = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    }
}
//拖动结束
- (void)ZWPlayerControlViewProgressSliderTouchEnded:(UISlider *)slider {

}

#pragma mark- 手势代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]] || [touch.view isKindOfClass:[UISlider class]]) {
        return NO;
    }
    return YES;
}

@end
