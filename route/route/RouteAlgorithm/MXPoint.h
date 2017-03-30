//
//  MXPoint.h
//  route
//
//  Created by 谢鹏翔 on 2017/3/30.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXPoint : NSObject

@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;
@property (nonatomic, assign) BOOL isTrash;
@property (nonatomic, assign) BOOL isUsed;

+ (NSArray *)allPointsWithRow:(NSInteger)row col:(NSInteger)col;

@end
