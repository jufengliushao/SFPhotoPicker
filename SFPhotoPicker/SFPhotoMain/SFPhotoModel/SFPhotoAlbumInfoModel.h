//
//  SFPhotoAlbumInfoModel.h
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/2/23.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFPhotoAlbumInfoModel : NSObject

@property (nonatomic, strong) NSString *albumTitle; /* 相册名称 */
@property (nonatomic, assign) NSInteger photosSum; /* 照片总数 */
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSArray *thumbArr; /* 缩略图数组 */
@property (nonatomic, strong) NSArray *originalArr; /* 原图数组 */

@end
