//
//  DoraemonHomeViewController.m
//  DoraemonKit
//
//  Created by dengyouhua on 2019/9/4.
//

#import "DoraemonHomeViewController.h"
#import "DoraemonCacheManager.h"
#import "DoraemonDefine.h"
#import "DoraemonHomeCell.h"
#import "DoraemonHomeCloseCell.h"
#import "DoraemonHomeFootCell.h"
#import "DoraemonHomeHeadCell.h"
#import "DoraemonHomeWindow.h"
#import "DoraemonManager.h"
#import "DoraemonPluginProtocol.h"
#import "UIColor+Doraemon.h"
#import "UIView+Doraemon.h"
#import "UIViewController+Doraemon.h"

static NSString *DoraemonHomeCellID = @"DoraemonHomeCellID";
static NSString *DoraemonHomeHeadCellID = @"DoraemonHomeHeadCellID";
static NSString *DoraemonHomeFootCellID = @"DoraemonHomeFootCellID";
static NSString *DoraemonHomeCloseCellID = @"DoraemonHomeCloseCellID";

@interface DoraemonHomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation DoraemonHomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Home";
    _dataArray = [DoraemonManager shareInstance].dataArray;
    [self.view addSubview:self.collectionView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.collectionView.frame = [self fullscreen];
}

#pragma mark-- UICollectionView
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:fl];
        _collectionView.backgroundColor = [UIColor systemBackgroundColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[DoraemonHomeCell class] forCellWithReuseIdentifier:DoraemonHomeCellID];
        [_collectionView registerClass:[DoraemonHomeCloseCell class] forCellWithReuseIdentifier:DoraemonHomeCloseCellID];
        [_collectionView registerClass:[DoraemonHomeHeadCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DoraemonHomeHeadCellID];
        [_collectionView registerClass:[DoraemonHomeFootCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DoraemonHomeFootCellID];
    }

    return _collectionView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < _dataArray.count) {
        return CGSizeMake(kDoraemonSizeFromLandscape(160), kDoraemonSizeFromLandscape(128));
    } else {
        return CGSizeMake(DoraemonWindowWidth, kDoraemonSizeFromLandscape(100));
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section < _dataArray.count) {
        return CGSizeMake(DoraemonWindowWidth, kDoraemonSizeFromLandscape(88));
    } else {
        return CGSizeMake(DoraemonWindowWidth, 0);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(DoraemonWindowWidth, kDoraemonSizeFromLandscape(24));
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    view.layer.zPosition = 0.0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _dataArray.count + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section < self.dataArray.count) {
        NSDictionary *dict = _dataArray[section];
        NSArray *pluginArray = dict[@"pluginArray"];
        return pluginArray.count;
    } else {
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;

    if (section < _dataArray.count) {
        DoraemonHomeCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:DoraemonHomeCellID forIndexPath:indexPath];
        NSDictionary *dict = _dataArray[section];
        NSArray *pluginArray = dict[@"pluginArray"];
        NSDictionary *item = pluginArray[row];
        [cell update:item[@"icon"] name:item[@"name"]];
        [cell updateImage:item[@"image"]];
        return cell;
    } else {
        DoraemonHomeCloseCell *closeCell = [collectionView dequeueReusableCellWithReuseIdentifier:DoraemonHomeCloseCellID forIndexPath:indexPath];
        return closeCell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        DoraemonHomeHeadCell *head = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DoraemonHomeHeadCellID forIndexPath:indexPath];
        [head renderUIWithTitle:nil];
        NSInteger section = indexPath.section;
        if (section < _dataArray.count) {
            NSDictionary *dict = _dataArray[section];
            [head renderUIWithTitle:dict[@"moduleName"]];
        }

        view = head;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        DoraemonHomeFootCell *foot = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:DoraemonHomeFootCellID forIndexPath:indexPath];
        foot.backgroundColor = [UIColor secondarySystemBackgroundColor];
        view = foot;
    } else {
        view = [[UICollectionReusableView alloc] init];
    }

    return view;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section < _dataArray.count)
        return UIEdgeInsetsMake(0, kDoraemonSizeFromLandscape(24), kDoraemonSizeFromLandscape(24), kDoraemonSizeFromLandscape(24));
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section < self.dataArray.count) {
        NSDictionary *dict = _dataArray[section];
        NSArray *pluginArray = dict[@"pluginArray"];
        NSDictionary *itemData = pluginArray[indexPath.row];
        NSString *pluginName = itemData[@"pluginName"];
        if (pluginName) {
            Class pluginClass = NSClassFromString(pluginName);
            id<DoraemonPluginProtocol> plugin = [[pluginClass alloc] init];
            if ([plugin respondsToSelector:@selector(pluginDidLoad)]) {
                [plugin pluginDidLoad];
            }
            if ([plugin respondsToSelector:@selector(pluginDidLoad:)]) {
                [plugin pluginDidLoad:(NSDictionary *)itemData];
            }

            void (^handleBlock)(NSDictionary *itemData) = [DoraemonManager shareInstance].keyBlockDic[itemData[@"key"]];
            if (handleBlock) {
                handleBlock(itemData);
            }
        }
    }
}
@end
