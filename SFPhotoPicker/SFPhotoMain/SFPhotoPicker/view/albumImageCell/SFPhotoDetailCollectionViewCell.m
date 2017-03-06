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

NSString * const defaultImg_big = @"radio.png";
NSString * const selectedImg_big = @"color-radio";

@implementation SFPhotoDetailCollectionViewCell
#pragma mark - system method
- (instancetype)init{
    if (self = [super init]) {
        self.contentView.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    WS(ws);
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.width.mas_equalTo(_dataModel.pixWith);
        make.height.mas_equalTo(_dataModel.pixHeight);
    }];
    [self.indexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.trailing.mas_equalTo(-15);
        make.top.mas_equalTo(15);
    }];
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(ws.indexImageView);
    }];
    [self.indexBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.indexImageView).mas_offset(-10);
        make.trailing.mas_equalTo(ws.indexImageView).mas_equalTo(10);
        make.leading.bottom.mas_equalTo(ws.indexImageView).mas_equalTo(20);
    }];
    [super drawRect:rect];
}

#pragma mark - set data
- (void)configureModel:(SFPhotoAssetInfoModel *)model{
    _dataModel = model;
    self.indexLabel.text = model.isSelected ? [NSString stringWithFormat:@"%ld", model.index] : @"";
    self.indexImageView.image = model.isSelected ? [UIImage imageNamed:selectedImg_big] : [UIImage imageNamed:selectedImg_big];
    if(model.originalImg){
        self.photoImageView.image = model.originalImg;
    }else{
        dispatch_async(dispatch_queue_create("load_img_queue", DISPATCH_QUEUE_CONCURRENT), ^{
            [[SFPhotoPickerTool sharedInstance] sf_getImageWithLocalIdentifier:model.localeIndefiner size:CGSizeMake(model.pixWith, model.pixHeight) isSynchronous:NO complete:^(UIImage *result, NSDictionary *info) {
                if (model.localeIndefiner == _dataModel.localeIndefiner) {
                    model.originalImg = result;
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        self.photoImageView.image = result;
                    });
                }
            }];
        });
    }
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
        _indexImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:defaultImg_big]];
        _indexImageView.backgroundColor = [UIColor blackColor];
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
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_indexLabel];
    }
    return _indexLabel;
}
@end
