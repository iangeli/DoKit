//
//  DoraemonManager.m
//  DoraemonKit
//
//  Created by yixiang on 2017/12/11.
//
#import "DoraemonManager.h"
#import "DoraemonANRManager.h"
#import "DoraemonCacheManager.h"
#import "DoraemonDefine.h"
#import "DoraemonEntryWindow.h"
#import "DoraemonHomeWindow.h"
#import "DoraemonOscillogramWindowManager.h"
#import "DoraemonStartPluginProtocol.h"
#import "DoraemonUtil.h"
#import <UIKit/UIKit.h>

#if DoraemonWithGPS
#import "DoraemonGPSMocker.h"
#endif

#define kTitle @"title"
#define kDesc @"desc"
#define kIcon @"icon"
#define kPluginName @"pluginName"
#define kAtModule @"atModule"

@implementation DoraemonManagerPluginTypeModel
@end

typedef void (^DoraemonANRBlock)(NSDictionary *);
typedef void (^DoraemonPerformanceBlock)(NSDictionary *);

@interface DoraemonManager ()
@property (nonatomic, strong) DoraemonEntryWindow *entryWindow;

@property (nonatomic, strong) NSMutableArray *startPlugins;

@property (nonatomic, copy) DoraemonANRBlock anrBlock;

@property (nonatomic, copy) DoraemonPerformanceBlock performanceBlock;

@property (nonatomic, assign) BOOL hasInstall;

@property (nonatomic) CGPoint startingPosition;
@end

