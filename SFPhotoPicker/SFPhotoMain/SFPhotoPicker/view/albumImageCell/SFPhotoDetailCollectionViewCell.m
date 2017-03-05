//
//  SFPhotoDetailCollectionViewCell.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/3/5.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFPhotoDetailCollectionViewCell.h"
#import "Masonry.h"

@interface SFPhotoDetailCollectionViewCell(){
    SFPhotoAssetInfoModel *_dataModel;
}

@end

NSString * const defaultImg = @"radio.png";
NSString * const selectedImg = @"color-radio";

@implementation SFPhotoDetailCollectionViewCell
#pragma mark - system method
- (instancetype)init{
    if (self = [super init]) {
        self.contentView.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
}

#pragma mark - set data
- (void)configureModel:(SFPhotoAssetInfoModel *)model{
    _dataModel = model;
    self.indexLabel.text = model.isSelected ? [NSString stringWithFormat:@"%ld", model.index] : @"";
    self.indexImageView.image = model.isSelected ? [UIImage imageNamed:selectedImg] : [UIImage imageNamed:selectedImg];
}

#pragma mark - init
- (UIImageView *)photoImageView{
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_photoImageView];
    }
    return _photoImageView;
}

- (UIImageView *)indexImageView{
    if (!_indexImageView) {
        _indexImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:defaultImg]];
        [self.contentView addSubview:_indexImageView];
    }
    return _indexImageView;
}

- (UIButton *)indexBtn{
    if (!_indexBtn) {
        _indexBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_indexBtn setBackgroundColor:[UIColor clearColor]];
        
        [self.contentView addSubview:_indexBtn];
    }
    return _indexBtn;
}

- (UILabel *)indexLabel{
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_indexLabel];
    }
    return _indexLabel;
}
@end
