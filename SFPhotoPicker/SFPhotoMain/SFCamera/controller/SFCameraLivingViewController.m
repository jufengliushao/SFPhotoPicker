//
//  SFCameraLivingViewController.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/3/21.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFCameraLivingViewController.h"
#import "SFCameraVideoPevView.h"
@interface SFCameraLivingViewController ()

@property (nonatomic, strong) SFCameraVideoPevView *perView;

@end

@implementation SFCameraLivingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.perView);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [[SFCameraTool sharedInstance] sf_cameraStartRunning];
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [[SFCameraTool sharedInstance] sf_cameraStopRunning];
    [super viewDidDisappear:animated];
}

#pragma mark - init
- (SFCameraVideoPevView *)perView{
    if (!_perView) {
        _perView = [[SFCameraVideoPevView alloc] initWithType:(SFCameraLayerTypeLiving)];
        _perView.frame = self.view.bounds;
        [self.view addSubview:_perView];
    }
    return _perView;
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
