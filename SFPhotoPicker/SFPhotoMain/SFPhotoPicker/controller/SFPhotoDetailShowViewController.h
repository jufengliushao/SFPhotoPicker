//
//  SFPhotoDetailShowViewController.h
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/3/1.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFPhotoAlbumInfoModel.h"
@interface SFPhotoDetailShowViewController : UIViewController
- (instancetype)initWithModel:(SFPhotoAlbumInfoModel *)model showIndex:(NSInteger)index;
@end
