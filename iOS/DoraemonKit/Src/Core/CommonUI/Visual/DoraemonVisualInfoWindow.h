//
//  DoraemonVisualInfoWindow.h
//  DoraemonKit
//
//  Created by wenquan on 2018/12/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DoraemonVisualInfoWindow : UIWindow
@property (nonatomic, copy) NSString *infoText;
@property (nonatomic, copy) NSAttributedString *infoAttributedText;
@end

NS_ASSUME_NONNULL_END
