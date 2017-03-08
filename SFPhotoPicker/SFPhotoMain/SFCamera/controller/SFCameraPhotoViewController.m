//
//  SFCameraPhotoViewController.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/3/8.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFCameraPhotoViewController.h"
#import "SFCameraVideoPevView.h"
@interface SFCameraPhotoViewController ()

@property (nonatomic, strong) SFCameraVideoPevView *cameraPreview;

@end

@implementation SFCameraPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"%@", self.cameraPreview);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
