//
//  SFPhotoPickerImageSmallCollectionViewCell.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/2/27.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFPhotoPickerImageSmallCollectionViewCell.h"
#import "Masonry.h"


NSString * const defaultImg = @"radio.png";
NSString * const selectedImg = @"color-radio";

@interface SFPhotoPickerImageSmallCollectionViewCell(){
    SFPhotoAssetInfoModel *_dataModel;
}

@end

@implementation SFPhotoPickerImageSmallCollectionViewCell
#pragma mark - system method
- (instancetype)initWithFrame:(CGRect)frame{
    if (self= [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    WS(ws);
    [self.thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.radioImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(0).mas_offset(-8);
        make.top.mas_equalTo(0).mas_offset(8);
        make.width.height.mas_equalTo(20);
    }];
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(ws.radioImageView);
    }];
    [self.indexBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
        make.leading.mas_equalTo(ws.radioImageView.mas_leading).mas_offset(-20);
        make.bottom.mas_equalTo(ws.radioImageView.mas_bottom).mas_offset(20);
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
    
    self.radioImageView.image = model.isSelected ? [UIImage imageNamed:selectedImg] : [UIImage imageNamed:defaultImg];
    self.indexLabel.text = model.isSelected ? [NSString stringWithFormat:@"%ld", model.index] : @"";
}

#pragma mark - block action
- (NSString *)returnResourcePath{
    return [[NSBundle mainBundle] resourcePath];
}

- (NSString *)returnImgFilePath:(NSString *)imgName{
    return [NSString stringWithFormat:@"%@/%@", [self returnResourcePath], imgName];
}
#pragma mark - init
- (UIImageView *)thumbImageView{
    if (!_thumbImageView) {
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.backgroundColor = [UIColor whiteColor];
        _thumbImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_thumbImageView];
    }
    return _thumbImageView;
}

- (UIButton *)indexBtn{
    if(!_indexBtn){
        _indexBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_indexBtn setBackgroundColor:[UIColor clearColor]];
        [self.thumbImageView addSubview:_indexBtn];
    }
    return _indexBtn;
}

- (UIImageView *)radioImageView{
    if(!_radioImageView){
        _radioImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:defaultImg]];
        [self.thumbImageView addSubview:_radioImageView];
    }
    return _radioImageView;
}

- (UILabel *)indexLabel{
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.font = [UIFont systemFontOfSize:13];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        [self.radioImageView addSubview:_indexLabel];
    }
    return _indexLabel;
}
@end
