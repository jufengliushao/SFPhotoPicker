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
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.mas_equalTo(20);
    }];
    [super drawRect:rect];
}

#pragma mark - init
- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_backBtn setTitle:@"back" forState:(UIControlStateNormal)];
        [_backBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
        [self addSubview:_backBtn];
    }
    return _backBtn;
}
@end
