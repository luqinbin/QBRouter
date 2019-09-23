//
//  QBRouterExtentionProtocol.h
//  QBRouterDemo
//
//  Created by 覃斌 卢    on 2019/9/22.
//  Copyright © 2019 覃斌 卢   . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QBRouterDefine.h"

NS_ASSUME_NONNULL_BEGIN

/** 路由扩展协议 */
@protocol QBRouterExtentionProtocol <NSObject>

@optional

/**
 未识别路由事件处理
 
 @param routerInfo 路由信息
 */
+ (void)handleUnRecognizeRouterEventWithRouterInfo:(QBRouterInfo * _Nullable)routerInfo;

/**
 是否可以打开未识别路由事件
 
 @param url url
 @return 是否可以打开
 */
+ (BOOL)isCanOpenUnRecognizeRouterEventWithUrl:(NSString * _Nullable)url;

/**
 路由事件预处理
 
 @param routerInfo 路由信息
 @param completionHandler 预处理结束回调
 */
+ (void)preproceseRouterEventWithRouterInfo:(QBRouterInfo * _Nullable)routerInfo completionHandler:(QBRouterCompletionCallback)completionHandler;

@end

NS_ASSUME_NONNULL_END
