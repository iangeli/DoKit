//
//  DoraemonCacheManager.m
//  DoraemonKit
//
//  Created by yixiang on 2017/12/12.
//

#import "DoraemonCacheManager.h"
#import "DoraemonManager.h"
#import "DoraemonDefine.h"
#import "DoraemonManager.h"

static NSString * const kDoraemonMockGPSSwitchKey = @"ud_mock_gps_key";
static NSString * const kDoraemonMockCoordinateKey = @"ud_mock_coordinate_key";
static NSString * const kDoraemonFpsKey = @"ud_fps_key";
static NSString * const kDoraemonCpuKey = @"ud_cpu_key";
static NSString * const kDoraemonMemoryKey = @"ud_memory_key";
static NSString * const kDoraemonMethodUseTimeKey = @"ud_method_use_time_key";
static NSString * const kDoraemonH5historicalRecord = @"ud_historical_record";
static NSString * const kDoraemonJsHistoricalRecord = @"ud_js_historical_record";
static NSString * const kDoraemonANRTrackKey = @"ud_anr_track_key";

@interface DoraemonCacheManager()
@property (nonatomic, strong) NSUserDefaults *defaults;
@property (nonatomic, assign) BOOL memoryLeakOn;
@property (nonatomic, assign) BOOL firstReadMemoryLeakOn;
@end

