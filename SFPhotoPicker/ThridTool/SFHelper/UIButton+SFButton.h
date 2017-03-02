//
//  UIButton+SFButton.h
//  BaseFunction
//
//  Created by cnlive-lsf on 2016/12/26.
//  Copyright © 2016年 cnlive-lsf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActionBlock)(UIButton *sender);

@interface UIButton (SFButton)
- (void)addTargetAction:(ActionBlock)action;
@end
