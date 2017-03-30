//
//  UIBezierPath+MXRoutePath.h
//  route
//
//  Created by 谢鹏翔 on 2017/3/30.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (MXRoutePath)

+ (UIBezierPath *)mx_checkerboardPath:(CGSize)size row:(NSInteger)row col:(NSInteger)col;

@end
