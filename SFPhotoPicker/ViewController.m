//
//  ViewController.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/2/23.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "ViewController.h"
#import "SFPhotoPickerTool.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *img;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SFPhotoPickerTool *tool = [SFPhotoPickerTool sharedInstance];
    [[SFPhotoPickerTool sharedInstance] sf_askPhotoRight:^(PHAuthorizationStatus stat) {
//        NSLog(@"%@",[tool sf_getAllThumbOfAlbum:[tool sf_getAllUserAlbum][0]][5]);
    }];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
