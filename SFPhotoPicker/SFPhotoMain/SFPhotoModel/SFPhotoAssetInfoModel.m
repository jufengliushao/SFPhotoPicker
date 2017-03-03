//
//  SFPhotoAssetInfoModel.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/2/27.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFPhotoAssetInfoModel.h"

@interface SFPhotoAssetInfoModel(){
    BOOL _select;
    NSInteger _in;
}

@end

@implementation SFPhotoAssetInfoModel
- (instancetype)init{
    if (self = [super init]) {
        self.index = 0;
        _select = NO;
    }
    return self;
}

#pragma mark - setter
- (void)setIndex:(NSInteger)index{
    _in = index;
    if (index == 0) {
        _select = NO;
    }else{
        _select = YES;
    }
}

#pragma mark - getter
- (BOOL)isSelected{
    return _select;
}

- (NSInteger)index{
    return _in;
}
@end
