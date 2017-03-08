//
//  SFCameraTool.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/3/8.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFCameraTool.h"

SFCameraTool *camera = nil;

@implementation SFCameraTool
+ (SFCameraTool *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!camera) {
            camera = [[SFCameraTool alloc] init];
        }
    });
    return camera;
}
@end
