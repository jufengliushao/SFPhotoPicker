//
//  SFPhotoAlbumnListViewController.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/2/25.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFPhotoAlbumListViewController.h"
// cell
#import "SFPhotoPickerAlbumListTableViewCell.h"
#import "SFPhotoAlbumThumbListViewController.h"
#import "SFPhotoThumbHeaderView.h"

NSString * const kAlbumListCellID =@"kAlbumListCellID";
@interface SFPhotoAlbumListViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *_albumInfoArr;
}
@property (nonatomic, strong) UITableView *albumListTableView;
@property (nonatomic, strong) SFPhotoThumbHeaderView *headerView;
@end

@implementation SFPhotoAlbumListViewController
#pragma mark - system method
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getAlbumData];
    [self.view addSubview:self.albumListTableView];
     [[SFPhotoPickerTool sharedInstance] sf_cachingImageWithAssets:[_albumInfoArr[0] assetArr] targetSize:CGSizeMake(300, 300)];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"Album List";
    self.navigationController.navigationBarHidden = true;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = false;
}

#pragma mark - method
- (void)getAlbumData{
    dispatch_async(dispatch_queue_create("get_album_info", DISPATCH_QUEUE_CONCURRENT), ^{
        _albumInfoArr = [SFPhotoPickerTool sharedInstance].allAlbumInfoArr;
        if (_albumListTableView) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.albumListTableView reloadData];
            });
        }
    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _albumInfoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SFPhotoPickerAlbumListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAlbumListCellID forIndexPath:indexPath];
    [cell configureModel:_albumInfoArr[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFPhotoAlbumInfoModel *model = _albumInfoArr[indexPath.row];
    SFPhotoAlbumThumbListViewController *vc = [[SFPhotoAlbumThumbListViewController alloc] initWithAlbumModel:model];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - init
- (UITableView *)albumListTableView{
    if (!_albumListTableView) {
        _albumListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.bounds.size.height, kSCREEN_HEIGHT, kSCREEN_HEIGHT - self.headerView.bounds.size.height) style:(UITableViewStylePlain)];
        _albumListTableView.tableFooterView = [[UIView alloc] init];
        _albumListTableView.delegate = self;
        _albumListTableView.dataSource = self;
        [_albumListTableView registerClass:[SFPhotoPickerAlbumListTableViewCell class] forCellReuseIdentifier:kAlbumListCellID];
    }
    return _albumListTableView;
}

- (SFPhotoThumbHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[SFPhotoThumbHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 70);
        WS(ws);
        [_headerView.cancelBtn addTargetAction:^(UIButton *sender) {
            [ws.navigationController popViewControllerAnimated:YES];
            [[SFIndexCalculateTool shareInstance] sf_clearAllCalculateCache];
        }];
        [self.view addSubview:_headerView];
    }
    return _headerView;
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
