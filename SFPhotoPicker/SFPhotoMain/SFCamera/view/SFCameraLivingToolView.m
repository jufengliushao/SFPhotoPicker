//
//  SFCameraLivingToolView.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/3/21.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFCameraLivingToolView.h"
#import "Masonry.h"
@implementation SFCameraLivingToolView
#pragma mark - system method
- (instancetype)init{
    if(self = [super init]){
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    WS(ws);
    [self.livingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(ws);
    }];
    [super drawRect:rect];
}

#pragma mark - method

#pragma mark - init
- (UIButton *)livingBtn{
    if (!_livingBtn) {
        _livingBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_livingBtn setTitle:@"start" forState:(UIControlStateNormal)];
        [_livingBtn setTitle:@"pasue" forState:(UIControlStateSelected)];
        [_livingBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal | UIControlStateSelected)];
        [self addSubview:_livingBtn];
    }
    return _livingBtn;
}
@end
