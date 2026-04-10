//
//  DoraemonSandboxViewController.m
//  DoraemonKit
//
//  Created by yixiang on 2017/12/11.
//

#import "DoraemonSandboxViewController.h"
#import "DoraemonAppInfoUtil.h"
#import "DoraemonDefine.h"
#import "DoraemonNavBarItemModel.h"
#import "DoraemonSanboxDetailViewController.h"
#import "DoraemonSandboxCell.h"
#import "DoraemonSandboxModel.h"
#import "DoraemonUtil.h"

typedef NS_ENUM(NSUInteger, SortBy) {
    SortByName,
    SortBySizeAscending,
    SortBySizeDescending
};

@interface DoraemonSandboxViewController ()<UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DoraemonSandboxModel *currentDirModel;
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, copy) NSString *rootPath;
@property (nonatomic, assign) SortBy sortType;

@property (nonatomic, strong) DoraemonNavBarItemModel *leftModel;

@property (nonatomic, assign) BOOL isEditingMode;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *selectedIndexPaths;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIBarButtonItem *cancelEditButton;
@property (nonatomic, strong) UIBarButtonItem *sortButton;

@property (nonatomic, strong) UITableViewDiffableDataSource<NSNumber *, DoraemonSandboxModel *> *dataSource;
@end

@implementation DoraemonSandboxViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadPath:_currentDirModel.path];
}

- (void)initData {
    _sortType = SortByName;
    _dataArray = @[];
    _rootPath = NSHomeDirectory();
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
        _deleteButton.backgroundColor = [UIColor systemRedColor];
        [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _deleteButton.frame = CGRectMake(0, self.view.doraemon_height, self.view.doraemon_width, 60);
        [_deleteButton addTarget:self action:@selector(deleteSelectedItems) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.hidden = YES;
    }
    return _deleteButton;
}

- (UIBarButtonItem *)cancelEditButton {
    if (!_cancelEditButton) {
        _cancelEditButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(exitEditingMode)];
    }
    return _cancelEditButton;
}

- (UIBarButtonItem *)sortButton {
    if (!_sortButton) {
        NSString *title = [self sortMenuTitleForType:self.sortType];
        _sortButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(showSortMenu)];
    }
    return _sortButton;
}

- (void)initUI {
    self.title = @"Sandbox";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.doraemon_width, self.view.doraemon_height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    [self.tableView registerClass:DoraemonSandBoxCell.self forCellReuseIdentifier:DoraemonSandBoxCell.description];
    [self.view addSubview:self.tableView];

    self.dataSource = [[UITableViewDiffableDataSource<NSNumber *, DoraemonSandboxModel *> alloc] initWithTableView:self.tableView
                                                                                                      cellProvider:^UITableViewCell *_Nullable(UITableView *tableView, NSIndexPath *indexPath, DoraemonSandboxModel *item) {
        DoraemonSandBoxCell *cell = [tableView dequeueReusableCellWithIdentifier:DoraemonSandBoxCell.description forIndexPath:indexPath];
        [cell renderUIWithData:item];
        return cell;
    }];
    self.dataSource.defaultRowAnimation = UITableViewRowAnimationFade;

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self.tableView addGestureRecognizer:longPress];
    self.selectedIndexPaths = [NSMutableArray array];
    [self.view addSubview:self.deleteButton];

    self.navigationItem.rightBarButtonItem = self.sortButton;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gesture locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
        if (indexPath) {
            [self enterEditingMode];
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            if (![self.selectedIndexPaths containsObject:indexPath]) {
                [self.selectedIndexPaths addObject:indexPath];
            }
        }
    }
}

