//
//  SFIndexCalculateTool.h
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/3/2.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFPhotoAssetInfoModel.h"
typedef void(^ChangeSelectedComplete)(NSArray <NSIndexPath *>*indexPaths, BOOL isSuccess);

@interface SFIndexCalculateTool : NSObject
+(SFIndexCalculateTool *)shareInstance;

/**
 选中image的数组
 */
@property (nonatomic, strong, readonly) __kindof NSArray <SFPhotoAssetInfoModel *>*selectedIndexImgArr;

/**
 当前已经几张照片了 从1开始计数
 */
@property (nonatomic, assign, readonly) NSInteger currentIndex;

/**
 添加图片

 @param model SFPhotoAssetInfoModel
 @param indexPath <#indexPath description#>
 @param complete <#complete description#>
 */
- (void)sf_addImageModel:(SFPhotoAssetInfoModel *)model index:(NSIndexPath *)indexPath complete:(ChangeSelectedComplete)complete;

/**
 删除图片

 @param model SFPhotoAssetInfoModel
 @param indexPath <#indexPath description#>
 @param complete <#complete description#>
 */
- (void)sf_removeModel:(SFPhotoAssetInfoModel *)model index:(NSIndexPath *)indexPath complete:(ChangeSelectedComplete)complete;

/**
 清除所有选中的数据
 * warning 在不选择数据的时候记得清空，否则数据会一直显示
 */
- (void)sf_clearAllCalculateCache;
@end
