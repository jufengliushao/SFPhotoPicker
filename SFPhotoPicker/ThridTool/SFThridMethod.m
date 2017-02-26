//
//  SFThridMethod.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/2/25.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFThridMethod.h"

static SFThridMethod *method = nil;

@implementation SFThridMethod
#pragma mark - system method
+(SFThridMethod *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (method == nil) {
            method = [[SFThridMethod alloc] init];
        }
    });
    return method;
}

#pragma mark - user method
- (void)showHUDWithText:(NSString *)message showTime:(CGFloat)showTime toview:(UIView *)view{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 再设置模式
    hud.mode = MBProgressHUDModeText;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:showTime];
}
@end
