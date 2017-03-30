//
//  MXPoint.m
//  route
//
//  Created by 谢鹏翔 on 2017/3/30.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "MXPoint.h"

@implementation MXPoint

+ (NSArray *)allPointsWithRow:(NSInteger)row col:(NSInteger)col
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < row; i++) {
        for (int j = 0; j < col; j++) {
            MXPoint *point = [[MXPoint alloc] init];
            point.x = i;
            point.y = j;
            point.isTrash = NO;
            point.isUsed = NO;
            [array addObject:point];
        }
    }
    return array.copy;
}

@end
