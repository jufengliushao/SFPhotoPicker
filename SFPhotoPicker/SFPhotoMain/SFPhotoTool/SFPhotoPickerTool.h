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
typedef void(^CreatePhotoAlbumComplete)(PHAssetCollection *album, NSError * __autoreleasing* error);
typedef void(^SaveImageComplete)(BOOL isSuccess, NSError * __autoreleasing * err, NSString *imgID);

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
 获取指定相册下的所有缩略图片

 @param album <#album description#>
 @return <#return value description#>
 */
- (NSArray *)sf_getAllThumbOfAlbum:(PHAssetCollection *)album;

/**
 获取指定相册下所有的原图

 @param album <#album description#>
 @return <#return value description#>
 */
- (NSArray *)sf_getAllOriginalPfAlbum:(PHAssetCollection *)album;

/**
 返回指定相册名相册

 @param albumTitle 相册名
 @return 如果存在返回相册 不存在返回nil
 */
- (PHAssetCollection *)sf_returnAlbumWithTitle:(NSString *)albumTitle;

/**
 创建指定标题的相册

 @param albumTitle 相册标题
 @param complete 创建过程中的block 
                参数 nil nil 则该名称相册已存在
                    nil !nil 创建失败
                    !nil nil 创建成功
 */
- (void)sf_createAlbumWithTitle:(NSString *)albumTitle complete:(CreatePhotoAlbumComplete)complete;

/**
 异步----保存照片到相机相册

 @param img <#img description#>
 @param complete <#complete description#>
 */
- (void)sf_saveImageSynchronousInCameraAlbum:(UIImage *)img complete:(SaveImageComplete)complete;

/**
 同步----保存图片到相机相册

 @param img <#img description#>
 @param complete <#complete description#>
 */
- (void)sf_saveImageSynchronizationInCamareAlbum:(UIImage *)img complete:(SaveImageComplete)complete;

/**
 同步------将图片添加到自定义相册

 @param img 图片
 @param albumTitle 相册名称
 @param complete <#complete description#>
 */
- (void)sf_saveImageSynchronizationInAlbumWithImage:(UIImage *)img albumTitle:(NSString *)albumTitle complete:(SaveImageComplete)complete;

/**
 异步-------将图片添加到自定义相册

 @param img <#img description#>
 @param albumTitle <#albumTitle description#>
 @param complete <#complete description#>
 */
- (void)sf_saveImageSynchronousInAlbumWithImage:(UIImage *)img albumTitle:(NSString *)albumTitle complete:(SaveImageComplete)complete;
@end
