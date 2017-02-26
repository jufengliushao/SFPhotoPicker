//
//  SFPhotoPickerAlbumListTableViewCell.m
//  SFPhotoPicker
//
//  Created by cnlive-lsf on 2017/2/26.
//  Copyright © 2017年 lsf. All rights reserved.
//

#import "SFPhotoPickerAlbumListTableViewCell.h"
#import "Masonry.h"

@implementation SFPhotoPickerAlbumListTableViewCell
#pragma mark - system method
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect{
    WS(ws);
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.width.mas_equalTo(ws.iconImageView.mas_height);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws.iconImageView);
        make.leading.mas_equalTo(ws.iconImageView.mas_trailing).mas_offset(8);
        make.trailing.mas_equalTo(-10);
    }];
    [super drawRect:rect];
}

#pragma mark - set data
- (void)configureModel:(SFPhotoAlbumInfoModel *)configure{
    NSString *imgID = configure.thumbArr.count > 0 ? configure.thumbArr[0] : nil;
    [[SFPhotoPickerTool sharedInstance] sf_getImageWithLocalIdentifier:imgID isSynchronous:YES isThumbImage:YES complete:^(UIImage *result, NSDictionary *info) {
        self.iconImageView.image = result;
    }];
    self.titleLabel.text = configure.albumTitle;
}

#pragma mark - init
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImageView];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}
@end
