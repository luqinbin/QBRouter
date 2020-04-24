//
//  QBRouterUtils.m
//  QBRouterDemo
//
//  Created by 覃斌 卢    on 2019/9/22.
//  Copyright © 2019 覃斌 卢   . All rights reserved.
//

#import "QBRouterUtils.h"

@implementation QBRouterUtils

#pragma mark - 线程
/**
 在主线层执行
 @param block 代码块
 */
+ (void)perfromInMainQuene:(dispatch_block_t)block
{
    if ([NSThread isMainThread]) {
        if (block)
            block();
    } else {
        if (block) {
            dispatch_async(dispatch_get_main_queue(), block);
        }
    }
}

+ (void)perfromInMainQuene:(dispatch_block_t)block delay:(int64_t)seconds
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

/**
 在全局线程加载
 
 @param block 代码块
 */
+ (void)perfromInGlobalQueue:(dispatch_block_t)block
{
    if (block) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
    }
}

#pragma mark - URL解析

/**
 从url中获取参数
 
 @param url url
 @return 参数
 */
+ (NSDictionary *)getParamsFromUrl:(NSString *)url
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (!url || ![url isKindOfClass:[NSString class]]) {
        return params;
    }
    NSArray *urlArray = [url componentsSeparatedByString:@"#"];
    NSString *realUrl = [urlArray firstObject];
    NSRange range = [realUrl rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return params;
    }
    NSString *parametersString = [realUrl substringFromIndex:range.location + 1];
    if ([parametersString containsString:@"&"]) {
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        for (NSString *keyValuePair in urlComponents) {
            //生成key/value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key ;
            NSString *value ;
            if (pairComponents.count == 2) {
                key = [pairComponents.firstObject stringByRemovingPercentEncoding];
                value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            } else if (pairComponents.count > 2) {
                NSString *valueString=@"";
                for (NSInteger i = 1, count = pairComponents.count; i < count; i++) {
                    if (i == 1) {
                        valueString = [NSString stringWithFormat:@"%@%@",valueString,pairComponents[i]];
                    } else {
                        valueString = [NSString stringWithFormat:@"%@=%@",valueString,pairComponents[i]];
                    }
                }
                value = [valueString stringByRemovingPercentEncoding];
            }
            // key不能为nil
            if (key == nil|| value == nil) {
                continue;
            }
            id existValue = [params valueForKey:key];
            if (existValue != nil) {
                // 已存在的值，生成数组。
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray * items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    [params setValue:items forKey:key];
                } else {
                    // 非数组
                    [params setValue:@[existValue,value]forKey:key];
                }
            } else {
                // 设置值
                [params setValue:value forKey:key];
            }
        }
    } else {
        //单个参数生成key/value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        if (pairComponents.count == 1) {
            return params;
        }
        //分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        //key不能为nil
        if (key && value ) {
            //设置值
            [params setValue:value forKey:key];
        }
    }
    return params;
}

/**
 从url中获取参数
 
 @param url url
 @param key 字段名
 @return 参数
 */
+ (NSString *)getParamsFromUrl:(NSString *)url key:(NSString *)key
{
    if (!url) {
        return nil;
    }
    if (!key) {
        return nil;
    }
    NSDictionary *params=[QBRouterUtils getParamsFromUrl:url];
    return [params objectForKey:key];
}

/**
 url添加参数
 
 @param url url
 @param params 参数
 @param isAllowSameParams 是否允许相同参数
 @return 最后的url
 */
+ (NSString *)url:(NSString *)url addParams:(NSDictionary *)params isAllowSameParams:(BOOL)isAllowSameParams
{
    if (!url || ![url isKindOfClass:[NSString class]]) {
        return @"";
    }
    if (!params || ![params isKindOfClass:[NSDictionary class]]) {
        return url;
    }
    NSString *lastUrl = url;
    NSMutableDictionary *lastParams;
    
    if (isAllowSameParams) {
        lastParams = [NSMutableDictionary dictionaryWithDictionary:params];
    } else {
        NSDictionary *urlParams = [QBRouterUtils getParamsFromUrl:url];
        lastParams = [NSMutableDictionary dictionaryWithDictionary:urlParams];
        [lastParams addEntriesFromDictionary:params];
    }
    NSArray *urlArray = [url componentsSeparatedByString:@"#"];
    NSString *realUrl = [urlArray firstObject];
    NSString *urlExtent = @"";
    if (urlArray.count > 1) {
        urlExtent = [url substringFromIndex:realUrl.length];
    }
    NSRange range = [realUrl rangeOfString:@"?"];
    if (range.location != NSNotFound) {// 没找到
        realUrl = [realUrl substringToIndex:range.location];
    }
    NSArray *keys = [lastParams allKeys];
    lastUrl = realUrl;
    for (NSString *key in keys) {
        NSString *value = [lastParams objectForKey:key];
        lastUrl = [QBRouterUtils url:lastUrl addCompnentForValue:value key:key];
    }
    if (urlExtent && urlExtent.length > 0) {
        lastUrl = [lastUrl stringByAppendingString:urlExtent];
    }
    return lastUrl;
}

