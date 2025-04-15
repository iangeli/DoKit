//
//  DoraemonCacheManager.h
//  DoraemonKit
//
//  Created by yixiang on 2017/12/12.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface DoraemonCacheManager : NSObject
+ (DoraemonCacheManager *)sharedInstance;

- (void)saveMockGPSSwitch:(BOOL)on;

- (BOOL)mockGPSSwitch;

- (void)saveMockCoordinate:(CLLocationCoordinate2D)coordinate;

- (CLLocationCoordinate2D)mockCoordinate;

- (void)saveFpsSwitch:(BOOL)on;

- (BOOL)fpsSwitch;

- (void)saveCpuSwitch:(BOOL)on;

- (BOOL)cpuSwitch;

- (void)saveMemorySwitch:(BOOL)on;

- (BOOL)memorySwitch;

- (void)saveAllTestSwitch:(BOOL)on;

- (BOOL)allTestSwitch;

- (void)saveLargeImageDetectionSwitch:(BOOL)on;

- (BOOL)largeImageDetectionSwitch;

- (void)saveSubThreadUICheckSwitch:(BOOL)on;

- (BOOL)subThreadUICheckSwitch;

- (void)saveMethodUseTimeSwitch:(BOOL)on;

- (BOOL)methodUseTimeSwitch;

- (void)saveStartTimeSwitch:(BOOL)on;

- (BOOL)startTimeSwitch;

- (void)saveANRTrackSwitch:(BOOL)on;

- (BOOL)anrTrackSwitch;

- (NSArray<NSString *> *)h5historicalRecord;
- (void)saveH5historicalRecordWithText:(NSString *)text;
- (void)clearAllH5historicalRecord;
- (void)clearH5historicalRecordWithText:(NSString *)text;

- (NSArray<NSDictionary *> *)jsHistoricalRecord;
- (NSString *)jsHistoricalRecordForKey:(NSString *)key;
- (void)saveJsHistoricalRecordWithText:(NSString *)text forKey:(NSString *)key;
- (void)clearJsHistoricalRecordWithKey:(NSString *)key;

- (void)saveStartClass : (NSString *)startClass;
- (NSString *)startClass;

- (void)saveMemoryLeak:(BOOL)on;
- (BOOL)memoryLeak;

- (void)saveMemoryLeakAlert:(BOOL)on;
- (BOOL)memoryLeakAlert;

- (void)saveKitManagerData:(NSMutableArray *)dataArray;
- (NSMutableArray *)kitManagerData;
- (NSMutableArray *)kitShowManagerData;
- (NSMutableArray *)allKitShowManagerData;
@end
