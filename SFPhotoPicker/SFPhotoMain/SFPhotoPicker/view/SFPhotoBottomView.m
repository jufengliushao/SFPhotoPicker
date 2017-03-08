//
//  SFPhotoBottomView.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/3/8.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFPhotoBottomView.h"
#import "Masonry.h"
@implementation SFPhotoBottomView
#pragma mark - system method
- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    WS(ws);
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws);
        make.leading.mas_equalTo(10);
    }];
    [self.origalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws);
        make.leading.mas_equalTo(ws.editBtn.mas_trailing).mas_offset(10);
    }];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws);
        make.trailing.mas_equalTo(-10);
    }];
    [super drawRect:rect];
}

#pragma mark - set data
- (void)configureData{
    self.editBtn.enabled = [SFIndexCalculateTool shareInstance].selectedIndexImgArr.count == 1 ? YES : NO;
    self.sendBtn.enabled = [SFIndexCalculateTool shareInstance].selectedIndexImgArr.count ? YES : NO;
    if (self.sendBtn.isEnabled) {
        [self.sendBtn setTitle:[NSString stringWithFormat:@"发送 %ld", [SFIndexCalculateTool shareInstance].selectedIndexImgArr.count] forState:(UIControlStateNormal)];
    }else{
        [_sendBtn setTitle:@"发送" forState:(UIControlStateNormal & UIControlStateDisabled)];
    }
}

#pragma mark - init
- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_editBtn setTitle:@"编辑" forState:(UIControlStateNormal & UIControlStateDisabled)];
        [_editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_editBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateDisabled)];
        _editBtn.enabled = NO;
        [self addSubview:_editBtn];
    }
    return _editBtn;
}

- (UIButton *)origalBtn{
    if (!_origalBtn) {
        _origalBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_origalBtn setTitle:@"原图" forState:(UIControlStateNormal & UIControlStateSelected)];
        [_origalBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
        [_origalBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
        _origalBtn.selected = NO;
        [self addSubview:_origalBtn];
    }
    return _origalBtn;
}

- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_sendBtn setTitle:@"发送" forState:(UIControlStateNormal & UIControlStateDisabled)];
        [_sendBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateDisabled)];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _sendBtn.enabled = NO;
        [self addSubview:_sendBtn];
    }
    return _sendBtn;
}
@end
