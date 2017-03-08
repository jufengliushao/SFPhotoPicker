//
//  SFCameraVideoPevView.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/3/8.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFCameraVideoPevView.h"

@interface SFCameraVideoPevView(){
    AVCaptureVideoPreviewLayer *_videoLayer;
}

@end

@implementation SFCameraVideoPevView
- (instancetype)init{
    if (self = [super init]) {
        _videoLayer = [[SFCameraTool sharedInstance] sf_returnCameraLayer];
        [self.layer addSublayer: _videoLayer];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    _videoLayer.frame = self.bounds;
    [super drawRect:rect];
}
@end
