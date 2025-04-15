//
//  DoraemonManager.h
//  DoraemonKit
//
//  Created by yixiang on 2017/12/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^DoraemonH5DoorBlock)(NSString *);
typedef UIImage * _Nullable (^DoraemonWebpHandleBlock)(NSString *filePath);

typedef NS_ENUM(NSUInteger, DoraemonManagerPluginType) {
    #pragma mark - Common
    DoraemonManagerPluginType_DoraemonAppSettingPlugin,
    DoraemonManagerPluginType_DoraemonAppInfoPlugin,
    DoraemonManagerPluginType_DoraemonSandboxPlugin,
    DoraemonManagerPluginType_DoraemonGPSPlugin,
    DoraemonManagerPluginType_DoraemonH5Plugin,
    DoraemonManagerPluginType_DoraemonDeleteLocalDataPlugin,
    DoraemonManagerPluginType_DoraemonNSUserDefaultsPlugin,
    DoraemonManagerPluginType_DoraemonJavaScriptPlugin,
    
    #pragma mark - Performance
    DoraemonManagerPluginType_DoraemonFPSPlugin,
    DoraemonManagerPluginType_DoraemonCPUPlugin,
    DoraemonManagerPluginType_DoraemonMemoryPlugin,
    DoraemonManagerPluginType_DoraemonANRPlugin,
    DoraemonManagerPluginType_DoraemonMethodUseTimePlugin,
    DoraemonManagerPluginType_DoraemonUIProfilePlugin,
    DoraemonManagerPluginType_DoraemonHierarchyPlugin,
    DoraemonManagerPluginType_DoraemonTimeProfilePlugin,
    
    #pragma mark - UI
    DoraemonManagerPluginType_DoraemonColorPickPlugin,
    DoraemonManagerPluginType_DoraemonViewCheckPlugin,
    DoraemonManagerPluginType_DoraemonViewAlignPlugin,
    DoraemonManagerPluginType_DoraemonViewMetricsPlugin,
};

@interface DoraemonManagerPluginTypeModel : NSObject
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *desc;
@property(nonatomic, copy) NSString *icon;
@property(nonatomic, copy) NSString *pluginName;
@property(nonatomic, copy) NSString *atModule;
@end

@interface DoraemonManager : NSObject
+ (nonnull DoraemonManager *)shareInstance;

@property (nonatomic, assign) BOOL autoDock; //dokit entry icon support autoDock，deffault yes

- (void)install;

- (void)installWithStartingPosition:(CGPoint) position;

- (void)installWithCustomBlock:(void(^)(void))customBlock;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic, copy) DoraemonH5DoorBlock h5DoorBlock;
@property (nonatomic, copy) DoraemonWebpHandleBlock webpHandleBlock;

- (void)addPluginWithTitle:(NSString *)title icon:(NSString *)iconName desc:(NSString *)desc pluginName:(NSString *)entryName atModule:(NSString *)moduleName;
- (void)addPluginWithTitle:(NSString *)title icon:(NSString *)iconName desc:(NSString *)desc pluginName:(NSString *)entryName atModule:(NSString *)moduleName handle:(void(^)(NSDictionary *itemData))handleBlock;

- (void)addPluginWithTitle:(NSString *)title image:(UIImage *)image desc:(NSString *)desc pluginName:(NSString *)entryName atModule:(NSString *)moduleName handle:(void(^ _Nullable)(NSDictionary *itemData))handleBlock;

- (void)removePluginWithPluginType:(DoraemonManagerPluginType)pluginType;

- (void)removePluginWithPluginName:(NSString *)pluginName atModule:(NSString *)moduleName;

- (void)addStartPlugin:(NSString *)pluginName;

- (void)addH5DoorBlock:(DoraemonH5DoorBlock)block;

- (void)addANRBlock:(void(^)(NSDictionary *anrDic))block;

- (void)addPerformanceBlock:(void(^)(NSDictionary *performanceDic))block;

- (void)addWebpHandleBlock:(DoraemonWebpHandleBlock)block;

- (BOOL)isShowDoraemon;

- (void)showDoraemon;

- (void)hiddenDoraemon;

- (void)hiddenHomeWindow;

@property (nonatomic, strong) NSMutableDictionary *keyBlockDic;

@property (assign, nonatomic) UIInterfaceOrientationMask supportedInterfaceOrientations;

- (void)configEntryBtnBlingWithText:(nullable NSString *)text backColor:(nullable UIColor *)backColor;
@end
NS_ASSUME_NONNULL_END
