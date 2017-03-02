//
//  SFPhotoPickerImageSmallCollectionViewCell.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/2/27.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFPhotoPickerImageSmallCollectionViewCell.h"
#import "Masonry.h"

@interface SFPhotoPickerImageSmallCollectionViewCell(){
    SFPhotoAssetInfoModel *_dataModel;
}

@end

@implementation SFPhotoPickerImageSmallCollectionViewCell
#pragma mark - system method
- (void)drawRect:(CGRect)rect{
    [self.thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.indexBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-8);
        make.top.mas_equalTo(8);
        make.width.height.mas_equalTo(20);
    }];
    [super drawRect:rect];
}

#pragma mark - set data
- (void)configureModel:(SFPhotoAssetInfoModel *)model{
    _dataModel = model;
    if (_dataModel.thumbImg) {
        self.thumbImageView.image = _dataModel.thumbImg;
    }else{
        dispatch_async(dispatch_queue_create("load_img_queue", DISPATCH_QUEUE_CONCURRENT), ^{
            [[SFPhotoPickerTool sharedInstance] sf_getImageWithLocalIdentifier:model.localeIndefiner size:CGSizeMake(300, 300) isSynchronous:YES complete:^(UIImage *result, NSDictionary *info) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (_dataModel.localeIndefiner == model.localeIndefiner) {
                        self.thumbImageView.image = result;
                        _dataModel.thumbImg = result;
                    }
                });
            }];
        });
    }
}

#pragma mark - block action

#pragma mark - init
- (UIImageView *)thumbImageView{
    if (!_thumbImageView) {
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_thumbImageView];
    }
    return _thumbImageView;
}

- (UIButton *)indexBtn{
    if(!_indexBtn){
        _indexBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_indexBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _indexBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_indexBtn setBackgroundColor:[UIColor clearColor]];
        [self.thumbImageView addSubview:_indexBtn];
    }
    return _indexBtn;
}
@end
