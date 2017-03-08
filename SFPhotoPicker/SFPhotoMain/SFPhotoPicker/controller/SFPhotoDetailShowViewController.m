//
//  SFPhotoDetailShowViewController.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/3/1.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFPhotoDetailShowViewController.h"
#import "SFPhotoDetailCollectionViewCell.h"
#import "SFPhotoDetailHeaderView.h"
#import "SFPhotoBottomView.h"

NSString *const photoDeatilCellID = @"photoDeatilCellID";

@interface SFPhotoDetailShowViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching, UIScrollViewDelegate>{
    SFPhotoAlbumInfoModel *_dataModel;
    NSInteger _index;
    NSInteger _currIndex;
}
@property (nonatomic, strong) UICollectionView *photoCollectionView;
@property (nonatomic, strong) SFPhotoDetailHeaderView *headerView;
@property (nonatomic, strong) SFPhotoBottomView *bottomView;
@end

@implementation SFPhotoDetailShowViewController
#pragma mark - system method
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.photoCollectionView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.photoCollectionView.contentOffset = CGPointMake(kSCREEN_WIDTH * _index, 0);
    SFPhotoAssetInfoModel *model = _dataModel.imgModelArr[_index];
    [self.headerView configureInde:model.index totalIndex:_dataModel.imgModelArr.count currentIndex:_index + 1];
    _currIndex = _index;
    [self indexBtnAction];
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = true;
    [self setBottomData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = false;
}

#pragma mark - method
- (void)setBottomData{
    [self.bottomView configureData];
}

- (void)setAction{
    
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

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0){
    NSInteger index = targetContentOffset->x / kSCREEN_WIDTH;
    SFPhotoAssetInfoModel *model = _dataModel.imgModelArr[index];
    [self.headerView configureInde:model.index totalIndex:_dataModel.imgModelArr.count currentIndex:index + 1];
    _currIndex = index;
}

#pragma mark - UICollectionViewDataSourcePrefetching
- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths NS_AVAILABLE_IOS(10_0){
    for(NSIndexPath *idnex in indexPaths){
        SFPhotoAssetInfoModel *model = _dataModel.imgModelArr[idnex.row];
        dispatch_async(dispatch_queue_create("queue_origial_img_queue", DISPATCH_QUEUE_CONCURRENT), ^{
            [[SFPhotoPickerTool sharedInstance] sf_cachingImageWitlLocalIndentifier:model.localeIndefiner targetSize:CGSizeMake(model.pixWith, model.pixHeight)];
        });
    }
}

#pragma mark - action method 
- (void)indexBtnAction{
    WS(ws);
    BS(bs);
    [self.headerView.indexBtn addTargetAction:^(UIButton *sender) {
        NSInteger index = bs->_currIndex;
        __block SFPhotoAssetInfoModel *model = bs->_dataModel.imgModelArr[index];
        if (model.isSelected) {
            [[SFIndexCalculateTool shareInstance] sf_removeModel:model index:[NSIndexPath indexPathForRow:bs->_currIndex inSection:0] complete:^(NSArray<NSIndexPath *> *indexPaths, BOOL isSuccess) {
                [ws.headerView configureInde:model.index totalIndex:bs->_dataModel.imgModelArr.count currentIndex:index + 1];
                [ws setBottomData];
            }];
        }else{
            [[SFIndexCalculateTool shareInstance] sf_addImageModel:model index:[NSIndexPath indexPathForRow:bs->_currIndex inSection:0] complete:^(NSArray<NSIndexPath *> *indexPaths, BOOL isSuccess) {
                [ws.headerView configureInde:model.index totalIndex:bs->_dataModel.imgModelArr.count currentIndex:index + 1];
                [ws setBottomData];
            }];
        }
    }];
}

#pragma mark - init
- (UICollectionView *)photoCollectionView{
    if (!_photoCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.headerView.bounds.size.height, kSCREEN_WIDTH, kSCREEN_HEIGHT - self.headerView.bounds.size.height - self.bottomView.bounds.size.height) collectionViewLayout:flowLayout];
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

- (SFPhotoDetailHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[SFPhotoDetailHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 70);
        WS(ws);
        [_headerView.backButton addTargetAction:^(UIButton *sender) {
            [ws.navigationController popViewControllerAnimated:YES];
        }];
        [self.view addSubview:_headerView];
    }
    return _headerView;
}

- (SFPhotoBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[SFPhotoBottomView alloc] init];
        _bottomView.frame = CGRectMake(0, kSCREEN_HEIGHT - 50, kSCREEN_WIDTH, 50);
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
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
