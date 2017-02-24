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
    BOOL _hasPhotoRight;
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

#pragma mark - system method
- (PHAuthorizationStatus)sf_askPhotoRightStatus{
    PHAuthorizationStatus photoAuthStatus = [PHPhotoLibrary authorizationStatus];
    switch (photoAuthStatus) {
        case PHAuthorizationStatusNotDetermined:{
            NSLog(@"未询问用户是否授权");
            _hasPhotoRight = NO;
        }
            break;
            
        case PHAuthorizationStatusRestricted:{
            NSLog(@"未授权，例如家长控制");
            _hasPhotoRight = NO;
        }
            break;
            
        case PHAuthorizationStatusDenied:{
            NSLog(@"未授权，用户拒绝造成的");
            _hasPhotoRight = NO;
        }
            break;
            
        case PHAuthorizationStatusAuthorized:{
            NSLog(@"同意授权相册");
            _hasPhotoRight = YES;
        }
            break;
        default:
            break;
    }
    return photoAuthStatus;
}

- (void)sf_askPhotoRight:(AskPhotoRightResult)complete{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            NSLog(@"用户同意授权相册");
            _hasPhotoRight = YES;
        }else {
            NSLog(@"用户拒绝授权相册");
            _hasPhotoRight = NO;
        }
        if (complete) {
            complete(status);
        }
    }];
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

- (NSArray *)sf_getAllThumbOfAlbum:(PHAssetCollection *)album{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:album options:nil];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (PHAsset *asset in assets) {
        CGSize size = CGSizeZero;
        
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [array addObject:result];
        }];
    }
    return array;
}

#pragma mark - tool method
- (void)getAllAlbumInfo{
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
        [self getAllAlbumInfo];
    }
    return _ablumAllArray;
}

- (BOOL)hasPhotoAlbumRight{
    [self sf_askPhotoRightStatus];
    return _hasPhotoRight;
}
@end