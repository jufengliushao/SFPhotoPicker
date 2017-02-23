//
//  SFPhotoPickerTool.h
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/2/23.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "SFPhotoAlbumInfoModel.h"
@interface SFPhotoPickerTool : NSObject
/**
 init-method

 @return <#return value description#>
 */
+ (SFPhotoPickerTool *)sharedInstance;

@property (nonatomic, strong, readonly) NSArray *allAlbumInfoArr;


/**
 返回用户自定义的相册

 @return <#return value description#>
 */
- (PHFetchResult<PHAssetCollection *> *)sf_getAllUserAlbum;

/**
 返回用户相机胶卷相册

 @return <#return value description#>
 */
- (PHAssetCollection *)sf_getCarmerPhotoAlbum;
@end
