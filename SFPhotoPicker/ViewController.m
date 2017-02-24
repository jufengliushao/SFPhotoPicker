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
        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487925259679&di=667e004a38b3422b9f9346f93bbcaa4b&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fforum%2Fw%253D580%2Fsign%3D631f05f0013b5bb5bed720f606d2d523%2Fffc28e381f30e924f3b2986a4e086e061c95f7a6.jpg"]]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if(img){
                [tool sf_saveImageSynchronizationInAlbumWithImage:img albumTitle:@"SFImage" complete:^(BOOL isSuccess, NSError *__autoreleasing *err, NSString *imgID) {
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
