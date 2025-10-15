//
//  DoraemonVisualInfoWindow.m
//  DoraemonKit
//
//  Created by wenquan on 2018/12/5.
//

#import "DoraemonVisualInfoWindow.h"
#import "DoraemonDefine.h"

@interface DoraemonVisualInfoViewController : UIViewController
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel *infoLabel;
@end

@implementation DoraemonVisualInfoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {
    self.view.backgroundColor = [UIColor systemBackgroundColor];

    dispatch_async(dispatch_get_main_queue(), ^{
        CGSize viewSize = self.view.window.bounds.size;

        CGFloat closeWidth = kDoraemonSizeFromLandscape(44);
        CGFloat closeHeight = kDoraemonSizeFromLandscape(44);
        self.closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(viewSize.width - closeWidth - kDoraemonSizeFromLandscape(16), kDoraemonSizeFromLandscape(16), closeWidth, closeHeight)];

        UIImage *closeImage = [UIImage systemImageNamed:@"xmark"];

        [self.closeBtn setBackgroundImage:closeImage forState:UIControlStateNormal];
        [self.closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.closeBtn];

        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDoraemonSizeFromLandscape(32), 0, viewSize.width - kDoraemonSizeFromLandscape(32 + 16) - closeWidth, viewSize.height)];
        self.infoLabel.backgroundColor = [UIColor clearColor];
        self.infoLabel.textColor = [UIColor labelColor];
        self.infoLabel.font = [UIFont systemFontOfSize:kDoraemonSizeFromLandscape(24)];
        self.infoLabel.numberOfLines = 0;
        [self.view addSubview:self.infoLabel];

        [(id)self.view.window setInfoLabel:self.infoLabel];
    });
}

#pragma mark - Actions
- (void)closeBtnClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:DoraemonClosePluginNotification object:nil userInfo:nil];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.view.window.frame = CGRectMake(kDoraemonSizeFromLandscape(30), DoraemonWindowHeight - self.infoLabel.frame.size.height - kDoraemonSizeFromLandscape(30), size.height, size.width);
    });
}
@end

@interface DoraemonVisualInfoWindow ()
@property (nonatomic, weak) UILabel *infoLabel;
@end

@implementation DoraemonVisualInfoWindow
#pragma mark - set

- (void)setInfoText:(NSString *)infoText {
    _infoText = infoText;
    _infoLabel.text = infoText;
}
- (void)setInfoAttributedText:(NSAttributedString *)infoAttributedText {
    _infoAttributedText = infoAttributedText;
    _infoLabel.attributedText = infoAttributedText;
}

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    for (UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes) {
        if (windowScene.activationState == UISceneActivationStateForegroundActive) {
            self.windowScene = windowScene;
            break;
        }
    }

    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = kDoraemonSizeFromLandscape(8);
    self.layer.borderWidth = 1.;
    self.layer.borderColor = [UIColor doraemon_colorWithHex:0x999999 andAlpha:0.2].CGColor;
    self.windowLevel = UIWindowLevelAlert;
    self.rootViewController = [[DoraemonVisualInfoViewController alloc] init];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
}

#pragma mark - Actions

- (void)pan:(UIPanGestureRecognizer *)sender {
    UIView *panView = sender.view;

    if (!panView.hidden) {
        CGPoint offsetPoint = [sender translationInView:sender.view];
        [sender setTranslation:CGPointZero inView:sender.view];
        CGFloat newX = panView.doraemon_centerX + offsetPoint.x;
        CGFloat newY = panView.doraemon_centerY + offsetPoint.y;

        CGPoint centerPoint = CGPointMake(newX, newY);
        panView.center = centerPoint;
    }
}
@end
