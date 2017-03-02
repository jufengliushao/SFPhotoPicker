//
//  SFPhotoPickerImageSmallCollectionViewCell.h
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/2/27.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFPhotoAssetInfoModel.h"
@interface SFPhotoPickerImageSmallCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *thumbImageView;
@property (nonatomic, strong) UIButton *indexBtn;

- (void)configureModel:(SFPhotoAssetInfoModel *)model;
@end
