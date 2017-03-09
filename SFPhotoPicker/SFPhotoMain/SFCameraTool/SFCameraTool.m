//
//  SFCameraTool.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/3/8.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFCameraTool.h"

@interface SFCameraTool (){
    BOOL _hasCameraRight;
    AVCaptureSession *_captureSession; /* AVCaptureSession对象来执行输入设备和输出设备之间的数据传递 */
    AVCaptureDevice *_captureDevice;
    AVCaptureDeviceInput *_captureDeviceInput;/* 输入设备 */
    AVCaptureStillImageOutput *_stillImageOutput;/* 照片输出流 */
    AVCaptureVideoPreviewLayer *_videoPreviewLayer;/* 预览图层 */
}

@end

SFCameraTool *camera = nil;

@implementation SFCameraTool
+ (SFCameraTool *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!camera) {
            camera = [[SFCameraTool alloc] init];
        }
    });
    return camera;
}

- (instancetype)init{
    if (self = [super init]) {
        _hasCameraRight = NO;
        _captureSession = [[AVCaptureSession alloc] init];
        _captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return self;
}

#pragma mark - public method
- (AVAuthorizationStatus)sf_askCameraRightStuts{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusAuthorized) {
        _hasCameraRight = YES;
    }else{
        _hasCameraRight = NO;
    }
    return status;
}

- (void)sf_askCameraRight:(RequestCameraRightComplete)complete{
    WS(ws);
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (complete) {
            complete([ws sf_askCameraRightStuts]);
        }
    }];
}

- (AVCaptureVideoPreviewLayer *)sf_returnCameraLayer{
    NSError *error;
    [_captureDevice lockForConfiguration:nil];
    //设置闪光灯为自动
    [_captureDevice setFlashMode:AVCaptureFlashModeOff];
    [_captureDevice unlockForConfiguration];
    
    _captureDeviceInput= [[AVCaptureDeviceInput alloc] initWithDevice:_captureDevice error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
    }
    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [_stillImageOutput setOutputSettings:dic];
    if ([_captureSession canAddOutput:_stillImageOutput]) {
        [_captureSession addOutput:_stillImageOutput];
    }
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    return _videoPreviewLayer;
}

- (BOOL)sf_deviceHasFlash{
    return [_captureDevice hasFlash];
}

- (void)sf_cameraStartRunning{
    if (_captureSession) {
        [_captureSession startRunning];
    }
}

- (void)sf_cameraStopRunning{
    if(_captureSession){
        [_captureSession stopRunning];
    }
}

- (void)sf_openDeviceFlash{
    if ([self sf_deviceHasFlash]) {
        [_captureDevice lockForConfiguration:nil];
        _captureDevice.flashMode = AVCaptureFlashModeOn;
        [_captureDevice unlockForConfiguration];
    }
}


#pragma mark - method
@end
