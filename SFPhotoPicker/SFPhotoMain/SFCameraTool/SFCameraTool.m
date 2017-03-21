//
//  SFCameraTool.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/3/8.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFCameraTool.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface SFCameraTool ()<AVCaptureFileOutputRecordingDelegate, AVCaptureAudioDataOutputSampleBufferDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>{
    BOOL _hasCameraRight;
    AVCaptureSession *_captureSession; /* AVCaptureSession对象来执行输入设备和输出设备之间的数据传递 */
    AVCaptureDevice *_captureDevice;
    AVCaptureDeviceInput *_captureDeviceInput;/* 输入设备 */
    AVCaptureDeviceInput *_audioDeviceInput; /* 音频输入 */
    AVCaptureStillImageOutput *_stillImageOutput;/* 照片输出流 */
    AVCaptureMovieFileOutput *_movieOutput; /* 录制视频输出流 */
    AVCaptureVideoDataOutput *_videoDataOutput; /* 视频流输出 */
    AVCaptureAudioDataOutput *_audioDataOutput; /* 音频流输出 */
    AVCaptureVideoPreviewLayer *_videoPreviewLayer;/* 预览图层 */
    dispatch_queue_t _videoDataQueue;
    dispatch_queue_t _audioDataQueue;
    AVCaptureDevicePosition _desiredPosition; /* 摄像头方向 */
    AVCaptureConnection *_captureConnection;
    AVCaptureConnection *_videoLivingConnect;
    AVCaptureConnection *_audioLivingConnect;
    CGFloat _beginScale;
    CGFloat _effectiveScale;
    NSURL *_videoURL;
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
    [self changeCameraTypePublicMethod];
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

- (AVCaptureVideoPreviewLayer *)sf_returnVideoPreviewLayer{
    [self changeCameraTypePublicMethod];
    [_captureDevice lockForConfiguration:nil];
    NSError *error;
    _audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio] error:&error];
    // 添加音频流 添加视频输出流
    if([_captureSession canAddInput:_audioDeviceInput]){
        [_captureSession addInput:_audioDeviceInput];
    }
    [_captureSession removeOutput:_stillImageOutput];
    _movieOutput = [[AVCaptureMovieFileOutput alloc] init];
    if ([_captureSession canAddOutput:_movieOutput]) {
        [_captureSession addOutput:_movieOutput];
    }
    [_captureDevice unlockForConfiguration];
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    return _videoPreviewLayer;
}

- (void)sf_movieCarmeraStartRecoder{
    _captureConnection = [_movieOutput connectionWithMediaType:AVMediaTypeVideo];
    AVCaptureVideoOrientation avcaptureOrientation = AVCaptureVideoOrientationPortrait;
    [_captureConnection setVideoOrientation:avcaptureOrientation];
    [_captureConnection setVideoScaleAndCropFactor:1.0];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"outPut.mov"]];
    if (!_movieOutput.isRecording) {
        [_movieOutput startRecordingToOutputFileURL:url recordingDelegate:self];
    }
}

- (void)sf_movieCameraStopRecoder{
    [_movieOutput stopRecording];
}

- (void)sf_saveCameraMovieInPhotoAlbumComplete:(SaveMovieComplete)complete{
    if (!_videoURL) {
        return;
    }
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    [lib writeVideoAtPathToSavedPhotosAlbum:_videoURL completionBlock:^(NSURL *assetURL, NSError *error) {
        if (complete) {
            complete(assetURL, error);
        }
        [[NSFileManager defaultManager] removeItemAtURL:_videoURL error:nil];
    }];
}

- (AVCaptureVideoPreviewLayer *)sf_returnLivingPreviewLayer{
    [self changeCameraTypePublicMethod];
     NSError *error = nil;
    AVCaptureDevice *audioLivingDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDevice *videoLivingDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *audioLivingInput = [AVCaptureDeviceInput deviceInputWithDevice:audioLivingDevice error:&error];
    AVCaptureDeviceInput *videoLivingInput = [AVCaptureDeviceInput deviceInputWithDevice:videoLivingDevice error:&error];
    if (error) {
        NSLog(@"Error getting  input device: %@", error.description);
        return nil;
    }
    _captureSession = [[AVCaptureSession alloc] init];
    if([_captureSession canAddInput:audioLivingInput]){
        [_captureSession addInput:audioLivingInput];
    }
    if ([_captureSession canAddInput:videoLivingInput]) {
        [_captureSession addInput:videoLivingInput];
    }
    _videoDataQueue = dispatch_queue_create("living.sf.videoQueue", DISPATCH_QUEUE_SERIAL);
    _audioDataQueue = dispatch_queue_create("living.sf.audioQueue", DISPATCH_QUEUE_SERIAL);
    _videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    _audioDataOutput = [[AVCaptureAudioDataOutput alloc] init];
    [_videoDataOutput setSampleBufferDelegate:self queue:_videoDataQueue];
    [_audioDataOutput setSampleBufferDelegate:self queue:_audioDataQueue];
     NSDictionary *captureSettings = @{(NSString*)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};
    _videoDataOutput.videoSettings = captureSettings;
    _videoDataOutput.alwaysDiscardsLateVideoFrames = YES;
    if ([_captureSession canAddOutput:_videoDataOutput]) {
        [_captureSession addOutput:_videoDataOutput];
    }
    if([_captureSession canAddOutput:_audioDataOutput]){
        [_captureSession addOutput:_audioDataOutput];
    }
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];

    return _videoPreviewLayer;
}

- (void)sf_startLiving{
    _videoLivingConnect = [_videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    _audioLivingConnect = [_audioDataOutput connectionWithMediaType:AVMediaTypeAudio];
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

- (void)initForDevice{
    [_captureDevice lockForConfiguration:nil];
    //设置闪光灯为自动
    [_captureDevice setFlashMode:AVCaptureFlashModeAuto];
    _captureDevice.focusPointOfInterest = CGPointMake(0, 0);
    _captureDevice.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    [self addFocuseValueObserving];
    [_captureDevice unlockForConfiguration];
}

- (void)initForDeviceInput{
    NSError *error;
    _captureDeviceInput= [[AVCaptureDeviceInput alloc] initWithDevice:_captureDevice error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
    }
}

- (void)changeCameraTypePublicMethod{
    if (_captureSession.isRunning) {
        [self sf_cameraStopRunning];
    }
    [self initForDevice];
    if(!_captureDeviceInput){
        [self initForDeviceInput];
    }
}

#pragma mark -AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    _videoURL = outputFileURL;
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    if(connection == _videoLivingConnect){
        // 视频输出
        NSLog(@"videoConnect");
    }else if(connection == _audioLivingConnect){
        // 音频输出
        NSLog(@"audioConnect");
    }
}
@end
