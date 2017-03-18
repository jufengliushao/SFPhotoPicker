//
//  SFCameraPhotoToolView.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/3/9.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFCameraPhotoToolView.h"
#import "SFCameraPhotoResultView.h"
#import "Masonry.h"

#define HalfValue(value) value / 2.0
@interface SFCameraPhotoToolView()<UIGestureRecognizerDelegate>{
    CGFloat _lastDistance;
    UIImage *_resultImg;
}

@property (nonatomic, strong) SFCameraPhotoResultView *resultView;
@end

const static CGFloat maxLength = 80;
const static CGFloat midScale = 50.0 / maxLength;
const static CGFloat minScale = 30.0 / maxLength;

@implementation SFCameraPhotoToolView
#pragma mark - system method
- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
        [self addGestureRecognizer:pinch];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    WS(ws);
    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.resultView drawRect:rect];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(20);
        make.width.height.mas_equalTo(40);
    }];
    [self.flashForbidBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-20);
        make.top.mas_equalTo(20);
        make.width.height.mas_equalTo(35);
    }];
    [self.flahBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(ws.flashForbidBtn.mas_leading).mas_offset(-10);
        make.top.mas_equalTo(20);
        make.width.height.mas_equalTo(35);
    }];
    [self.switchCameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.trailing.mas_equalTo(-20);
        make.width.height.mas_equalTo(40);
    }];
    [self.shutterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(ws);
        make.bottom.mas_equalTo(-20);
        make.width.height.mas_equalTo(60);
    }];
    [self.focusingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(0);
    }];
    [super drawRect:rect];
}

#pragma mark - pinch gesture
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinch{
    if (pinch.numberOfTouches != 2) {
        return;
    }
    CGPoint point1 = [pinch locationOfTouch:0 inView:self];
    CGPoint point2 = [pinch locationOfTouch:1 inView:self];
    CGFloat distanceX = point2.x - point1.x;
    CGFloat distanceY = point2.y - point1.y;
    CGFloat distance = sqrtf(distanceX * distanceX +distanceY * distanceY);
    if (pinch.state == UIGestureRecognizerStateBegan) {
        _lastDistance = distance;
    }
    CGFloat change = distance - _lastDistance;
    change = change / CGRectGetWidth(self.bounds);
    _lastDistance = distance;
    [[SFCameraTool sharedInstance] sf_changeCameraEffectiveScale:change];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tap{
    if (tap.numberOfTouches != 1) {
        return;
    }
    CGPoint point = [tap locationInView:self];
    [[SFCameraTool sharedInstance] sf_setCameraFocusPoint:point];
    self.focusingView.frame = CGRectMake(point.x - HalfValue(maxLength), point.y - HalfValue(maxLength), maxLength, maxLength);
    [self animationView:point];
}

- (void)animationView:(CGPoint)point{
    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
   
    groupAnima.animations = @[[self returnTransformDuration:1 fromValue:[NSNumber numberWithFloat:1] toValue:[NSNumber numberWithFloat:0.01]]];
    groupAnima.fillMode = kCAFillModeForwards;
    groupAnima.removedOnCompletion = NO;
    [self.focusingView.layer addAnimation:groupAnima forKey:@"focusing-view"];
}

- (CABasicAnimation *)returnTransformDuration:(CGFloat)duration fromValue:(NSNumber *)from toValue:(NSNumber *)to{
    CABasicAnimation *transformAnima = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    transformAnima.duration = duration;
    transformAnima.repeatCount = 1;
    transformAnima.autoreverses = NO;
    transformAnima.fromValue = from;
    transformAnima.toValue = to;
    return transformAnima;
}

#pragma mark - setData
- (void)configureImg:(UIImage *)img{
    if (img) {
        self.resultView.hidden = false;
        _resultImg = img;
        [self.resultView configureImg:img];
    }else{
        self.resultView.hidden = true;
        _resultImg = nil;
        [self.resultView configureImg:nil];
    }
}

#pragma mark - init
- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_backBtn setImage:[UIImage imageNamed:@"cancel"] forState:(UIControlStateNormal)];
        _backBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:_backBtn];
    }
    return _backBtn;
}

- (UIButton *)flahBtn{
    if (!_flahBtn) {
        _flahBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _flahBtn.backgroundColor = [UIColor clearColor];
        [_flahBtn setImage:[UIImage imageNamed:@"cameraFlash-default"] forState:(UIControlStateNormal)];
        [_flahBtn setImage:[UIImage imageNamed:@"cameraFlash-hightLight"] forState:(UIControlStateSelected)];
        _flahBtn.selected = NO;
        [self addSubview:_flahBtn];
    }
    return _flahBtn;
}

- (UIButton *)flashForbidBtn{
    if(!_flashForbidBtn){
        _flashForbidBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _flashForbidBtn.backgroundColor = [UIColor clearColor];
        [_flashForbidBtn setImage:[UIImage imageNamed:@"cameraFlash-close-default"] forState:(UIControlStateNormal)];
        [_flashForbidBtn setImage:[UIImage imageNamed:@"cameraFlash_colse-heightLight"] forState:(UIControlStateSelected)];
        _flashForbidBtn.selected = NO;
        [self addSubview:_flashForbidBtn];
    }
    return _flashForbidBtn;
}

- (UIButton *)switchCameraBtn{
    if (!_switchCameraBtn) {
        _switchCameraBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _switchCameraBtn.backgroundColor = [UIColor clearColor];
        [_switchCameraBtn setImage:[UIImage imageNamed:@"camera-change"] forState:(UIControlStateNormal)];
        [self addSubview:_switchCameraBtn];
    }
    return _switchCameraBtn;
}

- (UIButton *)shutterBtn{
    if (!_shutterBtn) {
        _shutterBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _shutterBtn.backgroundColor = [UIColor orangeColor];
        [_shutterBtn setImage:[UIImage imageNamed:@"camera-l"] forState:(UIControlStateNormal)];
        [self addSubview:_shutterBtn];
    }
    return _shutterBtn;
}

- (SFCameraPhotoResultView *)resultView{
    if (!_resultView) {
        _resultView = [[SFCameraPhotoResultView alloc] init];
        _resultView.hidden = YES;
        BS(bs);
        WS(ws);
        [_resultView.cancelBtn addTargetAction:^(UIButton *sender) {
            bs->_resultView.hidden = YES;
            [[SFCameraTool sharedInstance] sf_cameraStartRunning];
        }];
        [_resultView.saveBtn addTargetAction:^(UIButton *sender) {
            [[SFThridMethod sharedInstance] showWaitHUDWithMessage:@"saving..." toView:ws];
            [[SFPhotoPickerTool sharedInstance] sf_saveImageSynchronousInCameraAlbum:bs->_resultImg complete:^(BOOL isSuccess, NSError *__autoreleasing *err, NSString *imgID) {
                [[SFThridMethod sharedInstance] hiddenHUD];
                bs->_resultView.hidden = YES;
            }];
        }];
        [self addSubview:_resultView];
    }
    return _resultView;
}

- (UIView *)focusingView{
    if (!_focusingView) {
        _focusingView = [[UIView alloc] init];
        _focusingView.backgroundColor = [UIColor clearColor];
        _focusingView.layer.borderColor = [UIColor yellowColor].CGColor;
        _focusingView.layer.borderWidth = 1.5;
        [self addSubview:_focusingView];
    }
    return _focusingView;
}
@end
