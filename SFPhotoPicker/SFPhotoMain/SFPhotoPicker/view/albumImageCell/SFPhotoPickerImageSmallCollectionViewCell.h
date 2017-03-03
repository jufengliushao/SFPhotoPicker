//
//  SFPhotoPickerImageSmallCollectionViewCell.h
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/2/27.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFPhotoAssetInfoModel.h"
#import "UIButton+SFButton.h"
@interface SFPhotoPickerImageSmallCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *thumbImageView;
@property (nonatomic, strong) UIButton *indexBtn;
@property (nonatomic, strong) UIImageView *radioImageView;
@property (nonatomic, strong) UILabel *indexLabel;

- (void)configureModel:(SFPhotoAssetInfoModel *)model;
@end
