//
//  QBRouterUtils.h
//  QBRouterDemo
//
//  Created by 覃斌 卢    on 2019/9/22.
//  Copyright © 2019 覃斌 卢   . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 路由辅助工具 */
@interface QBRouterUtils : NSObject

#pragma mark - 线程

/**
 在主线层执行
 @param block 代码块
 */
+ (void)perfromInMainQuene:(dispatch_block_t)block;

/**
 在主线层执行
 @param block 代码块
 @param seconds 延时时间
 */
+ (void)perfromInMainQuene:(dispatch_block_t)block delay:(int64_t)seconds;

/**
 在全局线程加载
 
 @param block 代码块
 */
+ (void)perfromInGlobalQueue:(dispatch_block_t)block;

#pragma mark - URL解析

/**
 从url中获取参数
 
 @param url url
 @return 参数
 */
+ (NSDictionary *)getParamsFromUrl:(NSString *)url;

/**
 从url中获取参数
 
 @param url url
 @param key 字段名
 @return 参数
 */
+ (NSString *)getParamsFromUrl:(NSString *)url key:(NSString *)key;

/**
 url添加参数
 
 @param url url
 @param params 参数
 @param isAllowSameParams 是否允许相同参数
 @return 最后的url
 */
+ (NSString *)url:(NSString *)url addParams:(NSDictionary *)params isAllowSameParams:(BOOL)isAllowSameParams;

/**
 url添加参数
 
 @param url url
 @param value 参数值
 @param key 参数名称
 @param isAllowSameParams 是否允许相同参数
 @return 最后的url
 */
+ (NSString *)url:(NSString *)url addCompnentForValue:(NSString *)value key:(NSString *)key isAllowSameParams:(BOOL)isAllowSameParams;

/**
 url添加参数
 
 @param url url
 @param value 参数值
 @param key 参数名称
 @return 最后的url
 */
+ (NSString *)url:(NSString *)url addCompnentForValue:(NSString *)value key:(NSString *)key;

#pragma mark - 顶层控制器

/**
 获取当前控制器
 
 @return 当前控制器
 */
+ (UIViewController *)topViewController;

@end

NS_ASSUME_NONNULL_END
