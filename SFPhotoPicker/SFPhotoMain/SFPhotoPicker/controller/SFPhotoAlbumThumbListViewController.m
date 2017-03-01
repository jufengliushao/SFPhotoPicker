//
//  SFPhotoAlbumThumbListViewController.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/2/27.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFPhotoAlbumThumbListViewController.h"
#import "SFPhotoPickerImageSmallCollectionViewCell.h"

NSString *const kThumbSmallItemID = @"kThumbSmallItemID";
@interface SFPhotoAlbumThumbListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDataSourcePrefetching>{
    SFPhotoAlbumInfoModel *_dataModel;
}

@property (nonatomic, strong) UICollectionView *thumbCollectionView;

@end

@implementation SFPhotoAlbumThumbListViewController
#pragma mark system method
- (instancetype)initWithAlbumModel:(SFPhotoAlbumInfoModel *)model{
    if (self = [super init]) {
        _dataModel = model;
        self.view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.thumbCollectionView];
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
    return item;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - UICollectionViewDataSourcePrefetching
- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths NS_AVAILABLE_IOS(10_0){
    dispatch_async(dispatch_queue_create("prefeth_cell_queue", DISPATCH_QUEUE_CONCURRENT), ^{
        for(NSIndexPath *index in indexPaths){
            SFPhotoPickerImageSmallCollectionViewCell *item = (SFPhotoPickerImageSmallCollectionViewCell *)[collectionView cellForItemAtIndexPath:index];
            [item configureModel:_dataModel.imgModelArr[index.row]];
        }
        NSLog(@"---------------");
    });
}

#pragma mark - 
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
}

#pragma mark - init
- (UICollectionView *)thumbCollectionView{
    if (!_thumbCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 3;
        layout.minimumInteritemSpacing = 3;
        CGFloat width = (self.view.bounds.size.width - 3 * 5) / 4.0;
        layout.itemSize = CGSizeMake(width, width);
        _thumbCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _thumbCollectionView.delegate = self;
        _thumbCollectionView.dataSource = self;
        _thumbCollectionView.prefetchDataSource = self;
        _thumbCollectionView.backgroundColor = [UIColor whiteColor];
        [_thumbCollectionView registerClass:[SFPhotoPickerImageSmallCollectionViewCell class] forCellWithReuseIdentifier:kThumbSmallItemID];
    }
    return _thumbCollectionView;
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
