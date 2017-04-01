//
//  MXPoint.h
//  route
//
//  Created by 谢鹏翔 on 2017/3/30.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, MXRunDirection) {
    MXRunDirectionNone      = 0,
    MXRunDirectionTop       = 1 << 0,
    MXRunDirectionLeft      = 1 << 1,
    MXRunDirectionBottom    = 1 << 2,
    MXRunDirectionRight     = 1 << 3,
};

@interface MXPoint : NSObject

@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;
@property (nonatomic, assign) NSInteger maxX;
@property (nonatomic, assign) NSInteger maxY;
@property (nonatomic, assign) BOOL isTrash;
@property (nonatomic, assign) BOOL isUsed;

@property (nonatomic, assign) MXRunDirection direction;

@end

@interface MXPoint (Factory)

+ (NSArray *)allPointsWithRow:(NSInteger)row col:(NSInteger)col;
+ (NSArray *)calculateRoute:(NSArray <MXPoint *>*)pointArray;

@end