- (void)enterEditingMode {
    if (!self.isEditingMode) {
        self.isEditingMode = YES;
        [self.tableView setEditing:YES animated:YES];
        self.deleteButton.hidden = NO;
        UIEdgeInsets inset = self.view.safeAreaInsets;
        self.deleteButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, inset.bottom, 0);
        [UIView animateWithDuration:0.25
                         animations:^{
            self.deleteButton.frame = CGRectMake(0, self.view.doraemon_height - 60 - inset.bottom, self.view.doraemon_width, 60 + inset.bottom);
        }];
        self.navigationItem.rightBarButtonItem = self.cancelEditButton;
    }
}

- (void)exitEditingMode {
    if (self.isEditingMode) {
        self.isEditingMode = NO;
        [self.tableView setEditing:NO animated:YES];
        [self.selectedIndexPaths removeAllObjects];
        [UIView animateWithDuration:0.25
                         animations:^{
            self.deleteButton.frame = CGRectMake(0, self.view.doraemon_height, self.deleteButton.frame.size.width, self.deleteButton.frame.size.height);
        }
                         completion:^(BOOL finished) {
            self.deleteButton.hidden = YES;
        }];
        self.navigationItem.rightBarButtonItem = self.sortButton;
    }
}

- (void)deleteSelectedItems {
    NSMutableArray *modelsToDelete = [NSMutableArray array];
    for (NSIndexPath *indexPath in self.selectedIndexPaths) {
        DoraemonSandboxModel *model = self.dataArray[indexPath.row];
        [modelsToDelete addObject:model];
    }
    [self deleteFileWithPaths:[modelsToDelete valueForKeyPath:@"path"]];
    [self exitEditingMode];
    [self loadPath:self.currentDirModel.path];
}

- (void)loadPath:(NSString *)filePath {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *targetPath = filePath;

    DoraemonSandboxModel *model = [[DoraemonSandboxModel alloc] init];
    if (!targetPath || [targetPath isEqualToString:_rootPath]) {
        targetPath = _rootPath;
        model.name = @"Root Dir";
        model.type = DoraemonSandboxFileTypeRoot;
        self.tableView.frame = CGRectMake(0, 0, self.view.doraemon_width, self.view.doraemon_height);
        [self setLeftNavBarItems:nil];
    } else {
        model.name = @"Back";
        model.type = DoraemonSandboxFileTypeBack;
        self.tableView.frame = CGRectMake(0, IPHONE_NAVIGATIONBAR_HEIGHT, self.view.doraemon_width, self.view.doraemon_height - IPHONE_NAVIGATIONBAR_HEIGHT);
        NSString *dirTitle = [fm displayNameAtPath:targetPath];
        self.title = dirTitle;
        UIImage *image = [UIImage systemImageNamed:@"chevron.backward"];
        self.leftModel = [[DoraemonNavBarItemModel alloc] initWithImage:image selector:@selector(leftNavBackClick:)];
        [self setLeftNavBarItems:@[ self.leftModel ]];
    }
    model.path = filePath;
    _currentDirModel = model;

    NSMutableArray *files = @[].mutableCopy;
    NSError *error = nil;
    NSArray *paths = [fm contentsOfDirectoryAtPath:targetPath error:&error];
    for (NSString *path in paths) {
        BOOL isDir = false;
        NSString *fullPath = [targetPath stringByAppendingPathComponent:path];
        [fm fileExistsAtPath:fullPath isDirectory:&isDir];

        DoraemonSandboxModel *model = [[DoraemonSandboxModel alloc] init];
        model.path = fullPath;
        if (isDir) {
            model.type = DoraemonSandboxFileTypeDirectory;
        } else {
            model.type = DoraemonSandboxFileTypeFile;
        }
        model.name = path;

        [files addObject:model];
    }
    _dataArray = files;
    [self sortWithType:self.sortType];
}

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [DoraemonSandBoxCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isEditingMode) {
        if (![self.selectedIndexPaths containsObject:indexPath]) {
            [self.selectedIndexPaths addObject:indexPath];
        }
        return;
    }
    DoraemonSandboxModel *model = _dataArray[indexPath.row];
    if (model.type == DoraemonSandboxFileTypeFile) {
        [self handleFileWithPath:model.path];
    } else if (model.type == DoraemonSandboxFileTypeDirectory) {
        [self loadPath:model.path];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isEditingMode) {
        [self.selectedIndexPaths removeObject:indexPath];
    }
}

- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    DoraemonSandboxModel *model = self.dataArray[indexPath.row];

    UIContextualAction *shareAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Share" handler:^(UIContextualAction *_Nonnull action, UIView *_Nonnull sourceView, void (^_Nonnull completionHandler)(BOOL)) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf shareFileWithPath:model.path];
        completionHandler(YES);
    }];
    shareAction.backgroundColor = [UIColor systemPurpleColor];

    UIContextualAction *previewAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"Preview" handler:^(UIContextualAction *_Nonnull action, UIView *_Nonnull sourceView, void (^_Nonnull completionHandler)(BOOL)) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf previewFile:model.path];
        completionHandler(YES);
    }];
    previewAction.backgroundColor = [UIColor systemOrangeColor];

    return [UISwipeActionsConfiguration configurationWithActions:@[ shareAction, previewAction ]];
}

- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    DoraemonSandboxModel *model = self.dataArray[indexPath.row];
    return [UISwipeActionsConfiguration configurationWithActions:@[
        [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Delete" handler:^(UIContextualAction *_Nonnull action, UIView *_Nonnull sourceView, void (^_Nonnull completionHandler)(BOOL)) {
        __strong typeof(self) strongSelf = weakSelf;
        [tableView setEditing:NO animated:YES];
        [strongSelf deleteFileWithPath:model.path];
        completionHandler(YES);
    }]
    ]];
}

- (void)leftNavBackClick:(id)clickView {
    if (self.isEditingMode) {
        [self exitEditingMode];
    }
    if (_currentDirModel.type == DoraemonSandboxFileTypeRoot) {
        [super leftNavBackClick:clickView];
    } else {
        [self loadPath:[_currentDirModel.path stringByDeletingLastPathComponent]];
    }
}

- (void)handleFileWithPath:(NSString *)filePath {
    UIAlertControllerStyle style;
    if ([DoraemonAppInfoUtil isIpad]) {
        style = UIAlertControllerStyleAlert;
    } else {
        style = UIAlertControllerStyleActionSheet;
    }

    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"Choose Operation" message:nil preferredStyle:style];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *previewAction = [UIAlertAction actionWithTitle:@"Preview"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *_Nonnull action) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf previewFile:filePath];
    }];
    UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"Share"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *_Nonnull action) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf shareFileWithPath:filePath];
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *_Nonnull action) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf deleteFileWithPath:filePath];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *_Nonnull action){
    }];
    [alertVc addAction:previewAction];
    [alertVc addAction:shareAction];
    [alertVc addAction:cancelAction];

    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)previewFile:(NSString *)filePath {
    DoraemonSanboxDetailViewController *detalVc = [[DoraemonSanboxDetailViewController alloc] init];
    detalVc.filePath = filePath;
    [self.navigationController pushViewController:detalVc animated:YES];
}

- (void)shareFileWithPath:(NSString *)filePath {
    [DoraemonUtil shareURL:[NSURL fileURLWithPath:filePath] formVC:self];
}

- (void)deleteFileWithPath:(NSString *)filePath {
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:filePath error:nil];
    [self loadPath:_currentDirModel.path];
}

- (void)deleteFileWithPaths:(NSArray<NSString *> *)filePaths {
    NSFileManager *fm = [NSFileManager defaultManager];
    for (NSString *path in filePaths) {
        [fm removeItemAtPath:path error:nil];
    }
    [self loadPath:_currentDirModel.path];
}

- (void)applySnapshot {
    NSDiffableDataSourceSnapshot<NSNumber *, DoraemonSandboxModel *> *snapshot = [[NSDiffableDataSourceSnapshot alloc] init];
    [snapshot appendSectionsWithIdentifiers:@[ @0 ]];
    [snapshot appendItemsWithIdentifiers:self.dataArray];
    [self.dataSource applySnapshot:snapshot animatingDifferences:YES];
}

