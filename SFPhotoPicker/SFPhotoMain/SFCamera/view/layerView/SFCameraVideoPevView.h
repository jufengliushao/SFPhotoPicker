//
//  SFCameraVideoPevView.h
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/3/8.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SFCameraLayerType) {
    SFCameraLayerTypePhoto, /* 照片展示层 */
    SFCameraLayerTypeVideo /* 录制视频展示层 */
};

@interface SFCameraVideoPevView : UIView
- (instancetype)initWithType:(SFCameraLayerType)layerType;
@end
