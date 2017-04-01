//
//  MXRouteView.h
//  route
//
//  Created by 谢鹏翔 on 2017/3/30.
//  Copyright © 2017年 365ime. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

@interface MXRouteView : UIView

- (void)clearRouteView;
- (void)calculateRoute;

@end
