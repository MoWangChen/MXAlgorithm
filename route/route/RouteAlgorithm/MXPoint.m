//
//  MXPoint.m
//  route
//
//  Created by 谢鹏翔 on 2017/3/30.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "MXPoint.h"

@implementation MXPoint

- (NSString *)description
{
    return [NSString stringWithFormat:@"(%ld, %ld) N:%ld",self.x, self.y, self.direction];
}

- (BOOL)isUsed
{
    if (self.isTrash) {
        return YES;
    }
    return _isUsed;
}

- (void)resetStatus
{
    _direction = MXRunDirectionNone;
    _isUsed = NO;
}

- (BOOL)canGoTop
{
    return self.x - 1 >= 0 ? YES : NO;
}

- (BOOL)canGoTopInArray:(NSArray *)array
{
    if (![self canGoTop]) {
        return NO;
    }
    
    MXPoint *point = [self topPointInArray:array];
    return !point.isUsed;
}

- (MXPoint *)topPointInArray:(NSArray *)array
{
    NSInteger rowIndex = self.x - 1;
    NSInteger index = rowIndex * (self.maxY + 1) + self.y;
    return [array objectAtIndex:index];
}

- (BOOL)canGoLeft
{
    return self.y - 1 >= 0 ? YES : NO;
}

- (BOOL)canGoLeftInArray:(NSArray *)array
{
    if (![self canGoLeft]) {
        return NO;
    }
    
    MXPoint *point = [self leftPointInArray:array];
    return !point.isUsed;
}

- (MXPoint *)leftPointInArray:(NSArray *)array
{
    NSInteger colIndex = self.y - 1;
    NSInteger index = self.x * (self.maxY + 1) + colIndex;
    return [array objectAtIndex:index];
}

- (BOOL)canGoBottom
{
    return self.x + 1 <= self.maxX ? YES : NO;
}

- (BOOL)canGoBottomInArray:(NSArray *)array
{
    if (![self canGoBottom]) {
        return NO;
    }
    
    MXPoint *point = [self bottomPointInArray:array];
    return !point.isUsed;
}

- (MXPoint *)bottomPointInArray:(NSArray *)array
{
    NSInteger rowIndex = self.x + 1;
    NSInteger index = rowIndex * (self.maxY + 1) + self.y;
    return [array objectAtIndex:index];
}

- (BOOL)canGoRight
{
    return self.y + 1 <= self.maxY ? YES : NO;
}

- (BOOL)canGoRightInArray:(NSArray *)array
{
    if (![self canGoRight]) {
        return NO;
    }
    
    MXPoint *point = [self rightPointInArray:array];
    return !point.isUsed;
}

- (MXPoint *)rightPointInArray:(NSArray *)array
{
    NSInteger colIndex = self.y + 1;
    NSInteger index = self.x * (self.maxY + 1) + colIndex;
    return [array objectAtIndex:index];
}

- (MXRunDirection)backDirectionTo:(MXPoint *)point
{
    NSAssert((self.x == point.x) || (self.y == point.y), @"不相邻");
    NSAssert((labs(self.x - point.x) == 1) || ((labs(self.y - point.y) == 1)), @"不相邻");
    if (self.x == point.x) {
        return self.y > point.y ? MXRunDirectionRight : MXRunDirectionLeft;
    }else if (self.y == point.y) {
        return self.x > point.x ? MXRunDirectionBottom : MXRunDirectionTop;
    }
    return MXRunDirectionNone;
}

- (NSMutableArray *)tempRouteArray
{
    __weak NSMutableArray *array = [[self class] tempRouteArray];
    return array;
}

+ (NSMutableArray *)tempRouteArray
{
    static NSMutableArray *array = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        array = [NSMutableArray array];
    });
    return array;
}

- (NSMutableArray *)realRouteArray
{
    __weak NSMutableArray *array = [[self class] realRouteArray];
    return array;
}

+ (NSMutableArray *)realRouteArray
{
    static NSMutableArray *array = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        array = [NSMutableArray array];
    });
    return array;
}

@end

@implementation MXPoint (Factory)