@implementation DoraemonManager
+ (nonnull DoraemonManager *)shareInstance {
    static dispatch_once_t once;
    static DoraemonManager *instance;
    dispatch_once(&once, ^{
        instance = [[DoraemonManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _autoDock = YES;
        _keyBlockDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)install {

    CGPoint defaultPosition = DoraemonStartingPosition;
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (size.width > size.height) {
        defaultPosition = DoraemonFullScreenStartingPosition;
    }
    [self installWithStartingPosition:defaultPosition];
}

- (void)installWithStartingPosition:(CGPoint)position {
    _startingPosition = position;
    [self installWithCustomBlock:^{

    }];
}

- (void)installWithCustomBlock:(void (^)(void))customBlock {

    if (_hasInstall) {
        return;
    }
    _hasInstall = YES;
    for (int i = 0; i < _startPlugins.count; i++) {
        NSString *pluginName = _startPlugins[i];
        Class pluginClass = NSClassFromString(pluginName);
        id<DoraemonStartPluginProtocol> plugin = [[pluginClass alloc] init];
        if (plugin) {
            [plugin startPluginDidLoad];
        }
    }

    [self initData];
    customBlock();

    [self initEntry:self.startingPosition];

#if DoraemonWithGPS

    if ([[DoraemonCacheManager sharedInstance] mockGPSSwitch]) {
        CLLocationCoordinate2D coordinate = [[DoraemonCacheManager sharedInstance] mockCoordinate];
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        [[DoraemonGPSMocker shareInstance] mockPoint:loc];
    }
#endif

    [[DoraemonANRManager sharedInstance] addANRBlock:^(NSDictionary *anrInfo) {
        if (self.anrBlock) {
            self.anrBlock(anrInfo);
        }
    }];
}

- (void)initData {
#pragma mark - Common
    [self addPluginWithPluginType:DoraemonManagerPluginType_DoraemonAppSettingPlugin];
    [self addPluginWithPluginType:DoraemonManagerPluginType_DoraemonAppInfoPlugin];
    [self addPluginWithPluginType:DoraemonManagerPluginType_DoraemonSandboxPlugin];
#if DoraemonWithGPS
    [self addPluginWithPluginType:DoraemonManagerPluginType_DoraemonGPSPlugin];
#endif

    [self addPluginWithPluginType:DoraemonManagerPluginType_DoraemonH5Plugin];
    [self addPluginWithPluginType:DoraemonManagerPluginType_DoraemonDeleteLocalDataPlugin];
    [self addPluginWithPluginType:DoraemonManagerPluginType_DoraemonNSUserDefaultsPlugin];
    [self addPluginWithPluginType:DoraemonManagerPluginType_DoraemonJavaScriptPlugin];

#pragma mark - Performance
    [self addPluginWithPluginType:DoraemonManagerPluginType_DoraemonFPSPlugin];
    [self addPluginWithPluginType:DoraemonManagerPluginType_DoraemonCPUPlugin];
    [self addPluginWithPluginType:DoraemonManagerPluginType_DoraemonMemoryPlugin];
    [self addPluginWithPluginType:DoraemonManagerPluginType_DoraemonANRPlugin];
    [self addPluginWithPluginType:DoraemonManagerPluginType_DoraemonTimeProfilePlugin];
#if DoraemonWithUIProfile
    [self addPluginWithPluginType:DoraemonManagerPluginType_DoraemonUIProfilePlugin];
#endif
#if DoraemonWithLoad
    [self addPluginWithPluginType:DoraemonManagerPluginType_DoraemonMethodUseTimePlugin];
#endif

#pragma mark - UI
    [self addPluginWithPluginType:DoraemonManagerPluginType_DoraemonColorPickPlugin];
    [self addPluginWithPluginType:DoraemonManagerPluginType_DoraemonViewCheckPlugin];
    [self addPluginWithPluginType:DoraemonManagerPluginType_DoraemonViewAlignPlugin];
    [self addPluginWithPluginType:DoraemonManagerPluginType_DoraemonHierarchyPlugin];
#if DoraemonWithViewMetrics
    [self addPluginWithPluginType:DoraemonManagerPluginType_DoraemonViewMetricsPlugin];
#endif
}

- (void)initEntry:(CGPoint)startingPosition {
    _entryWindow = [[DoraemonEntryWindow alloc] initWithStartPoint:startingPosition];

    if (_autoDock) {
        [_entryWindow setAutoDock:YES];
    }
}

- (void)checkStatus {
    [DoraemonOscillogramWindowManager.shareInstance checkStatus];
}

- (void)addStartPlugin:(NSString *)pluginName {
    if (!_startPlugins) {
        _startPlugins = [[NSMutableArray alloc] init];
    }
    [_startPlugins addObject:pluginName];
}

- (void)addPluginWithPluginType:(DoraemonManagerPluginType)pluginType {
    DoraemonManagerPluginTypeModel *model = [self getDefaultPluginDataWithPluginType:pluginType];
    [self addPluginWithTitle:model.title icon:model.icon desc:model.desc pluginName:model.pluginName atModule:model.atModule];
}

- (void)addPluginWithTitle:(NSString *)title icon:(NSString *)iconName desc:(NSString *)desc pluginName:(NSString *)entryName atModule:(NSString *)moduleName {
    NSMutableDictionary *pluginDic = [self foundGroupWithModule:moduleName];
    pluginDic[@"key"] = [NSString stringWithFormat:@"%@-%@-%@-%@", moduleName, title, iconName, desc];
    pluginDic[@"name"] = title;
    pluginDic[@"icon"] = iconName;
    pluginDic[@"desc"] = desc;
    pluginDic[@"pluginName"] = entryName;
    pluginDic[@"show"] = @1;
}

- (void)addPluginWithTitle:(NSString *)title icon:(NSString *)iconName desc:(NSString *)desc pluginName:(NSString *)entryName atModule:(NSString *)moduleName handle:(void (^)(NSDictionary *))handleBlock {
    NSMutableDictionary *pluginDic = [self foundGroupWithModule:moduleName];
    pluginDic[@"key"] = [NSString stringWithFormat:@"%@-%@-%@-%@", moduleName, title, iconName, desc];
    pluginDic[@"name"] = title;
    pluginDic[@"icon"] = iconName;
    pluginDic[@"desc"] = desc;
    pluginDic[@"pluginName"] = entryName;
    [_keyBlockDic setValue:[handleBlock copy] forKey:pluginDic[@"key"]];
    pluginDic[@"show"] = @1;
}

- (void)addPluginWithTitle:(NSString *)title image:(UIImage *)image desc:(NSString *)desc pluginName:(NSString *)entryName atModule:(NSString *)moduleName handle:(void (^)(NSDictionary *_Nonnull))handleBlock {
    NSMutableDictionary *pluginDic = [self foundGroupWithModule:moduleName];
    pluginDic[@"key"] = [NSString stringWithFormat:@"%@-%@-%@", moduleName, title, desc];
    pluginDic[@"name"] = title;
    pluginDic[@"image"] = image;
    pluginDic[@"desc"] = desc;
    pluginDic[@"pluginName"] = entryName;
    if (handleBlock) {
        [_keyBlockDic setValue:[handleBlock copy] forKey:pluginDic[@"key"]];
    }
    pluginDic[@"show"] = @1;
}

- (NSMutableDictionary *)foundGroupWithModule:(NSString *)module {
    NSMutableDictionary *pluginDic = [NSMutableDictionary dictionary];
    pluginDic[@"moduleName"] = module;
    __block BOOL hasModule = NO;
    [self.dataArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSDictionary *moduleDic = obj;
        NSString *moduleName = moduleDic[@"moduleName"];
        if ([moduleName isEqualToString:module]) {
            hasModule = YES;
            NSMutableArray *pluginArray = moduleDic[@"pluginArray"];
            if (pluginArray) {
                [pluginArray addObject:pluginDic];
            }
            [moduleDic setValue:pluginArray forKey:@"pluginArray"];
            *stop = YES;
        }
    }];
    if (!hasModule) {
        NSMutableArray *pluginArray = [[NSMutableArray alloc] initWithObjects:pluginDic, nil];
        [self registerPluginArray:pluginArray withModule:module];
    }
    return pluginDic;
}
- (void)removePluginWithPluginType:(DoraemonManagerPluginType)pluginType {
    DoraemonManagerPluginTypeModel *model = [self getDefaultPluginDataWithPluginType:pluginType];
    [self removePluginWithPluginName:model.pluginName atModule:model.atModule];
}

- (void)removePluginWithPluginName:(NSString *)pluginName atModule:(NSString *)moduleName {
    [self unregisterPlugin:pluginName withModule:moduleName];
}

- (void)registerPluginArray:(NSMutableArray *)array withModule:(NSString *)moduleName {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:moduleName forKey:@"moduleName"];
    [dic setValue:array forKey:@"pluginArray"];
    [_dataArray addObject:dic];
}

- (void)unregisterPlugin:(NSString *)pluginName withModule:(NSString *)moduleName {
    if (!_dataArray) {
        return;
    }
    id object;
    for (object in _dataArray) {
        NSString *tempModuleName = [((NSMutableDictionary *)object) valueForKey:@"moduleName"];
        if ([tempModuleName isEqualToString:moduleName]) {
            NSMutableArray *tempPluginArray = [((NSMutableDictionary *)object) valueForKey:@"pluginArray"];
            id pluginObject;
            for (pluginObject in tempPluginArray) {
                NSString *tempPluginName = [((NSMutableDictionary *)pluginObject) valueForKey:@"pluginName"];
                if ([tempPluginName isEqualToString:pluginName]) {
                    [tempPluginArray removeObject:pluginObject];
                    return;
                }
            }
        }
    }
}

- (BOOL)isShowDoraemon {
    if (!_entryWindow) {
        return NO;
    }
    return !_entryWindow.hidden;
}

- (void)showDoraemon {
    if (_entryWindow.windowScene == nil) {
        UIScene *scene = [[UIApplication sharedApplication].connectedScenes anyObject];
        if (scene) {
            _entryWindow.windowScene = (UIWindowScene *)scene;
        }
    }
    if (_entryWindow.hidden) {
        _entryWindow.hidden = NO;
    }
}

- (void)hiddenDoraemon {
    if (!_entryWindow.hidden) {
        _entryWindow.hidden = YES;
    }
}

- (void)addH5DoorBlock:(void (^)(NSString *h5Url))block {
    self.h5DoorBlock = block;
}

- (void)addANRBlock:(void (^)(NSDictionary *anrDic))block {
    self.anrBlock = block;
}

- (void)addPerformanceBlock:(void (^)(NSDictionary *performanceDic))block {
    self.performanceBlock = block;
}

- (void)addWebpHandleBlock:(UIImage * (^)(NSString *filePath))block {
    self.webpHandleBlock = block;
}

- (void)hiddenHomeWindow {
    [[DoraemonHomeWindow shareInstance] hide];
}

#pragma mark - default data
- (DoraemonManagerPluginTypeModel *)getDefaultPluginDataWithPluginType:(DoraemonManagerPluginType)pluginType {
    NSArray *dataArray = @{
        @(DoraemonManagerPluginType_DoraemonAppSettingPlugin) : @[
            @{kTitle : @"App Settings"},
            @{kDesc : @"App Settings"},
            @{kIcon : @"doraemon_setting"},
            @{kPluginName : @"DoraemonAppSettingPlugin"},
            @{kAtModule : @"Common"}
        ],
        @(DoraemonManagerPluginType_DoraemonAppInfoPlugin) : @[
            @{kTitle : @"App Info"},
            @{kDesc : @"App Info"},
            @{kIcon : @"doraemon_app_info"},
            @{kPluginName : @"DoraemonAppInfoPlugin"},
            @{kAtModule : @"Common"}
        ],
        @(DoraemonManagerPluginType_DoraemonSandboxPlugin) : @[
            @{kTitle : @"Sandbox"},
            @{kDesc : @"Sandbox"},
            @{kIcon : @"doraemon_file"},
            @{kPluginName : @"DoraemonSandboxPlugin"},
            @{kAtModule : @"Common"}
        ],
        @(DoraemonManagerPluginType_DoraemonGPSPlugin) : @[
            @{kTitle : @"Mock GPS"},
            @{kDesc : @"Mock GPS"},
            @{kIcon : @"doraemon_mock_gps"},
            @{kPluginName : @"DoraemonGPSPlugin"},
            @{kAtModule : @"Common"}
        ],
        @(DoraemonManagerPluginType_DoraemonH5Plugin) : @[
            @{kTitle : @"Browser"},
            @{kDesc : @"Browser"},
            @{kIcon : @"doraemon_h5"},
            @{kPluginName : @"DoraemonH5Plugin"},
            @{kAtModule : @"Common"}
        ],
        @(DoraemonManagerPluginType_DoraemonDeleteLocalDataPlugin) : @[
            @{kTitle : @"Clear Sanbox"},
            @{kDesc : @"Clear Sanbox"},
            @{kIcon : @"doraemon_qingchu"},
            @{kPluginName : @"DoraemonDeleteLocalDataPlugin"},
            @{kAtModule : @"Common"}
        ],
        @(DoraemonManagerPluginType_DoraemonNSUserDefaultsPlugin) : @[
            @{kTitle : @"UserDefaults"},
            @{kDesc : @"UserDefaults"},
            @{kIcon : @"doraemon_database"},
            @{kPluginName : @"DoraemonNSUserDefaultsPlugin"},
            @{kAtModule : @"Common"}
        ],
        @(DoraemonManagerPluginType_DoraemonJavaScriptPlugin) : @[
            @{kTitle : @"JavaScript"},
            @{kDesc : @"JavaScript"},
            @{kIcon : @"doraemon_js"},
            @{kPluginName : @"DoraemonJavaScriptPlugin"},
            @{kAtModule : @"Common"}
        ],
        // Performance
        @(DoraemonManagerPluginType_DoraemonFPSPlugin) : @[
            @{kTitle : @"FPS"},
            @{kDesc : @"FPS"},
            @{kIcon : @"doraemon_fps"},
            @{kPluginName : @"DoraemonFPSPlugin"},
            @{kAtModule : @"Performance"}
        ],
        @(DoraemonManagerPluginType_DoraemonCPUPlugin) : @[
            @{kTitle : @"CPU"},
            @{kDesc : @"CPU"},
            @{kIcon : @"doraemon_cpu"},
            @{kPluginName : @"DoraemonCPUPlugin"},
            @{kAtModule : @"Performance"}
        ],
        @(DoraemonManagerPluginType_DoraemonMemoryPlugin) : @[
            @{kTitle : @"Memory"},
            @{kDesc : @"Memory"},
            @{kIcon : @"doraemon_memory"},
            @{kPluginName : @"DoraemonMemoryPlugin"},
            @{kAtModule : @"Performance"}
        ],
        @(DoraemonManagerPluginType_DoraemonANRPlugin) : @[
            @{kTitle : @"ANR"},
            @{kDesc : @"ANR"},
            @{kIcon : @"doraemon_kadun"},
            @{kPluginName : @"DoraemonANRPlugin"},
            @{kAtModule : @"Performance"}
        ],
        @(DoraemonManagerPluginType_DoraemonMethodUseTimePlugin) : @[
            @{kTitle : @"Load"},
            @{kDesc : @"Load"},
            @{kIcon : @"doraemon_method_use_time"},
            @{kPluginName : @"DoraemonMethodUseTimePlugin"},
            @{kAtModule : @"Performance"}
        ],
        @(DoraemonManagerPluginType_DoraemonUIProfilePlugin) : @[
            @{kTitle : @"UI Hierarchy"},
            @{kDesc : @"UI Level"},
            @{kIcon : @"doraemon_view_level"},
            @{kPluginName : @"DoraemonUIProfilePlugin"},
            @{kAtModule : @"Performance"}
        ],
        @(DoraemonManagerPluginType_DoraemonTimeProfilePlugin) : @[
            @{kTitle : @"Time Profiler"},
            @{kDesc : @"Function time statistics"},
            @{kIcon : @"doraemon_time_profiler"},
            @{kPluginName : @"DoraemonTimeProfilerPlugin"},
            @{kAtModule : @"Performance"}
        ],
        // UI
        @(DoraemonManagerPluginType_DoraemonColorPickPlugin) : @[
            @{kTitle : @"Color Picker"},
            @{kDesc : @"Color Picker"},
            @{kIcon : @"doraemon_straw"},
            @{kPluginName : @"DoraemonColorPickPlugin"},
            @{kAtModule : @"UI"}
        ],
        @(DoraemonManagerPluginType_DoraemonViewCheckPlugin) : @[
            @{kTitle : @"View Check"},
            @{kDesc : @"View Check"},
            @{kIcon : @"doraemon_view_check"},
            @{kPluginName : @"DoraemonViewCheckPlugin"},
            @{kAtModule : @"UI"}
        ],
        @(DoraemonManagerPluginType_DoraemonViewAlignPlugin) : @[
            @{kTitle : @"Align Ruler"},
            @{kDesc : @"Align Ruler"},
            @{kIcon : @"doraemon_align"},
            @{kPluginName : @"DoraemonViewAlignPlugin"},
            @{kAtModule : @"UI"}
        ],
        @(DoraemonManagerPluginType_DoraemonViewMetricsPlugin) : @[
            @{kTitle : @"View Border"},
            @{kDesc : @"View Border"},
            @{kIcon : @"doraemon_viewmetrics"},
            @{kPluginName : @"DoraemonViewMetricsPlugin"},
            @{kAtModule : @"UI"}
        ],
        @(DoraemonManagerPluginType_DoraemonHierarchyPlugin) : @[
            @{kTitle : @"UI Structure"},
            @{kDesc : @"Display UI structure"},
            @{kIcon : @"doraemon_view_level"},
            @{kPluginName : @"DoraemonHierarchyPlugin"},
            @{kAtModule : @"UI"}
        ],
    }[@(pluginType)];

    DoraemonManagerPluginTypeModel *model = [DoraemonManagerPluginTypeModel new];
    model.title = dataArray[0][kTitle];
    model.desc = dataArray[1][kDesc];
    model.icon = dataArray[2][kIcon];
    model.pluginName = dataArray[3][kPluginName];
    model.atModule = dataArray[4][kAtModule];
    return model;
}

- (void)configEntryBtnBlingWithText:(NSString *)text backColor:(UIColor *)backColor {
    [self.entryWindow configEntryBtnBlingWithText:text backColor:backColor];
}
@end
