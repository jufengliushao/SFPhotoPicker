//
//  SFCameraMovieViewController.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/3/20.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFCameraMovieViewController.h"
#import "SFCameraVideoPevView.h"
@interface SFCameraMovieViewController ()
@property (nonatomic, strong) SFCameraVideoPevView *moviePerView;
@end

@implementation SFCameraMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.moviePerView);
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

#pragma mark - init
- (SFCameraVideoPevView *)moviePerView{
    if (!_moviePerView) {
        _moviePerView = [[SFCameraVideoPevView alloc] initWithType:(SFCameraLayerTypeVideo)];
        _moviePerView.frame = self.view.bounds;
        [self.view addSubview:_moviePerView];
    }
    return _moviePerView;
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
