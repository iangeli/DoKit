//
//  DoraemonAppInfoCell.m
//  DoraemonKit
//
//  Created by yixiang on 2018/4/14.
//

#import "DoraemonAppInfoCell.h"
#import "UIView+Doraemon.h"
#import "DoraemonDefine.h"
#import "UIColor+Doraemon.h"
#import "DoraemonDefine.h"

@interface DoraemonAppInfoCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@end

@implementation DoraemonAppInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
            self.backgroundColor = [UIColor systemBackgroundColor];
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor doraemon_black_1];
        self.titleLabel.font = [UIFont systemFontOfSize:kDoraemonSizeFrom750_Landscape(32)];
        [self.contentView addSubview:self.titleLabel];
        
        self.valueLabel = [[UILabel alloc] init];
        self.valueLabel.textColor = [UIColor doraemon_black_2];
        self.valueLabel.font = [UIFont systemFontOfSize:kDoraemonSizeFrom750_Landscape(32)];
        [self.contentView addSubview:self.valueLabel];
    }
    return self;
}

- (void)renderUIWithData:(NSDictionary *)data{
    NSString *title = data[@"title"];
    NSString *value = data[@"value"];
    
    self.titleLabel.text = title;
    
    NSString *cnValue = nil;
    if([value isEqualToString:@"NotDetermined"]){
        cnValue = @"Not Determined";
    }else if([value isEqualToString:@"Restricted"]){
        cnValue = @"Restricted";
    }else if([value isEqualToString:@"Denied"]){
        cnValue = @"Denied";
    }else if([value isEqualToString:@"Authorized"]){
        cnValue = @"Authorized";
    }else{
        cnValue = value;
    }
    
    self.valueLabel.text = cnValue;
    
    [self.titleLabel sizeToFit];
    [self.valueLabel sizeToFit];
    
    self.titleLabel.frame = CGRectMake(kDoraemonSizeFrom750_Landscape(32), 0, self.titleLabel.doraemon_width, [[self class] cellHeight]);
    self.valueLabel.frame = CGRectMake(DoraemonScreenWidth-kDoraemonSizeFrom750_Landscape(32)-self.valueLabel.doraemon_width, 0, self.valueLabel.doraemon_width, [[self class] cellHeight]);
}

+ (CGFloat)cellHeight{
    return kDoraemonSizeFrom750_Landscape(104);
}
@end
