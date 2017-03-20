//
//  SFCameraTool.h
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/3/8.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RequestCameraRightComplete)(AVAuthorizationStatus status);
typedef void(^PhotoCameraComplete)(UIImage *img, NSError *err);

@protocol SFCameraDelegate <NSObject>
@optional
/**
 相机聚焦完成回调
 */
- (void)sf_CamerafocusingComplete;

@end

@interface SFCameraTool : NSObject

/**
 单利初始化

 @return <#return value description#>
 */
+ (SFCameraTool *)sharedInstance;

@property (nonatomic, assign) id <SFCameraDelegate>delegate;

/**
 查询当前应用对相机的权限
 *AVAuthorizationStatusNotDetermined  未询问用户是否授权
 *AVAuthorizationStatusRestricted 未授权，例如家长控制
 *AVAuthorizationStatusDenied    未授权，用户拒绝造成的
 *AVAuthorizationStatusAuthorized   同意授权相册
 
 @return <#return value description#>
 */
- (AVAuthorizationStatus)sf_askCameraRightStuts;

/**
 请求对相机的使用权限

 @param complete <#complete description#>
 */
- (void)sf_askCameraRight:(RequestCameraRightComplete)complete;

/**
 返回摄像头获取资源的layer

 @return <#return value description#>
 */
- (AVCaptureVideoPreviewLayer *)sf_returnCameraLayer;

/**
 判断当前设备是否有摄像头

 @return <#return value description#>
 */
- (BOOL)sf_deviceHasFlash;

/**
 开启摄像头
 */
- (void)sf_cameraStartRunning;

/**
 关闭摄像头
 */
- (void)sf_cameraStopRunning;

/**
 强制打开闪光灯
 */
- (void)sf_openDeviceFlash;

/**
 强制关闭闪光灯
 */
- (void)sf_closeDeviceFlash;

/**
 设置闪光灯自动开启  根据需要
 */
- (void)sf_setDeviceFlashAuto;

/**
 切换摄像头
 */
- (void)sf_switchCameraposition;

/**
 放大缩小
 */
- (void)sf_changeCameraEffectiveScale:(CGFloat)scale;

/**
 设置聚焦

 @param point <#point description#>
 */
- (void)sf_setCameraFocusPoint:(CGPoint)point;

/**
 拍照
 */
- (void)sf_cameraShutterComplete:(PhotoCameraComplete)complete;

/**
 返回视频录制layer

 @return <#return value description#>
 */
- (AVCaptureVideoPreviewLayer *)sf_returnVideoPreviewLayer;
@end
