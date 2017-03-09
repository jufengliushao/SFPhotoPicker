//
//  SFCameraPhotoToolView.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/3/9.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFCameraPhotoToolView.h"
#import "Masonry.h"

@interface SFCameraPhotoToolView()<UIGestureRecognizerDelegate>{
    CGFloat _lastDistance;
}

@end

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
    CGPoint point = [tap locationOfTouch:0 inView:self];
    NSLog(@"%f---%f", point.x, point.y);
    [[SFCameraTool sharedInstance] sf_setCameraFocusPoint:point];
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
        [_switchCameraBtn setTitle:@"change" forState:(UIControlStateNormal)];
        [_switchCameraBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
        [self addSubview:_switchCameraBtn];
    }
    return _switchCameraBtn;
}
@end
