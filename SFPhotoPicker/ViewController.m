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
        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487927504029&di=2d39f7b09eb4949ae6b4de16c72d0319&imgtype=0&src=http%3A%2F%2Fimg0.pconline.com.cn%2Fpconline%2Fbizi%2Fdesktop%2F1412%2FAXI5_1.jpg"]]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if(img){
                [tool sf_saveImageSynchronousInAlbumWithImage:img albumTitle:@"SFImg" complete:^(BOOL isSuccess, NSError *__autoreleasing *err, NSString *imgID) {
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
