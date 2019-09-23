//
//  QBRouterInfo.m
//  QBRouterDemo
//
//  Created by 覃斌 卢    on 2019/9/22.
//  Copyright © 2019 覃斌 卢   . All rights reserved.
//

#import "QBRouterInfo.h"

@implementation QBRouterInfo

#pragma mark - init

- (instancetype)init {
    self = [super init];
    if (self) {
        self.animation = YES;
        self.isPreprocese = NO;
    }
    return self;
}

#pragma mark - Public Methods

/**
 创建RouterInfo模型
 
 @param url url
 @return RouterInfo
 */
+ (QBRouterInfo *)routerInfoWithUrl:(NSString *)url
{
    QBRouterInfo *routerInfo = [[QBRouterInfo alloc]init];
    routerInfo.url = url;
    return routerInfo;
}

/**
 创建RouterInfo模型
 
 @param url url
 @param params params
 @return RouterInfo模型
 */
+ (QBRouterInfo *)routerInfoWithUrl:(NSString *)url params:(NSDictionary *)params
{
    QBRouterInfo *routerInfo = [[QBRouterInfo alloc]init];
    routerInfo.url = url;
    routerInfo.params = params;
    return routerInfo;
}

/**
 创建RouterInfo模型
 
 @param url url
 @param animation 是否有动画
 @return RouterInfo模型
 */
+ (QBRouterInfo *)routerInfoWithUrl:(NSString *)url animation:(BOOL)animation
{
    QBRouterInfo *routerInfo = [[QBRouterInfo alloc]init];
    routerInfo.url = url;
    routerInfo.animation = animation;
    return routerInfo;
}

/**
 创建RouterInfo模型
 
 @param url url
 @param params params
 @param animation 是否有动画
 @return RouterInfo模型
 */
+ (QBRouterInfo *)routerInfoWithUrl:(NSString *)url params:(NSDictionary *)params animation:(BOOL)animation
{
    QBRouterInfo *routerInfo = [[QBRouterInfo alloc]init];
    routerInfo.url = url;
    routerInfo.animation = animation;
    routerInfo.params = params;
    return routerInfo;
}

#pragma mark - getters

- (NSDictionary *)params
{
    if (!_params) {
        _params = [NSDictionary dictionary];
    }
    return _params;
}


@end
