//
//  UIBezierPath+MXRoutePath.m
//  route
//
//  Created by 谢鹏翔 on 2017/3/30.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import "UIBezierPath+MXRoutePath.h"

@implementation UIBezierPath (MXRoutePath)

+ (UIBezierPath *)mx_checkerboardPath:(CGSize)size row:(NSInteger)row col:(NSInteger)col
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (int i = 0; i <= row; i++) {
        [path moveToPoint:CGPointMake(0, i * size.height / row)];
        [path addLineToPoint:CGPointMake(size.width, i * size.height / row)];
    }
    
    for (int j = 0; j <= col; j++) {
        [path moveToPoint:CGPointMake(j * size.width / col, 0)];
        [path addLineToPoint:CGPointMake(j * size.width / col, size.height)];
    }
    
    return path;
}

@end
