//
//  SFThridMethod.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/2/25.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFThridMethod.h"

static SFThridMethod *method = nil;

@interface SFThridMethod(){
    MBProgressHUD *_hud;
}

@end

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

- (instancetype)init{
    if (self = [super init]) {
        _hud = [[MBProgressHUD alloc] init];
    }
    return self;
}

#pragma mark - user method
- (void)showHUDWithText:(NSString *)message showTime:(CGFloat)showTime toview:(UIView *)view{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    _hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    _hud.label.text = message;
    // 再设置模式
    _hud.mode = MBProgressHUDModeText;
    // 隐藏时候从父控件中移除
    _hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [_hud hideAnimated:YES afterDelay:showTime];
}

- (void)showWaitHUDWithMessage:(NSString *)message toView:(UIView *)view{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    _hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.label.text = message;
}

- (void)hiddenHUD{
    [_hud hideAnimated:YES afterDelay:0];
}
@end
