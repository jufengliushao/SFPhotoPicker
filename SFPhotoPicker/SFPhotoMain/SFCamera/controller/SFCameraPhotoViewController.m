//
//  SFCameraPhotoViewController.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/3/8.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFCameraPhotoViewController.h"
#import "SFCameraVideoPevView.h"
#import "SFCameraPhotoToolView.h"
// tool
#import "UIButton+SFButton.h"
@interface SFCameraPhotoViewController ()

@property (nonatomic, strong) SFCameraVideoPevView *cameraPreview;
@property (nonatomic, strong) SFCameraPhotoToolView *cameraToolView;

@end

@implementation SFCameraPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"%@", self.cameraPreview);
    [self blockAction];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[SFCameraTool sharedInstance] sf_cameraStartRunning];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[SFCameraTool sharedInstance] sf_cameraStopRunning];
}

#pragma mark - block action
- (void)blockAction{
    WS(ws);
    [self.cameraToolView.backBtn addTargetAction:^(UIButton *sender) {
        [ws dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
    [self.cameraToolView.flahBtn addTargetAction:^(UIButton *sender) {
        if (ws.cameraToolView.flashForbidBtn.isSelected) {
            [[SFThridMethod sharedInstance] showHUDWithText:@"请打开左边闪光灯" showTime:1.0 toview:ws.view];
            return ;
        }
        if (sender.isSelected) {
            sender.selected = NO;
            [[SFCameraTool sharedInstance] sf_setDeviceFlashAuto];
        }else{
            sender.selected = YES;
            [[SFCameraTool sharedInstance] sf_openDeviceFlash];
        }
    }];
    
    [self.cameraToolView.flashForbidBtn addTargetAction:^(UIButton *sender) {
        if(sender.isSelected){
            sender.selected = NO;
            [[SFCameraTool sharedInstance] sf_setDeviceFlashAuto];
        }else{
            sender.selected = YES;
            [[SFCameraTool sharedInstance] sf_closeDeviceFlash];
            ws.cameraToolView.flahBtn.selected = NO;
        }
    }];
    [self.cameraToolView.switchCameraBtn addTargetAction:^(UIButton *sender) {
        [[SFCameraTool sharedInstance] sf_switchCameraposition];
    }];
    [self.cameraToolView.shutterBtn addTargetAction:^(UIButton *sender) {
        [ws cameraPhotoShow];
    }];
}

- (void)cameraPhotoShow{
    WS(ws);
    [[SFCameraTool sharedInstance] sf_cameraShutterComplete:^(UIImage *img, NSError *err) {
        [ws.cameraToolView configureImg:img];
        [[SFCameraTool sharedInstance] sf_cameraStopRunning];
    }];
}

#pragma mark - init
- (SFCameraVideoPevView *)cameraPreview{
    if (!_cameraPreview) {
        _cameraPreview = [[SFCameraVideoPevView alloc] init];
        _cameraPreview.frame = self.view.bounds;
        [self.view addSubview:_cameraPreview];
    }
    return _cameraPreview;
}

- (SFCameraPhotoToolView *)cameraToolView{
    if (!_cameraToolView) {
        _cameraToolView = [[SFCameraPhotoToolView alloc] init];
        _cameraToolView.frame = self.view.bounds;
        [self.view addSubview:_cameraToolView];
    }
    return _cameraToolView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
