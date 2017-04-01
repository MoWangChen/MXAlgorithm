//
//  ViewController.m
//  route
//
//  Created by 谢鹏翔 on 2017/3/30.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "ViewController.h"
#import "MXRouteView.h"

@interface ViewController ()

@property (nonatomic, strong) MXRouteView *routeView;
@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) UIButton *calculateButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadRouteView];
    [self loadClearButton];
    [self loadCalculateButton];
}

#pragma mark - click method
- (void)clickClearView
{
    [_routeView clearRouteView];
}

- (void)clickCalculateRoute
{
    [_routeView calculateRoute];
}

#pragma mark - lazy load
- (void)loadRouteView
{
    if (!_routeView) {
        _routeView = [[MXRouteView alloc] initWithFrame:CGRectMake(15, 30, kScreenWidth - 30, kScreenWidth - 30)];
        _routeView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_routeView];
    }
}

- (void)loadClearButton
{
    if (!_clearButton) {
        _clearButton = [[UIButton alloc] init];
        _clearButton.frame = CGRectMake(0, 0, 60, 30);
        _clearButton.layer.masksToBounds = YES;
        _clearButton.layer.cornerRadius = 5.f;
        _clearButton.backgroundColor = [UIColor blackColor];
        [_clearButton setTitle:@"重置" forState:UIControlStateNormal];
        [_clearButton addTarget:self action:@selector(clickClearView) forControlEvents:UIControlEventTouchUpInside];
        _clearButton.center = CGPointMake(kScreenWidth / 2, kScreenWidth + 40);
        [self.view addSubview:_clearButton];
    }
}

- (void)loadCalculateButton
{
    if (!_calculateButton) {
        _calculateButton = [[UIButton alloc] init];
        _calculateButton.frame = CGRectMake(0, 0, 100, 30);
        _calculateButton.layer.masksToBounds = YES;
        _calculateButton.layer.cornerRadius = 5.f;
        _calculateButton.backgroundColor = [UIColor blackColor];
        [_calculateButton setTitle:@"计算路线" forState:UIControlStateNormal];
        [_calculateButton addTarget:self action:@selector(clickCalculateRoute) forControlEvents:UIControlEventTouchUpInside];
        _calculateButton.center = CGPointMake(kScreenWidth / 2, kScreenWidth + 80);
        [self.view addSubview:_calculateButton];
    }
}

@end
