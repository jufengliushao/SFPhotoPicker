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

@property (nonatomic, strong, readonly) NSArray *selectedIndexImgArr;
@property (nonatomic, assign, readonly) NSInteger currentIndex;

- (void)sf_addImageModel:(SFPhotoAssetInfoModel *)model index:(NSIndexPath *)indexPath complete:(ChangeSelectedComplete)complete;
- (void)sf_removeModel:(SFPhotoAssetInfoModel *)model index:(NSIndexPath *)indexPath complete:(ChangeSelectedComplete)complete;
@end
