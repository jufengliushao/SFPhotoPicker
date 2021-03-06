//
//  SFPhotoAssetInfoModel.h
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/2/27.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFPhotoAssetInfoModel : NSObject

@property (nonatomic, copy) NSString *localeIndefiner;
@property (nonatomic, assign, readonly) BOOL isSelected;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIImage *thumbImg;
@property (nonatomic, strong) UIImage *originalImg;
@property (nonatomic, assign) NSUInteger pixWith;
@property (nonatomic, assign) NSUInteger pixHeight;

@end
