//
//  SFPhotoAlbumnListViewController.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/2/25.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFPhotoAlbumListViewController.h"

@interface SFPhotoAlbumListViewController ()

@end

@implementation SFPhotoAlbumListViewController
#pragma mark - system method
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"Album List";
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