+ (NSArray *)allPointsWithRow:(NSInteger)row col:(NSInteger)col
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < row; i++) {
        for (int j = 0; j < col; j++) {
            MXPoint *point = [[MXPoint alloc] init];
            point.x = i;
            point.y = j;
            point.maxX = row - 1;
            point.maxY = col - 1;
            point.isTrash = NO;
            point.isUsed = NO;
            [array addObject:point];
        }
    }
    return array.copy;
}

+ (void)clearAllPointsUserd:(NSArray <MXPoint *>*)pointArray
{
    for (MXPoint *point in pointArray) {
        [point resetStatus];
    }
}

+ (NSInteger)boxCount:(NSArray <MXPoint *>*)pointArray
{
    int i = 0;
    for (MXPoint *point in pointArray) {
        if (!point.isTrash) {
            i++;
        }
    }
    return i;
}

+ (NSArray *)calculateRoute:(NSArray <MXPoint *>*)pointArray
{
    [self clearAllPointsUserd:pointArray];
    MXPoint *startPoint = nil;
    for (MXPoint *point in pointArray) {
        if (point.isTrash) {
            continue;
        }else {
            startPoint = point;
        }

        [startPoint canRunInArray:pointArray];
    }
    if ([[self realRouteArray] count] > 0) {
        return [self realRouteArray];
    }else {
        return nil;
    }
}

- (void)canRunInArray:(NSArray <MXPoint *>*)pointArray
{
    int i = 0;
    while (i < 4) {
        NSLog(@"--------- (%ld, %ld)",self.x ,self.y);
        MXRunDirection direction = MXRunDirectionNone;
        if (i == 0) {
            
            direction = MXRunDirectionTop;
            
        }else if (i == 1) {
            
            direction = MXRunDirectionLeft;
        
        }else if (i == 2) {
            
            direction = MXRunDirectionBottom;
        
        }else if (i == 3) {
            
            direction = MXRunDirectionRight;
        }
        
        if (direction != MXRunDirectionNone) {
            
            [[self tempRouteArray] removeAllObjects];
            [[self realRouteArray] removeAllObjects];
            [[self class] clearAllPointsUserd:pointArray];
            [self canRunInArray:pointArray direction:direction];
        }
        
        i++;
        if (i == 4) {
            NSLog(@"无可行路线");
        }
    }
}

- (void)canRunInArray:(NSArray <MXPoint *>*)pointArray direction:(MXRunDirection)direction
{
    self.isUsed = YES;
    self.direction = self.direction | direction;
    [[self tempRouteArray] addObject:self];
    NSLog(@"%ld %ld",self.x, self.y);
    
    static BOOL isDirectionEnd = NO;
    
    if (direction == MXRunDirectionTop && [self canGoTopInArray:pointArray]) {
        
        isDirectionEnd = YES;
        [[self topPointInArray:pointArray] canRunInArray:pointArray direction:MXRunDirectionTop];
        
    }else if (direction == MXRunDirectionLeft && [self canGoLeftInArray:pointArray]) {
        
        isDirectionEnd = YES;
        [[self leftPointInArray:pointArray] canRunInArray:pointArray direction:MXRunDirectionLeft];
        
    }else if (direction == MXRunDirectionBottom && [self canGoBottomInArray:pointArray]) {
        
        isDirectionEnd = YES;
        [[self bottomPointInArray:pointArray] canRunInArray:pointArray direction:MXRunDirectionBottom];
        
    }else if (direction == MXRunDirectionRight && [self canGoRightInArray:pointArray]) {
        
        isDirectionEnd = YES;
        [[self rightPointInArray:pointArray] canRunInArray:pointArray direction:MXRunDirectionRight];
        
    }else if (isDirectionEnd == YES) {
        
        isDirectionEnd = NO;
        if ([self canGoTopInArray:pointArray]) {
            
            isDirectionEnd = YES;
            [[self topPointInArray:pointArray] canRunInArray:pointArray direction:MXRunDirectionTop];
            
        }else if ([self canGoLeftInArray:pointArray]) {
            
            isDirectionEnd = YES;
            [[self leftPointInArray:pointArray] canRunInArray:pointArray direction:MXRunDirectionLeft];
            
        }else if ([self canGoBottomInArray:pointArray]) {
            
            isDirectionEnd = YES;
            [[self bottomPointInArray:pointArray] canRunInArray:pointArray direction:MXRunDirectionBottom];
            
        }else if ([self canGoRightInArray:pointArray]) {
            
            isDirectionEnd = YES;
            [[self rightPointInArray:pointArray] canRunInArray:pointArray direction:MXRunDirectionRight];
        }else {
            if ([[self tempRouteArray] count] == [MXPoint boxCount:pointArray]) {
                NSLog(@"路径完成");
                [[self realRouteArray] removeAllObjects];
                [[self realRouteArray] addObjectsFromArray:[self tempRouteArray]];
            }else {
                NSLog(@"重新走");
                [self backSteps:pointArray];
            }
        }
    }else {
        NSLog(@"走不到这里");
    }
}

