//
//  DoraemonAppInfoViewController.m
//  DoraemonKit
//
//  Created by yixiang on 2018/4/13.
//

#import "DoraemonAppInfoViewController.h"
#import "DoraemonAppInfoCell.h"
#import "DoraemonDefine.h"
#import "DoraemonAppInfoUtil.h"
#import "UIView+Doraemon.h"
#import "UIColor+Doraemon.h"
#import <CoreTelephony/CTCellularData.h>
#import <objc/runtime.h>

@interface DoraemonAppInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) CTCellularData *cellularData API_AVAILABLE(ios(9.0));
@property (nonatomic, copy) NSString *authority;
@end

@implementation DoraemonAppInfoViewController{
    
}

+ (void)setCustomAppInfoBlock:(void (^)(NSMutableArray<NSDictionary *> *))customAppInfoBlock {
    objc_setAssociatedObject(self, @selector(customAppInfoBlock), customAppInfoBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (void (^)(NSMutableArray<NSDictionary *> *))customAppInfoBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self initData];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
        _cellularData.cellularDataRestrictionDidUpdateNotifier = nil;
        _cellularData = nil;
}

- (void)initUI
{
    self.title = @"App Info";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.doraemon_width, self.view.doraemon_height) style:UITableViewStyleGrouped];
        self.tableView.backgroundColor = [UIColor systemBackgroundColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0.;
    self.tableView.estimatedSectionFooterHeight = 0.;
    self.tableView.estimatedSectionHeaderHeight = 0.;
    [self.view addSubview:self.tableView];
}

#pragma mark - default data

- (void)initData
{
        
    NSString *iphoneName = [DoraemonAppInfoUtil iphoneName];

    NSString *iphoneSystemVersion = [DoraemonAppInfoUtil iphoneSystemVersion];

    NSString *iphoneType = [DoraemonAppInfoUtil iphoneType];

    NSString *iphoneSize = [NSString stringWithFormat:@"%.0f * %.0f",DoraemonScreenWidth,DoraemonScreenHeight];

    NSString *ipv4String = [DoraemonAppInfoUtil getIPAddress:YES];

    NSString *ipv6String = [DoraemonAppInfoUtil getIPAddress:NO];

    NSString *bundleIdentifier = [DoraemonAppInfoUtil bundleIdentifier];

    NSString *bundleVersion = [DoraemonAppInfoUtil bundleVersion];

    NSString *bundleShortVersionString = [DoraemonAppInfoUtil bundleShortVersionString];

    NSString *locationAuthority = [DoraemonAppInfoUtil locationAuthority];
    
    _cellularData = [[CTCellularData alloc]init];
    __weak typeof(self) weakSelf = self;
    _cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
        if (state == kCTCellularDataRestricted) {
            weakSelf.authority = @"Restricted";
        }else if(state == kCTCellularDataNotRestricted){
            weakSelf.authority = @"NotRestricted";
        }else{
            weakSelf.authority = @"Unknown";
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
        
    };

    NSString *pushAuthority = [DoraemonAppInfoUtil pushAuthority];

    NSString *cameraAuthority = [DoraemonAppInfoUtil cameraAuthority];

    NSString *audioAuthority = [DoraemonAppInfoUtil audioAuthority];

    NSString *photoAuthority = [DoraemonAppInfoUtil photoAuthority];

    NSString *addressAuthority = [DoraemonAppInfoUtil addressAuthority];

    NSString *calendarAuthority = [DoraemonAppInfoUtil calendarAuthority];

    NSString *remindAuthority = [DoraemonAppInfoUtil remindAuthority];

    NSMutableArray *appInfos = @[@{@"title":@"Bundle ID",
                                   @"value":bundleIdentifier},
                                 @{@"title":@"Version",
                                   @"value":bundleVersion},
                                 @{@"title":@"VersionCode",
                                   @"value":bundleShortVersionString}].mutableCopy;
    if (DoraemonAppInfoViewController.customAppInfoBlock) {
        DoraemonAppInfoViewController.customAppInfoBlock(appInfos);
    }
    
    NSArray *dataArray = @[
        @{
            @"title":@"Phone Info",
            @"array":@[
                @{
                    @"title":@"Device Name",
                    @"value":iphoneName
                },
                @{
                    @"title":@"Phone Model",
                    @"value":iphoneType
                },
                @{
                    @"title":@"System Version",
                    @"value":iphoneSystemVersion
                },
                @{
                    @"title":@"Phone Screen",
                    @"value":iphoneSize
                },
                @{
                    @"title":@"ipV4",
                    @"value":STRING_NOT_NULL(ipv4String)
                },
                @{
                    @"title":@"ipV6",
                    @"value":STRING_NOT_NULL(ipv6String)
                }
            ]
        },
        @{
            @"title":@"App Info",
            @"array":appInfos
        },
        @{
            @"title":@"Privacy Info",
            @"array":@[
                @{
                    @"title":@"Location",
                    @"value":locationAuthority
                },
                @{
                    @"title":@"Network",
                    @"value":@"Unknown"
                },
                @{
                    @"title":@"Push",
                    @"value":pushAuthority
                },
                @{
                    @"title":@"Camera",
                    @"value":cameraAuthority
                },
                @{
                    @"title":@"Microphone",
                    @"value":audioAuthority
                },
                @{
                    @"title":@"Photos",
                    @"value":photoAuthority
                },
                @{
                    @"title":@"Contacts",
                    @"value":addressAuthority
                },
                @{
                    @"title":@"Calendar",
                    @"value":calendarAuthority
                },
                @{
                    @"title":@"Notes",
                    @"value":remindAuthority
                }
            ]
        }
    ];
    _dataArray = dataArray;
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = _dataArray[section][@"array"];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [DoraemonAppInfoCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kDoraemonSizeFrom750_Landscape(120);
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.doraemon_width, kDoraemonSizeFrom750_Landscape(120))];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDoraemonSizeFrom750_Landscape(32), 0, DoraemonScreenWidth-kDoraemonSizeFrom750_Landscape(32), kDoraemonSizeFrom750_Landscape(120))];
    NSDictionary *dic = _dataArray[section];
    titleLabel.text = dic[@"title"];
    titleLabel.font = [UIFont systemFontOfSize:kDoraemonSizeFrom750_Landscape(28)];
    titleLabel.textColor = [UIColor doraemon_black_3];
    [sectionView addSubview:titleLabel];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"httpcell";
    DoraemonAppInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[DoraemonAppInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    NSArray *array = _dataArray[indexPath.section][@"array"];
    NSDictionary *item = array[indexPath.row];
    if (indexPath.section == 2 && indexPath.row == 1 && self.authority) {
        NSMutableDictionary *tempItem = [item mutableCopy];
        [tempItem setValue:self.authority forKey:@"value"];
        [cell renderUIWithData:tempItem];
    }else{
       [cell renderUIWithData:item];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 2){
        [DoraemonUtil openAppSetting];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    UIContextualAction *action = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Copy" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        NSString *value = weakSelf.dataArray[indexPath.section][@"array"][indexPath.row][@"value"];
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        pboard.string = value;
    }];

    return [UISwipeActionsConfiguration configurationWithActions:@[action]];
}
@end
