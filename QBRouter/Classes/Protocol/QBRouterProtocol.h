//
//  QBRouterProtocol.h
//  QBRouterDemo
//
//  Created by 覃斌 卢    on 2019/9/22.
//  Copyright © 2019 覃斌 卢   . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class QBRouterInfo;

/** 路由协议 */
@protocol QBRouterProtocol <NSObject>

@required

/**
 路由事件处理
 
 @param routerInfo 路由信息
 */
+ (void)handleRouterEventWithRouterInfo:(QBRouterInfo * _Nullable)routerInfo;

@optional

/**
 单路径 用这个方法返回
 
 @return 路由url
 */
+ (NSString *)routerPath;

/**
 多路径 这个方法返回
 
 @return 路由url集合
 */
+ (NSArray<NSString *> *)multiRouterPath;

/**
 是否预处理
 
 @return 是否预处理
 */
+ (BOOL)isPreprocese;

@end

NS_ASSUME_NONNULL_END
