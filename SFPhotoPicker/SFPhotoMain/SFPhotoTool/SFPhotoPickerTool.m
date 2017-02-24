//
//  SFPhotoPickerTool.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/2/23.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFPhotoPickerTool.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

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

- (instancetype)init{
    if (self = [super init]) {
        [self sf_askPhotoRightStatus];
    }
    return self;
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
    if (!_hasPhotoRight) {
        return nil;
    }
    // 获得所有的自定义相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    return assetCollections;
}

- (PHAssetCollection *)sf_getCarmerPhotoAlbum{
    if (!_hasPhotoRight) {
        return nil;
    }
    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    return cameraRoll;
}

- (PHAssetCollection *)sf_getScreentShotAlbum{
    if (!_hasPhotoRight) {
        return nil;
    }
    // 获得相机胶卷
    PHAssetCollection *screenShot = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumScreenshots options:nil].lastObject;
    return screenShot;
}

- (PHAssetCollection *)sf_getRecentPhotoAlbum{
    if (!_hasPhotoRight) {
        return nil;
    }
    // 获得相机胶卷
    PHAssetCollection *recent = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumRecentlyAdded options:nil].lastObject;
    return recent;
}

- (NSArray *)sf_getAllThumbOfAlbum:(PHAssetCollection *)album{
    if (!_hasPhotoRight) {
        return nil;
    }
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

- (NSArray *)sf_getAllOriginalPfAlbum:(PHAssetCollection *)album{
    if (!_hasPhotoRight) {
        return nil;
    }
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:album options:nil];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (PHAsset *asset in assets) {
        CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
        
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [array addObject:result];
        }];
    }
    return array;
}

- (PHAssetCollection *)sf_returnAlbumWithTitle:(NSString *)albumTitle{
    // 从已存在相簿中查找这个应用对应的相簿
    if (!_hasPhotoRight) {
        return nil;
    }
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *assetCollection in assetCollections) {
        if ([assetCollection.localizedTitle isEqualToString:albumTitle]) {
            return assetCollection;
        }
    }
    return nil;
}

- (void)sf_createAlbumWithTitle:(NSString *)albumTitle complete:(CreatePhotoAlbumComplete)complete{
    if (!_hasPhotoRight) {
        complete(nil, nil);
        return;
    }
    NSError *err = nil;
    if ([self sf_returnAlbumWithTitle:albumTitle]) {
        // 相册已经存在
        if (complete) {
            complete(nil, &err);
        }
        return;
    }
    // PHAssetCollection的标识, 利用这个标识可以找到对应的PHAssetCollection对象(相簿对象)
    __block NSString *assetCollectionLocalIdentifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        // 创建相簿的请求
        assetCollectionLocalIdentifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumTitle].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&err];
    
    // 如果有错误信息
    if (err){
        if(complete){
            complete(nil, &err);
        }
        return;
    }
    
    if (complete) {
        complete([PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionLocalIdentifier] options:nil].lastObject, &err);
    }
}

- (void)sf_saveImageSynchronousInCameraAlbum:(UIImage *)img complete:(SaveImageComplete)complete{
    if (!_hasPhotoRight) {
        complete(NO, nil, nil);
        return;
    }
    // PHAsset的标识, 利用这个标识可以找到对应的PHAsset对象(图片对象)
    __block NSString *assetLocalIdentifier = nil;
    // 如果想对"相册"进行修改(增删改), 那么修改代码必须放在[PHPhotoLibrary sharedPhotoLibrary]的performChanges方法的block中
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 1.保存图片A到"相机胶卷"中
        // 创建图片的请求
        assetLocalIdentifier = [PHAssetCreationRequest creationRequestForAssetFromImage:img].placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (complete) {
            complete(success, &error, assetLocalIdentifier);
        }
    }];
}

- (void)sf_saveImageSynchronizationInCamareAlbum:(UIImage *)img complete:(SaveImageComplete)complete{
    if (!_hasPhotoRight) {
        complete(NO, nil, nil);
        return;
    }
    NSError *error = nil;
    __block NSString *imgID = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        // 默认就把相片保存到了相机胶卷
        imgID = [PHAssetChangeRequest creationRequestForAssetFromImage:img].placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    BOOL su = NO;
    if (!error) {
        su = YES;
    }
    if (complete) {
        complete(su, &error, imgID);
    }
}

