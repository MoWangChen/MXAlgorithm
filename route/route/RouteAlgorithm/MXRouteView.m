//
//  MXRouteView.m
//  route
//
//  Created by 谢鹏翔 on 2017/3/30.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "MXRouteView.h"
#import "MXPoint.h"
#import "UIBezierPath+MXRoutePath.h"

static NSInteger const kDefaultRow = 5;
static NSInteger const kDefaultCol = 5;

@interface MXRouteView ()

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger col;
@property (nonatomic, strong) NSMutableArray *AllPointArray;
@property (nonatomic, strong) NSMutableArray *trashArray;
@property (nonatomic, strong) NSArray *routeArray;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end

@implementation MXRouteView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _row = kDefaultRow;
        _col = kDefaultCol;
        [self loadAllPointArray];
        [self loadTrashArray];
        [self loadTap];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath mx_checkerboardPath:self.frame.size row:_row col:_col];
    path.lineWidth = 1;
    [path stroke];
    
    for (MXPoint *point in _trashArray) {
        CGRect rect = (CGRect){point.y * self.frame.size.width / _col + 1, point.x * self.frame.size.height / _row + 1, self.frame.size.width / _col - 2, self.frame.size.height / _row - 2};
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
        [[UIColor redColor] setFill];
        [path fill];
    }
    
    if (!_routeArray) {
        return;
    }
    
    MXPoint *beginPoint = _routeArray.firstObject;
    UIBezierPath *routePath = [UIBezierPath bezierPath];
    routePath.lineWidth = 3.f;
    for (MXPoint *point in _routeArray) {
        CGFloat x = (point.y * 2 + 1) * (self.frame.size.width / _col / 2);
        CGFloat y = (point.x * 2 + 1) * (self.frame.size.height / _row / 2);
        if (point == beginPoint) {
            [routePath moveToPoint:CGPointMake(x, y)];
            
            UIBezierPath *beginCircle = [UIBezierPath bezierPathWithOvalInRect:(CGRect){x - 15, y - 15, 30 , 30}];
            [[UIColor purpleColor] setFill];
            [beginCircle fill];
            
        }else {
            [routePath addLineToPoint:CGPointMake(x, y)];
        }
    }
    [[UIColor purpleColor] setStroke];
    [routePath stroke];
}

#pragma mark - click method
- (void)clickCheckerboard:(UITapGestureRecognizer *)recognizer
{
    CGPoint touchPoint = [recognizer locationInView:self];
    NSInteger rowIndex = (NSInteger)(touchPoint.y / self.frame.size.height * _row);
    NSInteger colIndex = (NSInteger)(touchPoint.x / self.frame.size.width * _col);
    NSInteger index = rowIndex * _col + colIndex;
    MXPoint *point = _AllPointArray[index];
    point.isTrash = YES;
    [self.trashArray addObject:point];
    [self setNeedsDisplay];
}

- (void)clearRouteView
{
    _routeArray = nil;
    for (MXPoint *point in _trashArray) {
        point.isTrash = NO;
    }
    [self.trashArray removeAllObjects];
    [self setNeedsDisplay];
}

- (void)calculateRoute
{
    _routeArray = [MXPoint calculateRoute:self.AllPointArray];
    [self setNeedsDisplay];
}

#pragma mark - lazy load

- (void)loadAllPointArray
{
    if (!_AllPointArray) {
        _AllPointArray = [NSMutableArray arrayWithArray: [MXPoint allPointsWithRow:_row col:_col]];
    }
}

- (void)loadTrashArray
{
    if (!_trashArray) {
        _trashArray = [NSMutableArray array];
    }
}

- (void)loadTap
{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCheckerboard:)];
        [self addGestureRecognizer:_tap];
    }
}

@end
