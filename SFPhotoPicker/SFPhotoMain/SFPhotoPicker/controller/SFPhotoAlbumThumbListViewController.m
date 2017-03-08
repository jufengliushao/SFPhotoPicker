//
//  SFPhotoAlbumThumbListViewController.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/2/27.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFPhotoAlbumThumbListViewController.h"
#import "SFPhotoPickerImageSmallCollectionViewCell.h"
#import "SFPhotoDetailShowViewController.h"
#import "SFPhotoThumbHeaderView.h"
#import "SFPhotoBottomView.h"

NSString *const kThumbSmallItemID = @"kThumbSmallItemID";
@interface SFPhotoAlbumThumbListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDataSourcePrefetching>{
    SFPhotoAlbumInfoModel *_dataModel;
    __block NSMutableArray *_arrayin;
}

@property (nonatomic, strong) UICollectionView *thumbCollectionView;
@property (nonatomic, strong) SFPhotoThumbHeaderView *headerView;
@property (nonatomic, strong) SFPhotoBottomView *bottomView;

@end

@implementation SFPhotoAlbumThumbListViewController
#pragma mark system method
- (instancetype)initWithAlbumModel:(SFPhotoAlbumInfoModel *)model{
    if (self = [super init]) {
        _dataModel = model;
        self.view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.thumbCollectionView];
        [self.thumbCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_dataModel.imgModelArr.count - 1 inSection:0] atScrollPosition:(UICollectionViewScrollPositionBottom) animated:NO];
        _arrayin = [NSMutableArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = _dataModel.albumTitle;
    if (self.thumbCollectionView) {
        [self.thumbCollectionView reloadData];
    }
    self.navigationController.navigationBarHidden = true;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = false;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataModel.imgModelArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SFPhotoPickerImageSmallCollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:kThumbSmallItemID forIndexPath:indexPath];
    [item configureModel:_dataModel.imgModelArr[indexPath.row]];
    __block SFPhotoAssetInfoModel *model = _dataModel.imgModelArr[indexPath.row];
    WS(ws);
    [item.indexBtn addTargetAction:^(UIButton *sender) {
        if (model.isSelected) {
            [[SFIndexCalculateTool shareInstance] sf_removeModel:model index:indexPath complete:^(NSArray<NSIndexPath *> *indexPaths, BOOL isSuccess) {
                [ws.thumbCollectionView reloadItemsAtIndexPaths:indexPaths];
                [ws setBottomData];
            }];
        }else{
            [[SFIndexCalculateTool shareInstance] sf_addImageModel:model index:indexPath complete:^(NSArray<NSIndexPath *> *indexPaths, BOOL isSuccess) {
                [ws.thumbCollectionView reloadItemsAtIndexPaths:indexPaths];
                [ws setBottomData];
            }];
        }
    }];
    return item;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SFPhotoDetailShowViewController *vc = [[SFPhotoDetailShowViewController alloc] initWithModel:_dataModel showIndex:indexPath.item];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDataSourcePrefetching
- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths NS_AVAILABLE_IOS(10_0){
    dispatch_async(dispatch_queue_create("prefeth_cell_queue", DISPATCH_QUEUE_CONCURRENT), ^{
        for(NSIndexPath *index in indexPaths){
            SFPhotoPickerImageSmallCollectionViewCell *item = (SFPhotoPickerImageSmallCollectionViewCell *)[collectionView cellForItemAtIndexPath:index];
            [item configureModel:_dataModel.imgModelArr[index.row]];
        }
    });
}

#pragma mark - method
- (void)setBottomData{
    [self.bottomView configureData];
}

- (void)setAction{
    
}

#pragma mark - init
- (UICollectionView *)thumbCollectionView{
    if (!_thumbCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 3;
        layout.minimumInteritemSpacing = 3;
        CGFloat width = (self.view.bounds.size.width - 3 * 5) / 4.0;
        layout.itemSize = CGSizeMake(width, width);
        _thumbCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.headerView.bounds.size.height, kSCREEN_WIDTH, kSCREEN_HEIGHT - self.headerView.bounds.size.height - self.bottomView.bounds.size.height) collectionViewLayout:layout];
        _thumbCollectionView.delegate = self;
        _thumbCollectionView.dataSource = self;
        _thumbCollectionView.prefetchDataSource = self;
        if (IS_IOS_10) {
            _thumbCollectionView.prefetchingEnabled = YES;
        }else{
            _thumbCollectionView.prefetchingEnabled = NO;
        }
        _thumbCollectionView.backgroundColor = [UIColor whiteColor];
        [_thumbCollectionView registerClass:[SFPhotoPickerImageSmallCollectionViewCell class] forCellWithReuseIdentifier:kThumbSmallItemID];
    }
    return _thumbCollectionView;
}

- (SFPhotoThumbHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[SFPhotoThumbHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 70);
        [_headerView.cancelBtn setTitle:@"返回" forState:(UIControlStateNormal)];
        WS(ws);
        [_headerView.cancelBtn addTargetAction:^(UIButton *sender) {
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
