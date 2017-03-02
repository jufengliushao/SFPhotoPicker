//
//  UIButton+SFButton.m
//  BaseFunction
//
//  Created by cnlive-lsf on 2016/12/26.
//  Copyright © 2016年 cnlive-lsf. All rights reserved.
//

#import "UIButton+SFButton.h"
#import <objc/runtime.h>
@interface UIButton()
@property (nonatomic, copy) ActionBlock action;
@end

@implementation UIButton (SFButton)
- (void)addTargetAction:(ActionBlock)action{
    self.action = action;
    if(self.action){
        [self addTarget:self action:@selector(clickButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }else{
        [self removeTarget:self action:@selector(clickButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
}

- (void)clickButtonAction:(UIButton *)sender{
    if (self.action) {
        self.action(sender);
    }
}

- (void)setAction:(ActionBlock)action{
    objc_setAssociatedObject(self, @selector(action), action, OBJC_ASSOCIATION_COPY);
}

- (ActionBlock)action{
    return objc_getAssociatedObject(self, _cmd);
}
@end
