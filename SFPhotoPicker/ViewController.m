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
    dispatch_async(dispatch_queue_create("img_download_queeu", DISPATCH_QUEUE_CONCURRENT), ^{
        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487921444131&di=24f2719e867b62f4eae8c716f664c7ee&imgtype=0&src=http%3A%2F%2Fbbs.zhezhe168.com%2Fdata%2Fattachment%2Fforum%2F201601%2F01%2F000742hy6jtf7vffjtzc2o.jpg"]]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if(img){
                [tool sf_saveImageSynchronizationInCamareAlbum:img complete:^(BOOL isSuccess, NSError *__autoreleasing *err) {
                    NSLog(@"");
                }];
                self.img.image = img;
            }
        });
    });
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
