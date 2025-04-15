//
//  DoraemonANRTool.h
//  DoraemonKit
//
//  Created by DeveloperLY on 2019/9/18.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DoraemonANRTool : NSObject
+ (void)saveANRInfo:(NSDictionary *)info;

+ (NSString *)anrDirectory;
@end

NS_ASSUME_NONNULL_END
