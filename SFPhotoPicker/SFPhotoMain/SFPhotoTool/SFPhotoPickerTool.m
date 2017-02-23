//
//  SFPhotoPickerTool.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/2/23.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFPhotoPickerTool.h"

@interface SFPhotoPickerTool(){
    NSMutableArray *_ablumAllArray;
}

@end

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

- (PHAssetCollection *)sf_getCarmerPhotoAlbum{
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    return cameraRoll;
}

#pragma mark - tool method
- (void)getAllAlbumTitle{
    _ablumAllArray = [NSMutableArray arrayWithCapacity:0];
    // 遍历所有的自定义相簿
    for (PHAssetCollection *assetCollection in [self sf_getAllUserAlbum]) {
        SFPhotoAlbumInfoModel *model = [[SFPhotoAlbumInfoModel alloc] init];
        model.albumTitle = assetCollection.localizedTitle;
        model.photosSum = assetCollection.estimatedAssetCount;
        model.startDate = assetCollection.startDate;
        model.endDate = assetCollection.endDate;
        [_ablumAllArray addObject:model];
    }
}

#pragma mark - getter
- (NSArray *)allAlbumInfoArr{
    if (!_ablumAllArray) {
        [self getAllAlbumTitle];
    }
    return _ablumAllArray;
}
@end
