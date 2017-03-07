//
//  SFPhotoThumbHeaderView.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/3/7.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFPhotoThumbHeaderView.h"
#import "Masonry.h"
@implementation SFPhotoThumbHeaderView
#pragma mark - system method
- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    WS(ws);
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws);
        make.trailing.mas_equalTo(-10);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(ws);
    }];
    [super drawRect:rect];
}

#pragma mark - init
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [self addSubview:_cancelBtn];
    }
    return _cancelBtn;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"SFPhotoPicker";
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}
@end
