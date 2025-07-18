//
//  DoraemonGPSViewController.m
//  DoraemonKit
//
//  Created by yixiang on 2017/12/20.
//

#import "DoraemonGPSViewController.h"
#import <MapKit/MapKit.h>
#import "UIImage+Doraemon.h"
#import "UIView+Doraemon.h"
#import "DoraemonDefine.h"
#import "DoraemonCacheManager.h"
#import "DoraemonToastUtil.h"
#import "DoraemonGPSMocker.h"
#import "DoraemonMockGPSOperateView.h"
#import "DoraemonMockGPSInputView.h"
#import "DoraemonMockGPSCenterView.h"

@interface DoraemonGPSViewController ()<MKMapViewDelegate,DoraemonMockGPSInputViewDelegate>
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) DoraemonMockGPSOperateView *operateView;
@property (nonatomic, strong) DoraemonMockGPSInputView *inputView;
@property (nonatomic, strong) DoraemonMockGPSCenterView *mapCenterView;
@end

@implementation DoraemonGPSViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Mock GPS";
    
    [self initUI];
}

- (void)initUI{
    _operateView = [[DoraemonMockGPSOperateView alloc] initWithFrame:CGRectMake(kDoraemonSizeFrom750_Landscape(6), IPHONE_NAVIGATIONBAR_HEIGHT, self.view.doraemon_width-2*kDoraemonSizeFrom750_Landscape(6), kDoraemonSizeFrom750_Landscape(124))];
    _operateView.switchView.on = [[DoraemonCacheManager sharedInstance] mockGPSSwitch];
    [self.view addSubview:_operateView];
    [_operateView.switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    _inputView = [[DoraemonMockGPSInputView alloc] initWithFrame:CGRectMake(kDoraemonSizeFrom750_Landscape(6), _operateView.doraemon_bottom+kDoraemonSizeFrom750_Landscape(17), self.view.doraemon_width-2*kDoraemonSizeFrom750_Landscape(6), kDoraemonSizeFrom750_Landscape(170))];
    _inputView.delegate = self;
    [self.view addSubview:_inputView];

    [self requestUserLocationAuthor];
    
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.doraemon_width, self.view.doraemon_height)];
    mapView.mapType = MKMapTypeStandard;
    mapView.delegate = self;
    [self.view addSubview:mapView];
    self.mapView = mapView;
    
    [self.view sendSubviewToBack:self.mapView];
    
    _mapCenterView = [[DoraemonMockGPSCenterView alloc] initWithFrame:CGRectMake(_mapView.doraemon_width/2-kDoraemonSizeFrom750_Landscape(250)/2, _mapView.doraemon_height/2-kDoraemonSizeFrom750_Landscape(250)/2, kDoraemonSizeFrom750_Landscape(250), kDoraemonSizeFrom750_Landscape(250))];
    [_mapView addSubview:_mapCenterView];

    if (_operateView.switchView.on) {
        CLLocationCoordinate2D coordinate = [[DoraemonCacheManager sharedInstance] mockCoordinate];
        [_mapCenterView hiddenGPSInfo:NO];
        [_mapCenterView renderUIWithGPS:[NSString stringWithFormat:@"%f , %f",coordinate.longitude,coordinate.latitude]];
        [self.mapView setCenterCoordinate:coordinate animated:NO];
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        [[DoraemonGPSMocker shareInstance] mockPoint:loc];
    }else{
        [_mapCenterView hiddenGPSInfo:YES];
        [[DoraemonGPSMocker shareInstance] stopMockPoint];
    }
}

- (void)switchAction:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    [[DoraemonCacheManager sharedInstance] saveMockGPSSwitch:isButtonOn];
    if (isButtonOn) {
        CLLocationCoordinate2D coordinate = [[DoraemonCacheManager sharedInstance] mockCoordinate];
        [_mapCenterView hiddenGPSInfo:NO];
        [_mapCenterView renderUIWithGPS:[NSString stringWithFormat:@"%f , %f",coordinate.longitude,coordinate.latitude]];
        [self.mapView setCenterCoordinate:coordinate animated:NO];
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        [[DoraemonGPSMocker shareInstance] mockPoint:loc];
    }else{
        [_mapCenterView hiddenGPSInfo:YES];
        [[DoraemonGPSMocker shareInstance] stopMockPoint];
    }
}

#pragma mark - DoraemonMockGPSInputViewDelegate
- (void)inputViewOkClick:(NSString *)gps{
    if (![[DoraemonCacheManager sharedInstance] mockGPSSwitch]) {
        [DoraemonToastUtil showToast:@"switch is not open" inView:self.view];
        return;
    }
    NSArray *array = [gps componentsSeparatedByString:@" "];
    if(array && array.count == 2){
        NSString *longitudeValue = array[0];
        NSString *latitudeValue = array[1];
        if (longitudeValue.length==0 || latitudeValue.length==0) {
            [DoraemonToastUtil showToast:@"Please enter longitude and latitude" inView:self.view];
            return;
        }
        
        CGFloat longitude = [longitudeValue floatValue];
        CGFloat latitude = [latitudeValue floatValue];
        if (longitude < -180 || longitude > 180) {
            [DoraemonToastUtil showToast:@"Invalid longitude" inView:self.view];
            return;
        }
        if (latitude < -90 || latitude > 90){
            [DoraemonToastUtil showToast:@"Invalid latitude" inView:self.view];
            return;
        }
        
        CLLocationCoordinate2D coordinate;
        coordinate.longitude = longitude;
        coordinate.latitude = latitude;

        [_mapCenterView hiddenGPSInfo:NO];
        [_mapCenterView renderUIWithGPS: [NSString stringWithFormat:@"%f , %f",coordinate.longitude,coordinate.latitude]];
        [self.mapView setCenterCoordinate:coordinate animated:NO];
        
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        [[DoraemonGPSMocker shareInstance] mockPoint:loc];
    }else{
        [DoraemonToastUtil showToast:@"Invalid format" inView:self.view];
        return;
    }
    
}

- (void)requestUserLocationAuthor{
    self.locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled]) {
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    
    if (![[DoraemonCacheManager sharedInstance] mockGPSSwitch]) {
        return;
    }
    [[DoraemonCacheManager sharedInstance] saveMockCoordinate:centerCoordinate];
    [_mapCenterView hiddenGPSInfo:NO];
    [_mapCenterView renderUIWithGPS:[NSString stringWithFormat:@"%f , %f",centerCoordinate.longitude,centerCoordinate.latitude]];
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:centerCoordinate.latitude longitude:centerCoordinate.longitude];
    [[DoraemonGPSMocker shareInstance] mockPoint:loc];
}
@end
