//
//  SFCameraMovieToolView.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/3/20.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFCameraMovieToolView.h"
#import "Masonry.h"
@implementation SFCameraMovieToolView
- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    WS(ws);
    [self.recoderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50);
        make.bottom.mas_equalTo(-20);
        make.centerX.mas_equalTo(ws);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(20);
        make.width.height.mas_equalTo(40);
    }];
    [super drawRect:rect];
}

#pragma mark - init
- (UIButton *)recoderBtn{
    if (!_recoderBtn) {
        _recoderBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_recoderBtn setImage:[UIImage imageNamed:@"movieStart"] forState:(UIControlStateNormal)];
        [_recoderBtn setImage:[UIImage imageNamed:@"movieStop"] forState:(UIControlStateSelected)];
        [self addSubview:_recoderBtn];
    }
    return _recoderBtn;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_backBtn setImage:[UIImage imageNamed:@"cancel"] forState:(UIControlStateNormal)];
        _backBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:_backBtn];
    }
    return _backBtn;
}
@end
