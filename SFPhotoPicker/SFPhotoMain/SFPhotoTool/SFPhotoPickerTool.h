//
//  SFPhotoPickerTool.h
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/2/23.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@interface SFPhotoPickerTool : NSObject
/**
 init-method

 @return <#return value description#>
 */
+ (SFPhotoPickerTool *)sharedInstance;

@property (nonatomic, strong, readonly) NSArray *allAlbumTitleArr;
@end
