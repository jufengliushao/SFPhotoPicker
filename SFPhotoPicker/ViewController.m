//
//  ViewController.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/2/23.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "ViewController.h"
// album list
#import "SFPhotoAlbumListViewController.h"
// camera
#import "SFCameraPhotoViewController.h"
#import "SFCameraMovieViewController.h"
#import "SFCameraLivingViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *_titleArr;
    SFPhotoPickerTool *_tool;
    SFCameraTool *_cameraTool;
}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

static NSString *kHomeCellID = @"kHomeCellID";

@implementation ViewController
#pragma mark - system method
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    // setData
    _titleArr = @[@"当前手机相册权限状态", @"获取手机相册权限", @"相册列表", @"获取手机摄像头权限状态", @"获取手机摄像头权限", @"判断设备是否支持闪光灯", @"拍照", @"录像", @"LIVING"];
    _tool = [SFPhotoPickerTool sharedInstance];
    _cameraTool = [SFCameraTool sharedInstance];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"SFPhotoPicker";
}

#pragma mark - method
- (void)setTableView{
    self.mainTableView.tableFooterView = [[UIView alloc] init];
    [self.mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kHomeCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHomeCellID forIndexPath:indexPath];
    cell.textLabel.text = _titleArr[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
            // 获取手机相册权限当前状态
            [self getPhotoRightStatus];
        }
            break;
            
        case 1:{
            // 获取手机相册权限
            [self askPhotoRight];
        }
            break;
            
        case 2:{
            // 相册列表
            if([self canGoNextStep]){
                [self showUserAlbum];
            }
        }
            break;
            
        case 3:{
            // 获取手机摄像头权限状态
            [self getCamreaRightStatus];
        }
            break;
            
        case 4:{
            // 获取手机摄像头权限
            [self askCameraRight];
        }
            break;
            
        case 5:{
            // 判断设备是否支持闪光灯
            if ([self canGoCameraStep]) {
                [self judgementDeviceHasFlas];
            }
        }
            break;
            
        case 6:{
            // 拍照
            if ([self canGoCameraStep]) {
                [self showCameraPhoto];
            }
        }
            break;
            
        case 7:{
            // 录像
            if ([self canGoCameraStep]) {
                [self showCameraMovie];
            }
        }
            break;
            
        case 8:{
            // living
            if ([self canGoCameraStep]) {
                [self showCameraLiving];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - row selected action
- (void)getPhotoRightStatus{
    PHAuthorizationStatus status = [_tool sf_askPhotoRightStatus];
    [self judgementStatus:status];
}

- (void)askPhotoRight{
    [_tool sf_askPhotoRight:^(PHAuthorizationStatus stat) {
         dispatch_async(dispatch_get_main_queue(), ^{
             [self judgementStatus:stat];
         });
    }];
}

- (void)showUserAlbum{
    SFPhotoAlbumListViewController *vc = [[SFPhotoAlbumListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getCamreaRightStatus{
    AVAuthorizationStatus status = [_cameraTool sf_askCameraRightStuts];
    [self judgementCameraRightStatus:status];
}

- (void)askCameraRight{
    [_cameraTool sf_askCameraRight:^(AVAuthorizationStatus status) {
       dispatch_async(dispatch_get_main_queue(), ^{
           [self judgementCameraRightStatus:status];
       });
    }];
}

- (void)showCameraPhoto{
    SFCameraPhotoViewController *vc = [[SFCameraPhotoViewController alloc] init];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

- (void)showCameraMovie{
    SFCameraMovieViewController *vc = [[SFCameraMovieViewController alloc] init];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

- (void)showCameraLiving{
    SFCameraLivingViewController *vc = [[SFCameraLivingViewController alloc] init];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

- (void)judgementDeviceHasFlas{
    NSString *message = [_cameraTool sf_deviceHasFlash] ? @"设备支持闪光灯" : @"设备不支持摄像头";
    [[SFThridMethod sharedInstance] showHUDWithText:message showTime:1.5 toview:self.view];
}
#pragma mark - public method
- (void)judgementStatus:(PHAuthorizationStatus)status{
    NSString *message = @"未知错误";
    switch (status) {
        case PHAuthorizationStatusAuthorized:{
            message = @"用户已授权同意~";
        }
            break;
            
        case PHAuthorizationStatusRestricted:{
            message = @"当前用户无权授权，请联系家长~";
        }
            break;
            
        case PHAuthorizationStatusDenied:{
            message = @"用户拒绝授权";
        }
            break;
            
        case PHAuthorizationStatusNotDetermined:{
            message = @"未取询问用户";
        }
            break;
        default:
            break;
    }
    [[SFThridMethod sharedInstance] showHUDWithText:message showTime:1.5 toview:self.view];
}

- (void)judgementCameraRightStatus:(AVAuthorizationStatus)status{
    NSString *message = @"未知错误";
    switch (status) {
        case AVAuthorizationStatusAuthorized:{
            message = @"用户已授权同意~";
        }
            break;
            
        case AVAuthorizationStatusDenied:{
            message = @"用户拒绝授权";
        }
            break;
            
        case AVAuthorizationStatusRestricted:{
            message = @"当前用户无权授权，请联系家长~";
        }
            break;
            
        case AVAuthorizationStatusNotDetermined:{
            message = @"未取询问用户";
        }
            break;
            
        default:
            break;
    }
    [[SFThridMethod sharedInstance] showHUDWithText:message showTime:1.5 toview:self.view];
}

- (BOOL)canGoNextStep{
    if ([_tool sf_askPhotoRightStatus] != PHAuthorizationStatusAuthorized) {
        [[SFThridMethod sharedInstance] showHUDWithText:@"请先获取相册使用权限，然后再试~" showTime:1.5 toview:self.view];
        return NO;
    }
    return YES;
}

- (BOOL)canGoCameraStep{
    if ([_cameraTool sf_askCameraRightStuts] != AVAuthorizationStatusAuthorized) {
        [[SFThridMethod sharedInstance] showHUDWithText:@"请先获取相机使用权限，然后再试~" showTime:1.5 toview:self.view];
        return NO;
    }
    return YES;
}
@end