- (void)backSteps:(NSArray *)pointArray
{
    MXPoint *point = [self tempRouteArray].lastObject;
    MXPoint *backPoint = [self tempRouteArray][[[self tempRouteArray] count] - 2];
    MXRunDirection direction = [point backDirectionTo:backPoint];
    for (; 1;) {
        MXPoint *lastPoint = [self tempRouteArray].lastObject;
        if (lastPoint.direction & direction) {
            [lastPoint resetStatus];
            [[self tempRouteArray] removeLastObject];
        }else {
            break;
        }
    }
    NSLog(@"回退完成");
    if ([[self tempRouteArray] count] <= 0) {
        return;
    }
    MXPoint *lastPoint = [self tempRouteArray].lastObject;
    lastPoint.direction = lastPoint.direction | direction;
    [lastPoint reStartRun:pointArray];
}

- (void)reStartRun:(NSArray <MXPoint *>*)pointArray
{
    if (!(self.direction & MXRunDirectionTop)) {
        
        if ([self canGoTopInArray:pointArray]) {
            [[self topPointInArray:pointArray] canRunInArray:pointArray direction:MXRunDirectionTop];
        }else {
            self.direction = self.direction | MXRunDirectionTop;
            [self reStartRun:pointArray];
        }
        
    }else if (!(self.direction & MXRunDirectionLeft)){
        
        if ([self canGoLeftInArray:pointArray]) {
            [[self leftPointInArray:pointArray] canRunInArray:pointArray direction:MXRunDirectionLeft];
        }else {
            self.direction = self.direction | MXRunDirectionLeft;
            [self reStartRun:pointArray];
        }
        
    }else if (!(self.direction & MXRunDirectionBottom)) {
        
        if ([self canGoBottomInArray:pointArray]) {
            [[self bottomPointInArray:pointArray] canRunInArray:pointArray direction:MXRunDirectionBottom];
        }else {
            self.direction = self.direction | MXRunDirectionBottom;
            [self reStartRun:pointArray];
        }
        
    }else if (!(self.direction & MXRunDirectionRight)) {
        
        if ([self canGoRightInArray:pointArray]) {
            [[self rightPointInArray:pointArray] canRunInArray:pointArray direction:MXRunDirectionRight];
        }else {
            self.direction = self.direction | MXRunDirectionRight;
            [self reStartRun:pointArray];
        }
    }else {
        if ([[self tempRouteArray] count] <= 1) {
            return;
        }else {
            [self backSteps:pointArray];
        }
    }
}

+ (void)stash
{
//    if ([self canGoTopInArray:pointArray]) {
//        
//        [[self topPointInArray:pointArray] canRunInArray:pointArray direction:MXRunDirectionTop];
//        
//    }else if ([self canGoLeftInArray:pointArray]) {
//        
//        [[self leftPointInArray:pointArray] canRunInArray:pointArray direction:MXRunDirectionLeft];
//        
//    }else if ([self canGoBottomInArray:pointArray]) {
//        
//        [[self bottomPointInArray:pointArray] canRunInArray:pointArray direction:MXRunDirectionBottom];
//        
//    }else if ([self canGoRightInArray:pointArray]) {
//        
//        [[self rightPointInArray:pointArray] canRunInArray:pointArray direction:MXRunDirectionRight];
//    }
    
    
    
    
}

@end
