//
//  SFPhotoAssetInfoModel.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/2/27.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFPhotoAssetInfoModel.h"

@implementation SFPhotoAssetInfoModel
- (instancetype)init{
    if (self = [super init]) {
        self.index = 0;
        self.isSelected = NO;
    }
    return self;
}
@end
