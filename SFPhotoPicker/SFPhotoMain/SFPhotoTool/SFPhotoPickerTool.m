//
//  SFPhotoPickerTool.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/2/23.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFPhotoPickerTool.h"

static SFPhotoPickerTool *sf_ph = nil;

@implementation SFPhotoPickerTool
#pragma mark - init
+ (SFPhotoPickerTool *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sf_ph == nil) {
            sf_ph = [[SFPhotoPickerTool alloc] init];
        }
    });
    return sf_ph;
}

#pragma mark - user method
- (PHFetchResult<PHAssetCollection *> *)sf_getAllUserAlbum{
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    return assetCollections;
}
@end
