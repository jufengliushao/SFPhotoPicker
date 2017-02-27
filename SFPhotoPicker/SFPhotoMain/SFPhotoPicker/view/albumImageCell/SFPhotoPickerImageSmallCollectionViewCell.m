//
//  SFPhotoPickerImageSmallCollectionViewCell.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/2/27.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFPhotoPickerImageSmallCollectionViewCell.h"
#import "Masonry.h"

@implementation SFPhotoPickerImageSmallCollectionViewCell
#pragma mark - system method
- (void)drawRect:(CGRect)rect{
    [self.thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [super drawRect:rect];
}

#pragma mark - init
- (UIImageView *)thumbImageView{
    if (!_thumbImageView) {
        _thumbImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_thumbImageView];
    }
    return _thumbImageView;
}
@end
