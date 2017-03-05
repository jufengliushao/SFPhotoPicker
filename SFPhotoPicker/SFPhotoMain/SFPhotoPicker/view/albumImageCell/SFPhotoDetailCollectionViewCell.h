//
//  SFPhotoDetailCollectionViewCell.h
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/3/5.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFPhotoAssetInfoModel.h"
#import "UIButton+SFButton.h"
@interface SFPhotoDetailCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UIImageView *indexImageView;
@property (nonatomic, strong) UIButton *indexBtn;
@property (nonatomic, strong) UILabel *indexLabel;

- (void)configureModel:(SFPhotoAssetInfoModel *)model;
@end
