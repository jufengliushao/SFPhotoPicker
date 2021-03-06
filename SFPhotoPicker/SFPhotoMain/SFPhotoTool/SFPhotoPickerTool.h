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
#import "SFPhotoAssetInfoModel.h"

typedef void(^AskPhotoRightResult)(PHAuthorizationStatus stat);
typedef void(^CreatePhotoAlbumComplete)(PHAssetCollection *album, NSError * __autoreleasing* error);
typedef void(^SaveImageComplete)(BOOL isSuccess, NSError * __autoreleasing * err, NSString *imgID);
typedef void(^GetImageResult)(UIImage *result, NSDictionary *info);

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
 返回用户自定义的相册----逻辑相册

 @return <#return value description#>
 */
- (PHFetchResult<PHAssetCollection *> *)sf_getAllUserAlbum;

/**
 返回用户相机胶卷相册

 @return <#return value description#>
 */
- (PHAssetCollection *)sf_getCarmerPhotoAlbum;

/**
 缓存指定相册的图片------size需要与展示的size一致，否则不会走缓存

 @param assets albumModel -> assetsArr
 @param targetSize <#targetSize description#>
 */
- (void)sf_cachingImageWithAssets:(NSArray *)assets targetSize:(CGSize)targetSize;

/**
 缓存指定图片

 @param localIndentifier <#localIndentifier description#>
 @param targetSize <#targetSize description#>
 */
- (void)sf_cachingImageWitlLocalIndentifier:(NSString *)localIndentifier targetSize:(CGSize)targetSize;

/**
 返回用户手机截图相册

 @return <#return value description#>
 */
- (PHAssetCollection *)sf_getScreentShotAlbum;

/**
 返回用户最近添加的照片

 @return <#return value description#>
 */
- (PHAssetCollection *)sf_getRecentPhotoAlbum;

/**
 获取指定相册下的所有缩略图片id

 @param album <#album description#>
 @return <#return value description#>
 */
- (NSArray *)sf_getAllThumbOfAlbum:(PHAssetCollection *)album;

/**
 获取指定相册下所有的原图id

 @param album <#album description#>
 @return <#return value description#>
 */
- (NSArray *)sf_getAllOriginalOfAlbum:(PHAssetCollection *)album;

/**
 根据图片的id获取图片

 @param localIndetifier 图片的id
 @param synchronous 是否同步获取
 @param thumb 是否为缩略图
 @param complete 完成回调
 */
- (void)sf_getImageWithLocalIdentifier:(NSString *)localIndetifier size:(CGSize)size isSynchronous:(BOOL)synchronous thum:(BOOL)thumb complete:(GetImageResult)complete;

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
