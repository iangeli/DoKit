//
//  DoraemonColorPickInfoWindow.m
//  DoraemonKit
//
//  Created by wenquan on 2018/12/4.
//

#import "DoraemonColorPickInfoWindow.h"
#import "DoraemonColorPickInfoView.h"
#import "DoraemonDefine.h"

@interface DoraemonColorPickInfoController: UIViewController
@end

@implementation DoraemonColorPickInfoController
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.view.window.frame = CGRectMake(kDoraemonSizeFrom750_Landscape(30), DoraemonScreenHeight - (size.height < size.width ? size.height : size.width) - kDoraemonSizeFrom750_Landscape(30), size.height, size.width);
    });
}
@end

@interface DoraemonColorPickInfoWindow () <DoraemonColorPickInfoViewDelegate>
@property (nonatomic, strong) DoraemonColorPickInfoView *pickInfoView;
@end

@implementation DoraemonColorPickInfoWindow
#pragma mark - Lifecycle

+ (DoraemonColorPickInfoWindow *)shareInstance{
    static dispatch_once_t once;
    static DoraemonColorPickInfoWindow *instance;
    dispatch_once(&once, ^{
        instance = [[DoraemonColorPickInfoWindow alloc] init];
    });
    return instance;
}

- (instancetype)init {
    
    if (self.orientationIsLandscape) {
        self = [super initWithFrame:CGRectMake(kDoraemonSizeFrom750_Landscape(30), DoraemonScreenHeight - kDoraemonSizeFrom750_Landscape(100) - kDoraemonSizeFrom750_Landscape(30) - IPHONE_SAFEBOTTOMAREA_HEIGHT, DoraemonScreenHeight - 2*kDoraemonSizeFrom750_Landscape(30), kDoraemonSizeFrom750_Landscape(100))];
    } else {
        self = [super initWithFrame:CGRectMake(kDoraemonSizeFrom750_Landscape(30), DoraemonScreenHeight - kDoraemonSizeFrom750_Landscape(100) - kDoraemonSizeFrom750_Landscape(30) - IPHONE_SAFEBOTTOMAREA_HEIGHT, DoraemonScreenWidth - 2*kDoraemonSizeFrom750_Landscape(30), kDoraemonSizeFrom750_Landscape(100))];
    }
    
    if (self) {
                for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes){
                    if (windowScene.activationState == UISceneActivationStateForegroundActive){
                        self.windowScene = windowScene;
                        break;
                    }
                }
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelAlert;
        if (!self.rootViewController) {
            self.rootViewController = [[DoraemonColorPickInfoController alloc] init];
        }
        
        DoraemonColorPickInfoView *pickInfoView = [[DoraemonColorPickInfoView alloc] initWithFrame:self.bounds];
        pickInfoView.delegate = self;
        [self.rootViewController.view addSubview:pickInfoView];
        self.pickInfoView = pickInfoView;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closePlugin:) name:DoraemonClosePluginNotification object:nil];
    }
    return self;
}

#pragma mark - Public

- (void)show{
    self.hidden = NO;
}

- (void)hide{
    self.hidden = YES;
}

- (void)setCurrentColor:(NSString *)hexColor {
    [self.pickInfoView setCurrentColor:hexColor];
}

#pragma mark - Actions

- (void)pan:(UIPanGestureRecognizer *)sender{
    CGPoint offsetPoint = [sender translationInView:sender.view];
    [sender setTranslation:CGPointZero inView:sender.view];
    UIView *panView = sender.view;
    CGFloat newX = panView.doraemon_centerX+offsetPoint.x;
    CGFloat newY = panView.doraemon_centerY+offsetPoint.y;
   
    CGPoint centerPoint = CGPointMake(newX, newY);
    panView.center = centerPoint;
}
 
#pragma mark DoraemonColorPickInfoViewDelegate

- (void)closeBtnClicked:(id)sender onColorPickInfoView:(DoraemonColorPickInfoView *)colorPickInfoView {
    [[NSNotificationCenter defaultCenter] postNotificationName:DoraemonClosePluginNotification object:nil userInfo:nil];
}

#pragma mark - Notification

- (void)closePlugin:(NSNotification *)notification{
    [self hide];
}
@end