/**
 url添加参数
 
 @param url url
 @param value 参数值
 @param key 参数名称
 @param isAllowSameParams 是否允许相同参数
 @return 最后的url
 */
+ (NSString *)url:(NSString *)url addCompnentForValue:(NSString *)value key:(NSString *)key isAllowSameParams:(BOOL)isAllowSameParams
{
    if (!url || ![url isKindOfClass:[NSString class]]) {
        return @"";
    }
    if (!value  || !key) {
        return url;
    }
    NSString *lastUrl = url;
    if (isAllowSameParams) {
        lastUrl = [QBRouterUtils url:lastUrl addCompnentForValue:value key:key];
    } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[QBRouterUtils getParamsFromUrl:url]];
        [params setObject:value forKey:key];
        
        NSArray *urlArray = [url componentsSeparatedByString:@"#"];
        NSString *realUrl = [urlArray firstObject];
        NSString *urlExtent = @"";
        if (urlArray.count > 1) {
            urlExtent = [url substringFromIndex:realUrl.length];
        }
        NSRange range = [realUrl rangeOfString:@"?"];
        if (range.location != NSNotFound) {// 没找到
            realUrl = [realUrl substringToIndex:range.location];
        }
        
        NSArray *keys = [params allKeys];
        lastUrl = realUrl;
        for (NSString *key in keys) {
            NSString *value = [params objectForKey:key];
            lastUrl = [QBRouterUtils url:lastUrl addCompnentForValue:value key:key];
        }
        if (urlExtent && urlExtent.length > 0) {
            lastUrl = [lastUrl stringByAppendingString:urlExtent];
        }
    }
    return lastUrl;
}

/**
 url添加参数
 
 @param url url
 @param value 参数值
 @param key 参数名称
 @return 最后的url
 */
+ (NSString *)url:(NSString *)url addCompnentForValue:(NSString *)value key:(NSString *)key
{
    if (!url || ![url isKindOfClass:[NSString class]]) {
        return @"";
    }
    NSArray *urlArray = [url componentsSeparatedByString:@"#"];
    NSString *realUrl = [urlArray firstObject];
    NSString *urlExtent = @"";
    if (urlArray.count > 1) {
        urlExtent = [url substringFromIndex:realUrl.length];
    }
    NSMutableString *string = [[NSMutableString alloc]initWithString:realUrl];
    @try {
        NSRange range = [string rangeOfString:@"?"];
        if (range.location != NSNotFound) {// 没找到
            // 如果?是最后一个直接拼接参数
            if (string.length == (range.location + range.length)) {
                string = (NSMutableString *)[string stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,value]];
            } else {//如果不是最后一个需要加&
                if ([string hasSuffix:@"&"]) {// 如果最后一个是&,直接拼接
                    string = (NSMutableString *)[string stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,value]];
                } else {//如果最后不是&,需要加&后拼接
                    string = (NSMutableString *)[string stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",key,value]];
                }
            }
        } else {// 找到了
            if ([string hasSuffix:@"&"]) {// 如果最后一个是&,去掉&后拼接
                string = (NSMutableString *)[string substringToIndex:string.length-1];
            }
            string = (NSMutableString *)[string stringByAppendingString:[NSString stringWithFormat:@"?%@=%@",key,value]];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    if (urlExtent && urlExtent.length > 0) {
        [string appendString:urlExtent];
    }
    return string.copy;
}

#pragma mark - 顶层控制器

/**
 获取当前控制器
 
 @return 当前控制器
 */
+ (UIViewController *)topViewController
{
    UIWindow *window = [QBRouterUtils currentActivityWindow];
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        if ([((UITabBarController *)result).selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navigationController = (UINavigationController *)[((UITabBarController *)result) selectedViewController];
            result = [navigationController visibleViewController];
        } else {
            result = [((UITabBarController *)result) selectedViewController];
        }
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [((UINavigationController *)result) visibleViewController];
    }
    return result;
}

/**
 获取活动窗口
 
 @return 活动窗口
 */
+ (UIWindow *)currentActivityWindow
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window == nil || window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tempWindow in windows) {
            if (tempWindow.windowLevel == UIWindowLevelNormal) {
                window = tempWindow;
                break;
            }
        }
    }
    return window;
}

@end
