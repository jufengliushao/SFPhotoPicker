//
//  SFPhotoDetailShowViewController.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/3/1.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFPhotoDetailShowViewController.h"
#import "SFPhotoDetailCollectionViewCell.h"

NSString *const photoDeatilCellID = @"photoDeatilCellID";

@interface SFPhotoDetailShowViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching>{
    SFPhotoAlbumInfoModel *_dataModel;
    NSInteger _index;
}
@property (nonatomic, strong) UICollectionView *photoCollectionView;
@end

@implementation SFPhotoDetailShowViewController
#pragma mark - system method
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.photoCollectionView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.photoCollectionView.contentOffset = CGPointMake(kSCREEN_WIDTH * _index, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithModel:(SFPhotoAlbumInfoModel *)model showIndex:(NSInteger)index{
    if (self = [super init]) {
        _dataModel = model;
        _index = index;
        SFPhotoAssetInfoModel *model1 = model.imgModelArr[index];
        [[SFPhotoPickerTool sharedInstance] sf_cachingImageWitlLocalIndentifier:model1.localeIndefiner targetSize:CGSizeMake(model1.pixWith, model1.pixHeight)];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataModel.imgModelArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SFPhotoDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoDeatilCellID forIndexPath:indexPath];
    [cell configureModel:_dataModel.imgModelArr[indexPath.row]];
    return cell;
}
#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDataSourcePrefetching
- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths NS_AVAILABLE_IOS(10_0){
    for(NSIndexPath *idnex in indexPaths){
        SFPhotoAssetInfoModel *model = _dataModel.imgModelArr[idnex.row];
        dispatch_async(dispatch_queue_create("queue_origial_img_queue", DISPATCH_QUEUE_CONCURRENT), ^{
            [[SFPhotoPickerTool sharedInstance] sf_cachingImageWitlLocalIndentifier:model.localeIndefiner targetSize:CGSizeMake(model.pixWith, model.pixHeight)];
        });
    }
}

#pragma mark - init
- (UICollectionView *)photoCollectionView{
    if (!_photoCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 49, kSCREEN_WIDTH, kSCREEN_HEIGHT - 49) collectionViewLayout:flowLayout];
        flowLayout.itemSize = CGSizeMake(_photoCollectionView.bounds.size.width, _photoCollectionView.bounds.size.height);
        _photoCollectionView.delegate = self;
        _photoCollectionView.dataSource = self;
        _photoCollectionView.pagingEnabled = YES;
        if (IS_IOS_10) {
            _photoCollectionView.prefetchDataSource = self;
            _photoCollectionView.prefetchingEnabled = YES;
        }else{
            _photoCollectionView.prefetchingEnabled = NO;
        }
        [_photoCollectionView registerClass:[SFPhotoDetailCollectionViewCell class] forCellWithReuseIdentifier:photoDeatilCellID];
    }
    return _photoCollectionView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
