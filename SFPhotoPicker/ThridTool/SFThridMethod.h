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

/**
 显示等待文字

 @param message <#message description#>
 @param showTime <#showTime description#>
 @param view <#view description#>
 */
- (void)showHUDWithText:(NSString *)message showTime:(CGFloat)showTime toview:(UIView *)view;

/**
 显示等待菊花

 @param message <#message description#>
 @param view <#view description#>
 */
- (void)showWaitHUDWithMessage:(NSString *)message toView:(UIView *)view;

/**
 隐藏
 */
- (void)hiddenHUD;
@end
