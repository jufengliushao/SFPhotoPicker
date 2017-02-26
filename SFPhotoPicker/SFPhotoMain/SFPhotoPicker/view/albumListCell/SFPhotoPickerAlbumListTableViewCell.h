//
//  SFPhotoPickerAlbumListTableViewCell.h
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/2/26.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFPhotoAlbumInfoModel.h"
@interface SFPhotoPickerAlbumListTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)configureModel:(SFPhotoAlbumInfoModel *)configure;
@end
