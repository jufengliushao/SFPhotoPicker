//
//  SFPhotoDetailHeaderView.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/3/6.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFPhotoDetailHeaderView.h"
#import "Masonry.h"
NSString * const defaultImg_big = @"radio.png";
NSString * const selectedImg_big = @"color-radio";

@implementation SFPhotoDetailHeaderView
#pragma mark - system method
- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    WS(ws);
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(10);
        make.centerY.mas_equalTo(ws).mas_offset(10);
    }];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws).mas_offset(10);
        make.centerX.mas_equalTo(ws);
    }];
    [self.indexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-10);
        make.centerY.mas_equalTo(ws).mas_offset(10);
        make.width.height.mas_equalTo(30);
    }];
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(ws.indexImageView);
    }];
    [self.indexBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.bottom.mas_equalTo(20);
        make.leading.mas_equalTo(ws.indexImageView).mas_offset(-10);
    }];
    
    [super drawRect:rect];
}

#pragma mark - init
- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_backButton setTitle:@"返回" forState:(UIControlStateNormal)];
        [_backButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [self addSubview:_backButton];
    }
    return _backButton;
}

- (UILabel *)totalLabel{
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.text = @"155/111";
        _totalLabel.font = [UIFont systemFontOfSize:15];
        _totalLabel.textColor = [UIColor whiteColor];
        [self addSubview:_totalLabel];
    }
    return _totalLabel;
}

- (UIImageView *)indexImageView{
    if (!_indexImageView) {
        _indexImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:defaultImg_big]];
        [self addSubview:_indexImageView];
    }
    return _indexImageView;
}

- (UILabel *)indexLabel{
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.text = @"1";
        _indexLabel.font = [UIFont systemFontOfSize:14];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.textColor = [UIColor whiteColor];
        [self addSubview:_indexLabel];
    }
    return _indexLabel;
}

- (UIButton *)indexBtn{
    if (!_indexBtn) {
        _indexBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _indexBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:_indexBtn];
    }
    return _indexBtn;
}

@end
