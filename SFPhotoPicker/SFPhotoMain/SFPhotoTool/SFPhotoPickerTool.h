//
//  SFPhotoPickerTool.h
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/2/23.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "SFPhotoAlbumInfoModel.h"

typedef void(^AskPhotoRightResult)(PHAuthorizationStatus stat);

@interface SFPhotoPickerTool : NSObject
/**
 init-method

 @return <#return value description#>
 */
+ (SFPhotoPickerTool *)sharedInstance;

@property (nonatomic, strong, readonly) NSArray *allAlbumInfoArr;
@property (nonatomic, assign, readonly) BOOL hasPhotoAlbumRight;

/**
 返回当前相册权限
 
 *PHAuthorizationStatusNotDetermined  未询问用户是否授权
 *PHAuthorizationStatusRestricted 未授权，例如家长控制
 *PHAuthorizationStatusDenied    未授权，用户拒绝造成的
 *PHAuthorizationStatusAuthorized   同意授权相册

 @return <#return value description#>
 */
- (PHAuthorizationStatus)sf_askPhotoRightStatus;

/**
 请求用户获得权限

 @param complete <#complete description#>
 */
- (void)sf_askPhotoRight:(AskPhotoRightResult)complete;


/**
 返回用户自定义的相册

 @return <#return value description#>
 */
- (PHFetchResult<PHAssetCollection *> *)sf_getAllUserAlbum;

/**
 返回用户相机胶卷相册

 @return <#return value description#>
 */
- (PHAssetCollection *)sf_getCarmerPhotoAlbum;

/**
 获取指定相册下的所有图片

 @param album <#album description#>
 @return <#return value description#>
 */
- (NSArray *)sf_getAllThumbOfAlbum:(PHAssetCollection *)album;
@end