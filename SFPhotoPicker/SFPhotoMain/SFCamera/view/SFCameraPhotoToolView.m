//
//  SFCameraPhotoToolView.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/3/9.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFCameraPhotoToolView.h"
#import "Masonry.h"
@implementation SFCameraPhotoToolView
#pragma mark - system method
- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
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
    [super drawRect:rect];
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
@end
