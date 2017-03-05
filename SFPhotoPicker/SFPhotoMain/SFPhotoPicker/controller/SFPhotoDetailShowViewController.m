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

@interface SFPhotoDetailShowViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>{
    SFPhotoAlbumInfoModel *_dataModel;
}
@property (nonatomic, strong) UICollectionView *photoCollectionView;
@end

@implementation SFPhotoDetailShowViewController
#pragma mark - system method
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.photoCollectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithModel:(SFPhotoAlbumInfoModel *)model showIndex:(NSInteger)index{
    if (self = [super init]) {
        _dataModel = model;
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SFPhotoDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoDeatilCellID forIndexPath:indexPath];
    return cell;
}
#pragma mark - UICollectionViewDelegate

#pragma mark - init
- (UICollectionView *)photoCollectionView{
    if (!_photoCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _photoCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _photoCollectionView.delegate = self;
        _photoCollectionView.dataSource = self;
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
