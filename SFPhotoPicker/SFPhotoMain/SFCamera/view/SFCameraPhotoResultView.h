//
//  SFCameraPhotoResultView.h
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/3/10.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFCameraPhotoResultView : UIView
@property (nonatomic, strong) UIImageView *resultImageView;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UIButton *cancelBtn;

- (void)configureImg:(UIImage *)img;
@end
