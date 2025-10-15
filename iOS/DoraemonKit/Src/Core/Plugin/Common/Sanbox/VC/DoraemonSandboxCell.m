//
//  DoraemonSandboxCell.m
//  DoraemonKit
//
//  Created by yixiang on 2017/12/11.
//

#import "DoraemonSandboxCell.h"
#import "DoraemonDefine.h"
#import "DoraemonSandboxModel.h"
#import "UIColor+Doraemon.h"
#import "UIImage+Doraemon.h"
#import "UIView+Doraemon.h"

@interface DoraemonSandBoxCell ()
@property (nonatomic, strong) UIImageView *fileTypeIcon;
@property (nonatomic, strong) UILabel *fileTitleLabel;
@property (nonatomic, strong) UILabel *fileSizeLabel;
@end

@implementation DoraemonSandBoxCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.multipleSelectionBackgroundView = [UIView new];

        self.fileTypeIcon = [[UIImageView alloc] init];
        [self.contentView addSubview:self.fileTypeIcon];

        self.fileTitleLabel = [[UILabel alloc] init];
        self.fileTitleLabel.font = [UIFont systemFontOfSize:kDoraemonSizeFromLandscape(32)];
        self.fileSizeLabel.textColor = [UIColor doraemon_black_1];
        [self.contentView addSubview:self.fileTitleLabel];

        self.fileSizeLabel = [[UILabel alloc] init];
        self.fileSizeLabel.font = [UIFont systemFontOfSize:kDoraemonSizeFromLandscape(32)];
        self.fileSizeLabel.textColor = [UIColor doraemon_black_2];
        [self.contentView addSubview:self.fileSizeLabel];
    }
    return self;
}

- (void)renderUIWithData:(DoraemonSandboxModel *)model {
    NSString *iconName = nil;
    if (model.type == DoraemonSandboxFileTypeDirectory) {
        iconName = @"doraemon_dir";
    } else {
        iconName = @"doraemon_file_2";
    }
    self.fileTypeIcon.image = [UIImage doraemon_xcassetImageNamed:iconName];
    [self.fileTypeIcon sizeToFit];
    self.fileTypeIcon.frame = CGRectMake(kDoraemonSizeFromLandscape(32), [[self class] cellHeight] / 2 - self.fileTypeIcon.doraemon_height / 2, self.fileTypeIcon.doraemon_width, self.fileTypeIcon.doraemon_height);

    self.fileTitleLabel.text = model.name;
    self.fileTitleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self.fileTitleLabel sizeToFit];
    self.fileTitleLabel.frame = CGRectMake(self.fileTypeIcon.doraemon_right + kDoraemonSizeFromLandscape(32), [[self class] cellHeight] / 2 - self.fileTitleLabel.doraemon_height / 2, DoraemonWindowWidth - 150, self.fileTitleLabel.doraemon_height);

    NSInteger fileSize = model.fileSize;
    NSString *fileSizeStr = nil;
    if (fileSize > 1024 * 1024) {
        fileSizeStr = [NSString stringWithFormat:@"%.2fM", fileSize / 1024.00f / 1024.00f];

    } else if (fileSize > 1024) {
        fileSizeStr = [NSString stringWithFormat:@"%.2fKB", fileSize / 1024.00f];

    } else {
        fileSizeStr = [NSString stringWithFormat:@"%.2fB", fileSize / 1.00f];
    }

    self.fileSizeLabel.text = fileSizeStr;
    [self.fileSizeLabel sizeToFit];
    self.fileSizeLabel.frame = CGRectMake(DoraemonWindowWidth - 15 - self.fileSizeLabel.doraemon_width, [[self class] cellHeight] / 2 - self.fileSizeLabel.doraemon_height / 2, self.fileSizeLabel.doraemon_width, self.fileSizeLabel.doraemon_height);
}

+ (CGFloat)cellHeight {
    return kDoraemonSizeFromLandscape(104);
}
@end
