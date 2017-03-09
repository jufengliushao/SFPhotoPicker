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
@interface SFCameraPhotoViewController ()

@property (nonatomic, strong) SFCameraVideoPevView *cameraPreview;
@property (nonatomic, strong) SFCameraPhotoToolView *cameraToolView;

@end

@implementation SFCameraPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"%@", self.cameraPreview);
    NSLog(@"%@", self.cameraToolView);
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
