//
//  DoraemonJavaScriptViewController.m
//  DoraemonKit
//
//  Created by carefree on 2022/5/11.
//

#import "DoraemonJavaScriptViewController.h"
#import "DoraemonJavaScriptDetailViewController.h"
#import "DoraemonCacheManager.h"
#import "DoraemonDefine.h"

@interface DoraemonJavaScriptViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation DoraemonJavaScriptViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Script List";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewScript)];
    self.items = [NSMutableArray array];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 100;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadScriptData];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [self.items[indexPath.row] objectForKey:@"value"];
    cell.textLabel.numberOfLines = 4;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DoraemonJavaScriptDetailViewController *detailVC = [[DoraemonJavaScriptDetailViewController alloc] init];
    detailVC.key = [self.items[indexPath.row] objectForKey:@"key"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *key = [self.items[indexPath.row] objectForKey:@"key"];
        [DoraemonCacheManager.sharedInstance clearJsHistoricalRecordWithKey:key];
        [self loadScriptData];
        [self.tableView reloadData];
    }
}

#pragma mark - Private
- (void)addNewScript {
    DoraemonJavaScriptDetailViewController *detailVC = [[DoraemonJavaScriptDetailViewController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)loadScriptData {
    [self.items removeAllObjects];
    
    NSArray *scriptItems = [DoraemonCacheManager.sharedInstance jsHistoricalRecord];
    if (!scriptItems) {
        
        [DoraemonCacheManager.sharedInstance saveJsHistoricalRecordWithText:@"//isntall vConsole\nimport('https://unpkg.com/vconsole').then(() => {\n    new window.VConsole()\n})" forKey:@"vConsole"];
        [DoraemonCacheManager.sharedInstance saveJsHistoricalRecordWithText:@"//reload \nlocation.reload()" forKey:@"Reload"];
        [DoraemonCacheManager.sharedInstance saveJsHistoricalRecordWithText:@"//back \nhistory.go(-1)" forKey:@"Back"];
        [DoraemonCacheManager.sharedInstance saveJsHistoricalRecordWithText:@"//forward \nhistory.go(1)" forKey:@"Forward"];

        scriptItems = [DoraemonCacheManager.sharedInstance jsHistoricalRecord];
    }
    [self.items addObjectsFromArray:scriptItems];
}
@end