- (void)sf_saveImageSynchronizationInAlbumWithImage:(UIImage *)img albumTitle:(NSString *)albumTitle complete:(SaveImageComplete)complete{
    if (!_hasPhotoRight) {
        complete(NO, nil, nil);
        return;
    }
    WS(ws);
    [self saveImageChecketAlbumANDCreat:albumTitle complete:^(PHAssetCollection *album, NSError *__autoreleasing *error) {
        if (album) {
            [ws saveImageSynchronizationInAlbumWithImage:img albumTitle:albumTitle complete:^(BOOL isSuccess, NSError *__autoreleasing *err, NSString *imgID) {
                if (complete) {
                    complete(isSuccess, err, imgID);
                }
            }];
        }else{
            // 创建相册失败
            if (complete) {
                complete(NO, error, nil);
            }
        }
    }];
}

- (void)sf_saveImageSynchronousInAlbumWithImage:(UIImage *)img albumTitle:(NSString *)albumTitle complete:(SaveImageComplete)complete{
    if (!_hasPhotoRight) {
        complete(NO, nil, nil);
        return;
    }
    WS(ws);
    [self saveImageChecketAlbumANDCreat:albumTitle complete:^(PHAssetCollection *album, NSError *__autoreleasing *error) {
        if (album) {
            // 创建成功
            [ws saveImageSynchronousInAlbumWithImage:img albumTitle:albumTitle complete:^(BOOL isSuccess, NSError *__autoreleasing *err, NSString *imgID) {
                if (complete) {
                    complete(isSuccess, err, imgID);
                }
            }];
        }else{
            // 创建失败
            if (complete) {
                complete(NO, error, nil);
            }
        }
    }];
}

#pragma mark - tool method
- (void)getAllAlbumInfo{
    if (!_hasPhotoRight) {
        return;
    }
    _ablumAllArray = [NSMutableArray arrayWithCapacity:0];
    // 遍历所有的自定义相簿
    for (PHAssetCollection *assetCollection in [self sf_getAllUserAlbum]) {
        SFPhotoAlbumInfoModel *model = [[SFPhotoAlbumInfoModel alloc] init];
        model.albumTitle = assetCollection.localizedTitle;
        model.photosSum = assetCollection.estimatedAssetCount;
        model.startDate = assetCollection.startDate;
        model.endDate = assetCollection.endDate;
        NSLog(@"%@", model.albumTitle);
        [_ablumAllArray addObject:model];
    }
}

- (void)saveImageChecketAlbumANDCreat:(NSString *)albumTitle complete:(CreatePhotoAlbumComplete)complete{
    PHAssetCollection *assetCollection = [self sf_returnAlbumWithTitle:albumTitle];
    if (assetCollection) {
        // 存在
        if (complete) {
            complete(assetCollection, nil);
        }
    }else{
        // 创建
        [self sf_createAlbumWithTitle:albumTitle complete:^(PHAssetCollection *album, NSError *__autoreleasing *error) {
            if (complete) {
                complete(album, error);
            }
        }];
    }
}

- (void)saveImageSynchronizationInAlbumWithImage:(UIImage *)img albumTitle:(NSString *)albumTitle complete:(SaveImageComplete)complete{
    PHAssetCollection *assetCollection = [self sf_returnAlbumWithTitle:albumTitle];
    [self sf_saveImageSynchronizationInCamareAlbum:img complete:^(BOOL isSuccess, NSError *__autoreleasing *err, NSString *imgID) {
        if (isSuccess) {
            NSError *error;
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                // 获得图片
                PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[imgID] options:nil].lastObject;
                // 添加图片到相簿中的请求
                PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                // 添加图片到相簿
                [request addAssets:@[asset]];
            } error:&error];
            BOOL su = NO;
            if (!error) {
                su = YES;
            }
            if (complete) {
                complete(su, &error, imgID);
            }
        }else{
            if (complete) {
                complete(isSuccess, err, imgID);
            }
        }
    }];
}

- (void)saveImageSynchronousInAlbumWithImage:(UIImage *)img albumTitle:(NSString *)albumTitle complete:(SaveImageComplete)complete{
    PHAssetCollection *assetCollection = [self sf_returnAlbumWithTitle:albumTitle];
    // PHAsset的标识, 利用这个标识可以找到对应的PHAsset对象(图片对象)
    __block NSString *assetLocalIdentifier = nil;
    // 如果想对"相册"进行修改(增删改), 那么修改代码必须放在[PHPhotoLibrary sharedPhotoLibrary]的performChanges方法的block中
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 1.保存图片A到"相机胶卷"中
        // 创建图片的请求
        assetLocalIdentifier = [PHAssetCreationRequest creationRequestForAssetFromImage:img].placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (!success) {
            if (complete) {
                complete(success, &error, assetLocalIdentifier);
            }
            return ;
        }
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetLocalIdentifier] options:nil].lastObject;
            PHAssetCollectionChangeRequest *reuqest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
            [reuqest addAssets:@[asset]];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (complete) {
                complete(success, &error, assetLocalIdentifier);
            }
        }];
    }];
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
