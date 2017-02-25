//
//  SFThridMethod.h
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/2/25.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@interface SFThridMethod : NSObject
+(SFThridMethod *)sharedInstance;
- (void)showHUDWithText:(NSString *)message showTime:(CGFloat)showTime toview:(UIView *)view;
@end
