//
//  DoraemonSandboxModel.h
//  DoraemonKit
//
//  Created by yixiang on 2017/12/11.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DoraemonSandboxFileType) {
    DoraemonSandboxFileTypeDirectory = 0,
    DoraemonSandboxFileTypeFile,
    DoraemonSandboxFileTypeBack,
    DoraemonSandboxFileTypeRoot,
};

@interface DoraemonSandboxModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, assign) DoraemonSandboxFileType type;
@property (nonatomic, assign) NSInteger fileSize;
@end
