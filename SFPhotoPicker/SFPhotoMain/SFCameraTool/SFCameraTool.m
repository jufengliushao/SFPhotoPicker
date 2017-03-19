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
    AVCaptureDevicePosition _desiredPosition; /* 摄像头方向 */
    AVCaptureConnection *_captureConnection; 
    CGFloat _beginScale;
    CGFloat _effectiveScale;
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
        _desiredPosition = AVCaptureDevicePositionBack;
        _effectiveScale = 1.0;
        _beginScale = 1.0;
    }
    return self;
}

- (void)dealloc{
    [_captureDevice removeObserver:self forKeyPath:@"adjustingFocus" context:nil];
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
    [_captureDevice setFlashMode:AVCaptureFlashModeAuto];
    _captureDevice.focusPointOfInterest = CGPointMake(0, 0);
    _captureDevice.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    [self addFocuseValueObserving];
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
    [self setDeviceFlashModel:AVCaptureFlashModeOn torchMode:(AVCaptureTorchModeOn)];
}

- (void)sf_closeDeviceFlash{
    [self setDeviceFlashModel:AVCaptureFlashModeOff torchMode:(AVCaptureTorchModeOff)];
}

- (void)sf_setDeviceFlashAuto{
    [self setDeviceFlashModel:AVCaptureFlashModeAuto torchMode:(AVCaptureTorchModeAuto)];
}

- (void)sf_switchCameraposition{
    _desiredPosition = _desiredPosition == AVCaptureDevicePositionBack ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
    [self resetDeviceWithPosition];
    [self resetDeviceInput];
}

- (void)sf_changeCameraEffectiveScale:(CGFloat)scale{
    if (_desiredPosition == AVCaptureDevicePositionFront) {
        return;
    }
    if ([_captureDevice lockForConfiguration:nil]) {
        CGFloat currentFactor = _captureDevice.videoZoomFactor;
        CGFloat maxFactor = _captureDevice.activeFormat.videoMaxZoomFactor;
        currentFactor = MIN(MIN(maxFactor, 3.0), MAX(scale + currentFactor, 1.0));
        _captureDevice.videoZoomFactor = currentFactor;
        [_captureDevice unlockForConfiguration];
    }
}

- (void)sf_setCameraFocusPoint:(CGPoint)point{
    if([_captureDevice lockForConfiguration:nil]){
        if ([_captureDevice isFocusPointOfInterestSupported]) {
            _captureDevice.focusPointOfInterest = point;
            _captureDevice.focusMode = AVCaptureFocusModeAutoFocus;
        }
        [_captureDevice unlockForConfiguration];
    }
}

- (void)sf_cameraShutterComplete:(PhotoCameraComplete)complete{
    _captureConnection = [_stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:_captureConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *img = [UIImage imageWithData:jpegData];
        if(complete){
            complete(img, error);
        }
    }];
}
#pragma mark - method
- (void)setDeviceFlashModel:(AVCaptureFlashMode)flashMode torchMode:(AVCaptureTorchMode)trochMode{
    if ([self sf_deviceHasFlash]) {
        if ([_captureDevice lockForConfiguration:nil]) {
            _captureDevice.flashMode = flashMode;
            [_captureDevice setTorchMode:(trochMode)];
            [_captureDevice unlockForConfiguration];
        }
    }
}

- (void)resetDeviceWithPosition{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *d in devices) {
        if (d.position == _desiredPosition) {
            _captureDevice = d;
            break;
        }
    }
}

- (void)resetDeviceInput{
    [_captureSession beginConfiguration];
    [_captureSession removeInput:_captureDeviceInput];
    _captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:_captureDevice error:nil];
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
    }
    [_captureSession commitConfiguration];
}

- (void)addFocuseValueObserving{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [_captureDevice addObserver:self forKeyPath:@"adjustingFocus" options:(NSKeyValueObservingOptionNew) context:nil];
    });
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"adjustingFocus"]) {
        if (![change[@"new"] boolValue]) {
            // focusing complete
            if (_delegate && [_delegate respondsToSelector:@selector(sf_CamerafocusingComplete)]) {
                [_delegate sf_CamerafocusingComplete];
            }
        }
    }
}
@end