#pragma mark - Sort Menu
- (NSString *)sortMenuTitleForType:(SortBy)type {
    switch (type) {
        case SortByName:
            return @"Name";
        case SortBySizeAscending:
            return @"Ascending";
        case SortBySizeDescending:
            return @"Descending";
    }
}

- (void)showSortMenu {
    if (self.isEditingMode)
        return;
    UIAlertController *menu = [UIAlertController alertControllerWithTitle:@"Sort by" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    __weak typeof(self) weakSelf = self;
    void (^sortAction)(SortBy) = ^(SortBy type) {
        NSString *name = [self sortMenuTitleForType:type];
        UIAlertAction *action = [UIAlertAction actionWithTitle:name
                                                         style:self.sortType == type ? UIAlertActionStyleDestructive : UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *_Nonnull action) {
                                                           __strong typeof(self) strongSelf = weakSelf;
                                                           [strongSelf sortWithType:type];
                                                           strongSelf.sortButton.title = name;
                                                       }];
        [menu addAction:action];
    };

    sortAction(SortByName);
    sortAction(SortBySizeAscending);
    sortAction(SortBySizeDescending);

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [menu addAction:cancel];

    [self presentViewController:menu animated:YES completion:nil];
}

- (void)sortWithType:(SortBy)type {
    switch (type) {
    case SortByName:
        self.dataArray = [self sortDataByName:self.dataArray];
        break;
    case SortBySizeAscending:
        self.dataArray = [self sortDataBySize:self.dataArray asecending:YES];
        break;
    case SortBySizeDescending:
        self.dataArray = [self sortDataBySize:self.dataArray asecending:NO];
        break;
    }
    self.sortType = type;
    [self applySnapshot];
}

- (NSArray<DoraemonSandboxModel *> *)sortDataDefault:(NSArray<DoraemonSandboxModel *> *)arr {
    return [arr sortedArrayUsingComparator:^NSComparisonResult(DoraemonSandboxModel *_Nonnull obj1, DoraemonSandboxModel *_Nonnull obj2) {
        BOOL isObj1Directory = (obj1.type == DoraemonSandboxFileTypeDirectory);
        BOOL isObj2Directory = (obj2.type == DoraemonSandboxFileTypeDirectory);

        BOOL isSameType = ((isObj1Directory && isObj2Directory) || (!isObj1Directory && !isObj2Directory));

        if (isSameType) {
            return [obj1.name.lowercaseString compare:obj2.name.lowercaseString];
        }

        if (isObj1Directory) {
            return NSOrderedAscending;
        }

        return NSOrderedDescending;
    }];
}

- (NSArray<DoraemonSandboxModel *> *)sortDataByName:(NSArray<DoraemonSandboxModel *> *)arr {
    return [arr sortedArrayUsingComparator:^NSComparisonResult(DoraemonSandboxModel *_Nonnull obj1, DoraemonSandboxModel *_Nonnull obj2) {
        return [obj1.name.lowercaseString compare:obj2.name.lowercaseString];
    }];
}

- (NSArray<DoraemonSandboxModel *> *)sortDataBySize:(NSArray<DoraemonSandboxModel *> *)arr asecending:(BOOL)ascending {
    return [arr sortedArrayUsingComparator:^NSComparisonResult(DoraemonSandboxModel *_Nonnull obj1, DoraemonSandboxModel *_Nonnull obj2) {
        NSInteger size1 = obj1.fileSize;
        NSInteger size2 = obj2.fileSize;
        if (size1 == size2)
            return NSOrderedSame;
        if (ascending) {
            return size1 < size2 ? NSOrderedAscending : NSOrderedDescending;
        } else {
            return size1 > size2 ? NSOrderedAscending : NSOrderedDescending;
        }
    }];
}

@end
