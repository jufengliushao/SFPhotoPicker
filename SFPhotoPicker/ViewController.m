//
//  ViewController.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/2/23.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "ViewController.h"
#import "SFPhotoPickerTool.h"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSArray *_titleArr;
    SFPhotoPickerTool *_tool;
}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

static NSString *kHomeCellID = @"kHomeCellID";

@implementation ViewController
#pragma mark - system method
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    // setData
    _titleArr = @[@"当前手机相册权限状态", @"获取手机相册权限", @"", @""];
    _tool = [SFPhotoPickerTool sharedInstance];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"SFPhotoPicker";
}

#pragma mark - method
- (void)setTableView{
    self.mainTableView.tableFooterView = [[UIView alloc] init];
    [self.mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kHomeCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHomeCellID forIndexPath:indexPath];
    cell.textLabel.text = _titleArr[indexPath.row];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
            // 获取手机相册权限当前状态
            [self getPhotoRightStatus];
        }
            break;
            
        case 1:{
            // 获取手机相册权限
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - row selected action
- (void)getPhotoRightStatus{
    [_tool sf_askPhotoRightStatus];
}
@end
