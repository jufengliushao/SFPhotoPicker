//
//  SFPhotoDetailShowViewController.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/3/1.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFPhotoDetailShowViewController.h"

@interface SFPhotoDetailShowViewController (){
    SFPhotoAlbumInfoModel *_dataModel;
}

@end

@implementation SFPhotoDetailShowViewController
#pragma mark - system method
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithModel:(SFPhotoAlbumInfoModel *)model showIndex:(NSInteger)index{
    if (self = [super init]) {
        _dataModel = model;
    }
    return self;
}

#pragma mark - init
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
