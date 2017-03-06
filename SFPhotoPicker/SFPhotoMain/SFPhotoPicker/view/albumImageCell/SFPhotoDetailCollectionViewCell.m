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

- (void)layoutSubviews{
    WS(ws);
    CGFloat hStander = _dataModel.pixHeight / (CGFloat)_dataModel.pixWith * self.contentView.bounds.size.width;
    CGFloat h = hStander > self.contentView.bounds.size.height ? self.contentView.bounds.size.height : hStander;
    [self.photoImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(ws.contentView);
        make.width.mas_equalTo(self.contentView.bounds.size.width);
        make.height.mas_equalTo(h);
    }];
}

#pragma mark - set data
- (void)configureModel:(SFPhotoAssetInfoModel *)model{
    _dataModel = model;
    [self setNeedsLayout];
    if(model.originalImg){
        self.photoImageView.image = model.originalImg;
    }else{
        dispatch_async(dispatch_queue_create("load_img_queue", DISPATCH_QUEUE_CONCURRENT), ^{
            [[SFPhotoPickerTool sharedInstance] sf_getImageWithLocalIdentifier:model.localeIndefiner size:CGSizeMake(model.pixWith, model.pixHeight) isSynchronous:NO thum:NO complete:^(UIImage *result, NSDictionary *info) {
                if (model.localeIndefiner == _dataModel.localeIndefiner) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.photoImageView.image = result;
                        model.originalImg = result;
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
@end
