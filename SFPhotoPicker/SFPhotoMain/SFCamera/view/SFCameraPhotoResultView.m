//
//  SFCameraPhotoResultView.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/3/10.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFCameraPhotoResultView.h"
#import "Masonry.h"
@implementation SFCameraPhotoResultView
#pragma mark - system method
- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    WS(ws);
    [self.resultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(20);
        make.bottom.mas_equalTo(-30);
        make.width.height.mas_equalTo(50);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-30);
        make.trailing.mas_equalTo(-20);
        make.width.height.mas_equalTo(50);
    }];
    [super drawRect:rect];
}

#pragma mark - set data
- (void)configureImg:(UIImage *)img{
    self.resultImageView.image = img;
}

#pragma mark - init
- (UIImageView *)resultImageView{
    if (!_resultImageView) {
        _resultImageView = [[UIImageView alloc] init];
        _resultImageView.backgroundColor = [UIColor clearColor];
        _resultImageView.userInteractionEnabled = YES;
        [self addSubview:_resultImageView];
    }
    return _resultImageView;
}

- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _saveBtn.backgroundColor = [UIColor clearColor];
        [_saveBtn setImage:[UIImage imageNamed:@"camera-save"] forState:(UIControlStateNormal)];
        [self.resultImageView addSubview:_saveBtn];
    }
    return _saveBtn;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _cancelBtn.backgroundColor = [UIColor clearColor];
        [_cancelBtn setImage:[UIImage imageNamed:@"camera-cancel"] forState:(UIControlStateNormal)];
        [self.resultImageView addSubview:_cancelBtn];
    }
    return _cancelBtn;
}
@end
