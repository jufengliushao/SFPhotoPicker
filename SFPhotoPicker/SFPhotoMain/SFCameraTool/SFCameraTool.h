//
//  SFCameraTool.h
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/3/8.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RequestCameraRightComplete)(AVAuthorizationStatus status);

@interface SFCameraTool : NSObject

/**
 单利初始化

 @return <#return value description#>
 */
+ (SFCameraTool *)sharedInstance;

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

- (AVCaptureVideoPreviewLayer *)sf_returnCameraLayer;
@end
