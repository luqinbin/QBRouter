//
//  QBRouter.h
//  QBRouterDemo
//
//  Created by 覃斌 卢    on 2019/9/22.
//  Copyright © 2019 覃斌 卢   . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QBRouterInfo.h"
#import "QBRouterDefine.h"
#import "QBRouterProtocol.h"
#import "QBRouterExtentionProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**  路由 */
@interface QBRouter : NSObject


/**
 初始化路由SDK 非必须调用
 */
+ (void)initRouterSDK;

#pragma mark - 路由注册

/**
 注册路由扩展解析类
 @param routerExtentionClass 路由扩展协议类
 @return 是否注册成功
 */
+ (BOOL)registerRouterExtentionClass:(Class <QBRouterExtentionProtocol> )routerExtentionClass;

#pragma mark - 路由方法

/**
 是否可以打开URL
 
 @param url url
 @return 是否可以打开URL
 */
+ (BOOL)canOpenURL:(NSString * _Nullable)url;

/**
 打开URL
 
 @param url url
 */
+ (void)openURL:(NSString * _Nullable)url;

/**
 打开url
 
 @param url url
 @param completionHandler 完成回调
 */
+ (void)openURL:(NSString * _Nullable )url completionHandler:(QBRouterCompletionCallback _Nullable)completionHandler;

/**
 打开url
 
 @param url url
 @param params 参数
 */
+ (void)openURL:(NSString * _Nullable)url params:(NSDictionary * _Nullable)params;

/**
 打开url
 
 @param url url
 @param params 参数
 @param completionHandler 完成回调
 */
+ (void)openURL:(NSString * _Nullable)url params:(NSDictionary * _Nullable)params completionHandler:(QBRouterCompletionCallback _Nullable)completionHandler;

/**
 根据路由信息打开url
 
 @param routerInfo 路由信息
 */
+ (void)openURLWithRouterInfo:(QBRouterInfo * _Nullable)routerInfo;

/**
 根据路由信息打开url
 
 @param routerInfo 路由信息
 @param completionHandler 完成回调
 */
+ (void)openURLWithRouterInfo:(QBRouterInfo * _Nullable)routerInfo  completionHandler:(QBRouterCompletionCallback _Nullable)completionHandler;

#pragma mark - 打开路由页面

/**
 打开控制器
 @param viewController 控制器
 @param transtionType  跳转方式
 @param animation      动画
 @param completionHandler 跳转结果
 */
+ (void)openViewController:(UIViewController *)viewController transtionType:(QBRouterTranstionType)transtionType animation:(BOOL)animation completionHandler:(QBRouterCompletionCallback _Nullable)completionHandler;

/**
 打开外链URL
 
 @param url url
 @param completionHandler 跳转结果
 */
+ (void)applicationOpenURLWithURL:(NSString * _Nullable)url completionHandler:(QBRouterCompletionCallback _Nullable)completionHandler;

/**
 是否可以打开外链
 
 @param url url
 @return 是否可以打开
 */
+ (BOOL)applicationCanOpenURL:(NSString * _Nullable)url;

@end

NS_ASSUME_NONNULL_END
