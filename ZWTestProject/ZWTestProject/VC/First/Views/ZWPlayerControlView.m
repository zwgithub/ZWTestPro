//
//  ZWPlayerControlView.m
//  ZWTestProject
//
//  Created by caozhenwei on 17/3/28.
//  Copyright © 2017年 czw. All rights reserved.
//

#import "ZWPlayerControlView.h"

@interface ZWPlayerControlView () <UIGestureRecognizerDelegate>

//顶部图片
@property (nonatomic, strong) UIImageView *topImageView;
//返回按钮
@property (nonatomic, strong) UIButton *backButton;
//视频标题
@property (nonatomic, strong) UILabel *tittleLabel;

//底部图片
@property (nonatomic, strong) UIImageView *bottomImageView;
//播放／暂停
@property (nonatomic, strong) UIButton *playButton;
//当前播放时间
@property (nonatomic, strong) UILabel *currentTimeLabel;
//总时间
@property (nonatomic, strong) UILabel *totalTimeLabel;

//单击
@property (nonatomic, strong) UITapGestureRecognizer *singleTapGes;
//双击
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGes;

@end

@implementation ZWPlayerControlView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.topImageView];
        [self addSubview:self.bottomImageView];
        
        //顶部
        [self.topImageView addSubview:self.backButton];
        [self.topImageView addSubview:self.tittleLabel];
        
        //底部
        [self.bottomImageView addSubview:self.playButton];
        [self.bottomImageView addSubview:self.currentTimeLabel];
        [self.bottomImageView addSubview:self.totalTimeLabel];
        
        //添加手势
        [self addGesture];
        
        self.isShowControlViewFlag = NO;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return self;
}

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] init];
        _topImageView.userInteractionEnabled = YES;
        _topImageView.alpha = 0;
        _topImageView.image = [UIImage imageNamed:@"top_shadow"];
    }
    return _topImageView;
}

- (UIImageView *)bottomImageView {
    if (!_bottomImageView) {
        _bottomImageView = [[UIImageView alloc] init];
        _bottomImageView.userInteractionEnabled = YES;
        _bottomImageView.alpha = 0;
        _bottomImageView.image = [UIImage imageNamed:@"bottom_shadow"];
    }
    return _bottomImageView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_backButton setImage:[UIImage imageNamed:@"back_button"] forState:UIControlStateNormal];
        _backButton.backgroundColor = [UIColor redColor];
        [_backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UILabel *)tittleLabel {
    if (!_tittleLabel) {
        _tittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.topImageView.width, self.topImageView.height - 20)];
        _tittleLabel.textColor = [UIColor whiteColor];
        _tittleLabel.textAlignment = NSTextAlignmentCenter;
        _tittleLabel.text = @"视频的标题";
    }
    return _tittleLabel;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playButtonButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _playButton.backgroundColor = [UIColor purpleColor];
    }
    return _playButton;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_playButton.right, 0, 45, self.bottomImageView.height)];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:9.0f];
        _currentTimeLabel.backgroundColor = [UIColor redColor];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        _currentTimeLabel.text = @"00:00";
    }
    return _currentTimeLabel;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bottomImageView.width - 65, 0, 45, self.bottomImageView.height)];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.font = [UIFont systemFontOfSize:9.0f];
        _totalTimeLabel.backgroundColor = [UIColor redColor];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        _totalTimeLabel.text = @"00:00";
    }
    return _totalTimeLabel;
}

//添加手势
- (void)addGesture {
    //单击
    UITapGestureRecognizer *singleTapGes = [[UITapGestureRecognizer alloc] init];
    [singleTapGes addTarget:self action:@selector(singleTapActoin)];
    singleTapGes.numberOfTapsRequired = 1;
    singleTapGes.numberOfTouchesRequired = 1;
    singleTapGes.delegate = self;
    [self addGestureRecognizer:singleTapGes];
    self.singleTapGes = singleTapGes;
    
    //双击
    UITapGestureRecognizer *doubleTapGes = [[UITapGestureRecognizer alloc] init];
    [doubleTapGes addTarget:self action:@selector(doubleTapActoin)];
    doubleTapGes.numberOfTapsRequired = 2;
    doubleTapGes.numberOfTouchesRequired = 1;
    doubleTapGes.delegate = self;
    [self addGestureRecognizer:doubleTapGes];
    self.doubleTapGes = doubleTapGes;
    
    //如果doubleTapGes识别出双击事件，则singleTapGes不会有任何动作。
    [singleTapGes requireGestureRecognizerToFail:doubleTapGes];
}

#pragma mark- layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    _topImageView.frame = CGRectMake(0, 20, self.width, 50);
    _bottomImageView.frame = CGRectMake(0, self.height - 50, self.width, 50);
    
    _tittleLabel.frame = CGRectMake(0, 10, self.topImageView.width, self.bottomImageView.height - 20);
    
    _currentTimeLabel.frame = CGRectMake(_playButton.right, 0, 45, self.bottomImageView.height);
    _totalTimeLabel.frame = CGRectMake(self.bottomImageView.width - 65, 0, 45, self.bottomImageView.height);
}

- (void)setIsShowControlViewFlag:(BOOL)isShowControlViewFlag {
    _isShowControlViewFlag = isShowControlViewFlag;
    if (_isShowControlViewFlag == YES) {
        [self showControlView];
    } else {
        [self hideControlView];
    }
}

- (void)setIsPlayFlag:(BOOL)isPlayFlag {
    _isPlayFlag = isPlayFlag;
    if (_isPlayFlag == YES) {
        [_playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];;
    } else {
        [_playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];;
    }
}

- (void)setCurrentTime:(NSString *)currentTime {
    _currentTimeLabel.text = currentTime;
}

- (void)setTotalTime:(NSString *)totalTime {
    _totalTimeLabel.text = totalTime;
}

- (void)showControlView {
    _topImageView.alpha = 1;
    _bottomImageView.alpha = 1;
}

- (void)hideControlView {
    _topImageView.alpha = 0;
    _bottomImageView.alpha = 0;
}

//单击
- (void)singleTapActoin {
    self.isShowControlViewFlag = !self.isShowControlViewFlag;
    if (_delegate && [_delegate respondsToSelector:@selector(ZWPlayerControlViewSingleTap)]) {
        [_delegate ZWPlayerControlViewSingleTap];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.isShowControlViewFlag == YES) {
            self.isShowControlViewFlag = !self.isShowControlViewFlag;
        }
    });
}

- (void)doubleTapActoin {
    [self playButtonButtonAction];
}

//返回
- (void)backButtonAction {
    if (_delegate && [_delegate respondsToSelector:@selector(ZWPlayerControlViewBackButonAction)]) {
        [_delegate ZWPlayerControlViewBackButonAction];
    }
}

//播放或暂停事件
- (void)playButtonButtonAction {
    self.isPlayFlag = !self.isPlayFlag;
    if (_delegate && [_delegate respondsToSelector:@selector(ZWPlayerControlViewPlayFlag:)]) {
        [_delegate ZWPlayerControlViewPlayFlag:_isPlayFlag];
    }
}

#pragma mark- 手势代理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

@end
