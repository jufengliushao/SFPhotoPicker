//
//  SFLivingOutputCode.h
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/3/22.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VideoToolbox/VideoToolbox.h>
@interface SFLivingOutputCode : NSObject
- (void)sf_videoOutputDataEncode:(CMSampleBufferRef)sampleBuffer;
@end