@implementation DoraemonCacheManager
+ (DoraemonCacheManager *)sharedInstance{
    static dispatch_once_t once;
    static DoraemonCacheManager *instance;
    dispatch_once(&once, ^{
        instance = [[DoraemonCacheManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self  = [super init];
    if (self) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)saveMockGPSSwitch:(BOOL)on{
    [_defaults setBool:on forKey:kDoraemonMockGPSSwitchKey];
    [_defaults synchronize];
}

- (BOOL)mockGPSSwitch{
    return [_defaults boolForKey:kDoraemonMockGPSSwitchKey];
}

- (void)saveMockCoordinate:(CLLocationCoordinate2D)coordinate{
    NSDictionary *dic = @{
                          @"longitude":@(coordinate.longitude),
                          @"latitude":@(coordinate.latitude)
                          };
    [_defaults setObject:dic forKey:kDoraemonMockCoordinateKey];
    [_defaults synchronize];
}

- (CLLocationCoordinate2D)mockCoordinate{
    NSDictionary *dic = [_defaults valueForKey:kDoraemonMockCoordinateKey];
    CLLocationCoordinate2D coordinate ;
    if (dic[@"longitude"]) {
        coordinate.longitude = [dic[@"longitude"] doubleValue];
    }else{
        coordinate.longitude = 0.;
    }
    if (dic[@"latitude"]) {
        coordinate.latitude = [dic[@"latitude"] doubleValue];
    }else{
        coordinate.latitude = 0.;
    }
    
    return coordinate;
}

- (void)saveFpsSwitch:(BOOL)on{
    [_defaults setBool:on forKey:kDoraemonFpsKey];
    [_defaults synchronize];
}

- (BOOL)fpsSwitch{
    return [_defaults boolForKey:kDoraemonFpsKey];
}

- (void)saveCpuSwitch:(BOOL)on{
    [_defaults setBool:on forKey:kDoraemonCpuKey];
    [_defaults synchronize];
}

- (BOOL)cpuSwitch{
    return [_defaults boolForKey:kDoraemonCpuKey];
}

- (void)saveMemorySwitch:(BOOL)on{
    [_defaults setBool:on forKey:kDoraemonMemoryKey];
    [_defaults synchronize];
}

- (BOOL)memorySwitch{
    return [_defaults boolForKey:kDoraemonMemoryKey];
}

- (void)saveMethodUseTimeSwitch:(BOOL)on{
    [_defaults setBool:on forKey:kDoraemonMethodUseTimeKey];
    [_defaults synchronize];
}

- (BOOL)methodUseTimeSwitch{
    return [_defaults boolForKey:kDoraemonMethodUseTimeKey];
}

- (void)saveANRTrackSwitch:(BOOL)on {
    [_defaults setBool:on forKey:kDoraemonANRTrackKey];
    [_defaults synchronize];
}

- (BOOL)anrTrackSwitch {
    return [_defaults boolForKey:kDoraemonANRTrackKey];
}

- (NSArray<NSString *> *)h5historicalRecord {
    return [_defaults objectForKey:kDoraemonH5historicalRecord];
}

- (void)saveH5historicalRecordWithText:(NSString *)text {
    
    if (!text || text.length <= 0) { return; }
    
    NSArray *records = [self h5historicalRecord];
    
    NSMutableArray *muarr = [NSMutableArray arrayWithArray:records];

    if ([muarr containsObject:text]) {
        if ([muarr.firstObject isEqualToString:text]) {
            return;
        }
        [muarr removeObject:text];
    }
    [muarr insertObject:text atIndex:0];

    if (muarr.count > 10) { [muarr removeLastObject]; }
    
    [_defaults setObject:muarr.copy forKey:kDoraemonH5historicalRecord];
    [_defaults synchronize];
}

- (void)clearAllH5historicalRecord {
    [_defaults removeObjectForKey:kDoraemonH5historicalRecord];
    [_defaults synchronize];
}

- (void)clearH5historicalRecordWithText:(NSString *)text {
    
    if (!text || text.length <= 0) { return; }
    NSArray *records = [self h5historicalRecord];
    
    if (![records containsObject:text]) { return; }
    NSMutableArray *muarr = [NSMutableArray array];
    if (records && records.count > 0) { [muarr addObjectsFromArray:records]; }
    [muarr removeObject:text];

    if (muarr.count > 0) {
        [_defaults setObject:muarr.copy forKey:kDoraemonH5historicalRecord];
    } else {
        [_defaults removeObjectForKey:kDoraemonH5historicalRecord];
    }
    [_defaults synchronize];
}

- (NSArray<NSDictionary *> *)jsHistoricalRecord {
    return [_defaults arrayForKey:kDoraemonJsHistoricalRecord];
}

- (NSString *)jsHistoricalRecordForKey:(NSString *)key {
    NSArray *history = [self jsHistoricalRecord] ?: @[];
    for (NSDictionary *dict in history) {
        
        if ([[dict objectForKey:@"key"] isEqualToString:key]) {
            return [dict objectForKey:@"value"];
        }
    }
    return nil;
}

- (void)saveJsHistoricalRecordWithText:(NSString *)text forKey:(NSString *)key {
    NSString *saveKey = [NSString stringWithFormat:@"%.0f", NSDate.date.timeIntervalSince1970];
    if (key.length > 0) {
        saveKey = key;
    }
    NSMutableArray *list = [NSMutableArray array];
    BOOL matched = NO;
    NSArray *history = [self jsHistoricalRecord] ?: @[];
    for (NSDictionary *dict in history) {
        
        if ([[dict objectForKey:@"key"] isEqualToString:saveKey]) {
            [list addObject:@{
                @"key": saveKey,
                @"value": text
            }];
            matched = YES;
            continue;
        }
        [list addObject:dict];
    }
    if (!matched) {
        [list insertObject:@{
            @"key": saveKey,
            @"value": text
        } atIndex:0];
    }
    [_defaults setObject:list forKey:kDoraemonJsHistoricalRecord];
    [_defaults synchronize];
}

- (void)clearJsHistoricalRecordWithKey:(NSString *)key {
    if (!key) {
        return;
    }
    NSMutableArray *list = [NSMutableArray array];
    NSArray *history = [self jsHistoricalRecord] ?: @[];
    for (NSDictionary *dict in history) {
        
        if ([[dict objectForKey:@"key"] isEqualToString:key]) {
            continue;
        }
        [list addObject:dict];
    }
    [_defaults setObject:list forKey:kDoraemonJsHistoricalRecord];
    [_defaults synchronize];
}

@end
