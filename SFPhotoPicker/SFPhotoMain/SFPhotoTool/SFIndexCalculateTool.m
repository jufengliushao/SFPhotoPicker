//
//  SFIndexCalculateTool.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/3/2.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFIndexCalculateTool.h"

@interface SFIndexCalculateTool(){
    NSInteger _currIndex;
    NSMutableArray *_selectedImgArr;
    NSMutableArray *_selectedIndexArr;
}

@end

NSString *const imgKey = @"sf_indexCalculate_img_key";
NSString *const indexKey = @"sf_indenCalculate_index_key";

static SFIndexCalculateTool *sf_index = nil;

@implementation SFIndexCalculateTool
+(SFIndexCalculateTool *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sf_index) {
            sf_index = [[SFIndexCalculateTool alloc] init];
        }
    });
    return sf_index;
}

- (instancetype)init{
    if (self = [super init]) {
        _currIndex = 1;
        _selectedImgArr = [NSMutableArray arrayWithCapacity:0];
        _selectedIndexArr = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

#pragma mark - user method
- (void)sf_addImageModel:(SFPhotoAssetInfoModel *)model index:(NSIndexPath *)indexPath complete:(ChangeSelectedComplete)complete{
    if (model && indexPath && [self isIndexExtise:indexPath]) {
        [self addImgObjectIndex:model];
        [_selectedIndexArr addObject:indexPath];
        if(complete){
            complete(_selectedIndexArr, YES);
        }
    }else{
        if (complete) {
            complete(_selectedIndexArr, NO);
        }
    }
}

- (void)sf_removeModel:(SFPhotoAssetInfoModel *)model index:(NSIndexPath *)indexPath complete:(ChangeSelectedComplete)complete{
    if (model && indexPath && ![self isIndexExtise:indexPath]) {
        [self deleteObjectIndex:model];
        dispatch_queue_t concurrentQueue = dispatch_queue_create("barrier_concurrent_queue", DISPATCH_QUEUE_CONCURRENT);
        dispatch_sync(concurrentQueue, ^{
            if (complete) {
                complete(_selectedIndexArr, YES);
            }
        });
        dispatch_barrier_sync(concurrentQueue, ^{
            [_selectedIndexArr removeObject:indexPath];
        });
    }else{
        if (complete) {
            complete(_selectedIndexArr, NO);
        }
    }
}

- (void)sf_clearAllCalculateCache{
    [self setZeroIndexForModel];
    [_selectedImgArr removeAllObjects];
    [_selectedIndexArr removeAllObjects];
}
#pragma mark - method
- (BOOL)isIndexExtise:(NSIndexPath *)index{
    if ([_selectedIndexArr containsObject:index]) {
        return NO;
    }
    return YES;
}

- (void)addImgObjectIndex:(SFPhotoAssetInfoModel *)model{
    [_selectedImgArr addObject:model];
    model.index = _currIndex ++;
}

- (void)deleteObjectIndex:(SFPhotoAssetInfoModel *)model{
    NSInteger ind = model.index;
    for (NSInteger i = ind - 1; i < _selectedImgArr.count; i ++) {
        SFPhotoAssetInfoModel *model1 = _selectedImgArr[i];
        model1.index --;
    }
    model.index = 0;
    [_selectedImgArr removeObject:model];
    -- _currIndex;
}

- (void)setZeroIndexForModel{
    for (SFPhotoAssetInfoModel *model in _selectedImgArr) {
        model.index = 0;
    }
    _currIndex = 1;
}

#pragma mark - getter
- (NSInteger)currentIndex{
    return _currIndex;
}

- (NSArray<SFPhotoAssetInfoModel *> *)selectedIndexImgArr{
    return _selectedImgArr;
}
@end
