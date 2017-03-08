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
@end
