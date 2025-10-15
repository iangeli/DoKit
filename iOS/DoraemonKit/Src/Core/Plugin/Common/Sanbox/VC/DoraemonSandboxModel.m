//
//  DoraemonSandboxModel.m
//  DoraemonKit
//
//  Created by yixiang on 2017/12/11.
//

#import "DoraemonSandboxModel.h"
#import "DoraemonUtil.h"

@interface DoraemonSandboxModel ()
@property (nonatomic, assign) NSInteger internalFileSize;
@end

@implementation DoraemonSandboxModel
- (instancetype)init {
    self = [super init];
    if (self) {
        _internalFileSize = -1;
    }
    return self;
}

- (NSInteger)caculaterFileSize {
    DoraemonUtil *util = [[DoraemonUtil alloc] init];
    [util getFileSizeWithPath:_path];
    return util.fileSize;
}

- (NSInteger)fileSize {
    if (_internalFileSize >= 0) {
        return _internalFileSize;
    }
    _internalFileSize = [self caculaterFileSize];
    return _internalFileSize;
}
@end
