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
- (instancetype)initWithType:(SFCameraLayerType)layerType{
    if (self = [super init]) {
        if (layerType == SFCameraLayerTypePhoto) {
            _videoLayer = [[SFCameraTool sharedInstance] sf_returnCameraLayer];
        }else if(layerType == SFCameraLayerTypeVideo){
            _videoLayer = [[SFCameraTool sharedInstance] sf_returnVideoPreviewLayer];
        }else{
            _videoLayer = [[SFCameraTool sharedInstance] sf_returnLivingPreviewLayer];
        }
        self.layer.masksToBounds = YES;
        [self.layer addSublayer: _videoLayer];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    _videoLayer.frame = self.bounds;
    [super drawRect:rect];
}
@end
