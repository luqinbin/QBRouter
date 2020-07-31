//
//  QBRouterInfo.h
//  QBRouterDemo
//
//  Created by 覃斌 卢    on 2019/9/22.
//  Copyright © 2019 覃斌 卢   . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QBRouterAnimatedTransition.h"
#import "QBRouterDefine.h"

NS_ASSUME_NONNULL_BEGIN

/** 路由信息 */
@interface QBRouterInfo : NSObject

/** url */
@property (strong, nonatomic) NSString *url;

/** 参数 */
@property (strong, nonatomic) NSDictionary *params;

/** 扩展 */
@property (strong, nonatomic) id  object;

/** 是否预处理 */
@property (assign, nonatomic) BOOL isPreprocese;

@property (assign, nonatomic) QBRouterTranstionType transtionType;

@property (strong, nonatomic) QBRouterAnimatedTransition *animatedTransition;

/** 是否有动画  默认YES */
@property (assign, nonatomic) BOOL animation;

/** 回调函数 */
@property (copy, nonatomic) QBRouterCompletionCallback completionHandler;

/**
 创建RouterInfo模型
 
 @param url url
 @return RouterInfo模型
 */
+ (QBRouterInfo *)routerInfoWithUrl:(NSString *)url;

/**
 创建RouterInfo模型
 
 @param url url
 @param params params
 @return RouterInfo模型
 */
+ (QBRouterInfo *)routerInfoWithUrl:(NSString *)url params:(NSDictionary *)params;

/**
 创建RouterInfo模型
 
 @param url url
 @param animation 是否有动画
 @return RouterInfo模型
 */
+ (QBRouterInfo *)routerInfoWithUrl:(NSString *)url animation:(BOOL)animation;

/**
 创建RouterInfo模型
 
 @param url url
 @param params params
 @param animation 是否有动画
 @return RouterInfo模型
 */
+ (QBRouterInfo *)routerInfoWithUrl:(NSString *)url params:(NSDictionary *)params animation:(BOOL)animation;

@end

NS_ASSUME_NONNULL_END
