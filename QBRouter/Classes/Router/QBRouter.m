//
//  QBRouter.m
//  QBRouterDemo
//
//  Created by 覃斌 卢    on 2019/9/22.
//  Copyright © 2019 覃斌 卢   . All rights reserved.
//

#import "QBRouter.h"
#import <objc/runtime.h>
#import "QBRouterUtils.h"

@interface QBRouter ()

/**  默认路由  */
@property (class, readwrite, strong) QBRouter *standardRouter;

@end

@implementation QBRouter
{
    /** 路由扩展解析类 */
    Class <QBRouterExtentionProtocol> routerExtentionClass;
    /** 路由扩展解析类-isa */
    Class metaClass;
    /**  路由协议对照表 */
    NSMutableDictionary <NSString *, Class> *routerUrlMap;
}

static QBRouter * router = nil;

#pragma mark - 路由类

+ (QBRouter *)standardRouter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[QBRouter alloc]init];
    });
    return router;
}

+ (void)setStandardRouter:(QBRouter *)standardRouter {
    if (standardRouter != router) {
        router = standardRouter;
    }
}

#pragma mark - init

- (instancetype)init {
    self = [super init];
    if (self) {
        // 加载协议对照表
        [self loadProtocolClasses];
    }
    return self;
}

/**  初始化路由SDK */
+ (void)initRouterSDK {
    [QBRouter standardRouter];
}

#pragma mark - 路由注册

/**
 注册路由扩展解析类
 @param routerExtentionClass 路由扩展协议类
 @return 是否注册成功
 */
+ (BOOL)registerRouterExtentionClass:(Class <QBRouterExtentionProtocol> )routerExtentionClass {
    return [[QBRouter standardRouter] registerRouterExtentionClass:routerExtentionClass];
}

/**
 注册路由扩展解析类
 @param routerExtentionClass 路由扩展协议类
 @return 是否注册成功
 */
- (BOOL)registerRouterExtentionClass:(Class <QBRouterExtentionProtocol> )routerExtentionClass {
    Protocol *protocol = @protocol(QBRouterExtentionProtocol);//路由协议
    if (routerExtentionClass && class_conformsToProtocol(routerExtentionClass, protocol)) {
        Class _Nullable supercls = routerExtentionClass;
        Protocol *protocol = @protocol(QBRouterExtentionProtocol);//路由协议
        while (supercls && !class_conformsToProtocol(supercls, protocol)) {
            supercls = class_getSuperclass(supercls);
        }
        self->routerExtentionClass = supercls;
        if (self->routerExtentionClass) {
            self->metaClass = (Class)object_getClass(self->routerExtentionClass);
        }
        return YES;
    }
    return NO;
}

#pragma mark - 路由方法

/**
 是否可以打开URL
 
 @param url url
 @return 是否可以打开URL
 */
+ (BOOL)canOpenURL:(NSString * _Nullable)url {
    return [[QBRouter standardRouter]canOpenURL:url];
}

/**
 是否可以打开URL
 
 @param url url
 @return 是否可以打开URL
 */
- (BOOL)canOpenURL:(NSString * _Nullable)url {
    if (url && [url isKindOfClass:[NSString class]]) {
        return [self isCanOpenWithRouterUrl:url];
    } else if ([url isKindOfClass:[QBRouterInfo class]]) {
        QBRouterInfo *routerInfo = (QBRouterInfo *)url;
        return [self isCanOpenWithRouterUrl:routerInfo.url];
    }
    return NO;
}

/**
 打开URL
 
 @param url url
 */
+ (void)openURL:(NSString * _Nullable)url {
    [[QBRouter standardRouter] openURL:url params:nil completionHandler:nil];
}

/**
 打开url
 
 @param url url
 @param completionHandler 完成回调
 */
+ (void)openURL:(NSString * _Nullable)url completionHandler:(QBRouterCompletionCallback _Nullable)completionHandler {
    [[QBRouter standardRouter] openURL:url params:nil completionHandler:completionHandler];
}

/**
 打开url
 
 @param url url
 @param params 参数
 */
+ (void)openURL:(NSString * _Nullable)url params:(NSDictionary * _Nullable)params {
    [[QBRouter standardRouter] openURL:url params:params completionHandler:nil];
}

/**
 打开url
 
 @param url url
 @param params 参数
 @param completionHandler 完成回调
 */
+ (void)openURL:(NSString * _Nullable)url params:(NSDictionary * _Nullable)params completionHandler:(QBRouterCompletionCallback)completionHandler {
    [[QBRouter standardRouter]openURL:url params:params completionHandler:completionHandler];
}

/**
 打开url
 
 @param url url
 @param params 参数
 @param completionHandler 完成回调
 */
- (void)openURL:(NSString * _Nullable)url params:(NSDictionary * _Nullable)params completionHandler:(QBRouterCompletionCallback)completionHandler {
    if (url &&  [url isKindOfClass:[NSString class]]) {
        QBRouterInfo *routerInfo = [QBRouterInfo routerInfoWithUrl:url];
        routerInfo.params = params;
        [self openURLWithRouterInfo:routerInfo completionHandler:completionHandler];
    } else if (url &&  [url isKindOfClass:[QBRouterInfo class]]) {
        QBRouterInfo *routerInfo = (QBRouterInfo *)url;
        [self openURLWithRouterInfo:routerInfo completionHandler:completionHandler];
    } else {
        if (completionHandler) {
            completionHandler(NO,[self routerResultWithCode:(QBRouterResultCodeInvalidURL) message:@"无效的URL" resultData:nil]);
        }
    }
}

/**
 根据路由信息打开url
 
 @param routerInfo 路由信息
 */
+ (void)openURLWithRouterInfo:(QBRouterInfo * _Nullable)routerInfo {
    [[QBRouter standardRouter] openURLWithRouterInfo:routerInfo completionHandler:nil];
}

/**
 根据路由信息打开url
 
 @param routerInfo 路由信息
 @param completionHandler 完成回调
 */
+ (void)openURLWithRouterInfo:(QBRouterInfo * _Nullable)routerInfo completionHandler:(QBRouterCompletionCallback)completionHandler {
    [[QBRouter standardRouter] openURLWithRouterInfo:routerInfo completionHandler:completionHandler];
}

/**
 根据路由信息打开url
 
 @param routerInfo 路由信息
 @param completionHandler 完成回调
 */
- (void)openURLWithRouterInfo:(QBRouterInfo * _Nullable)routerInfo  completionHandler:(QBRouterCompletionCallback)completionHandler {
    if (routerInfo && [routerInfo isKindOfClass:[NSString class]]) {
        NSString *url = (NSString *)routerInfo;
        routerInfo = [QBRouterInfo routerInfoWithUrl:url];
    }
    if (routerInfo && [routerInfo isKindOfClass:[QBRouterInfo class]] && routerInfo.url && [routerInfo.url isKindOfClass:[NSString class]]) {
        NSString *key = @"";
        if ([routerInfo.url hasPrefix:@"http://"]) {
            key = @"http://";
        } else if ([routerInfo.url hasPrefix:@"https://"]) {
            key = @"https://";
        } else {
            //索引处理
            NSArray *keyArray = [routerInfo.url componentsSeparatedByString:@"#"];
            key = [keyArray firstObject];
            keyArray = [routerInfo.url componentsSeparatedByString:@"?"];
            key = [keyArray firstObject];
            //参数处理
            NSDictionary *urlParams = [QBRouterUtils getParamsFromUrl:routerInfo.url];
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:urlParams];
            if (routerInfo.params.count > 0 && routerInfo.url.length > 0) {
                [params addEntriesFromDictionary:routerInfo.params];
            }
            routerInfo.params = params;
        }
        Class<QBRouterProtocol> routerClass = self->routerUrlMap[key?:@""];
        if (routerClass) {
            routerInfo.completionHandler = ^(BOOL sucess, id  _Nullable result) {
                if (completionHandler) {
                    completionHandler(sucess,result);
                }
            };
            [self routerToRecognizeRouterEventWithRouterClass:routerClass routerInfo:routerInfo];
        } else {
            routerInfo.completionHandler = ^(BOOL sucess, id  _Nullable result) {
                if (completionHandler) {
                    completionHandler(sucess,result);
                }
            };
            [self routerToUnRecognizeRouterEventWithRouterInfo:routerInfo];
        }
    } else {
        if (completionHandler) {
            completionHandler(NO,[self routerResultWithCode:(QBRouterResultCodeInvalidURL) message:@"无效的URL" resultData:nil]);
        }
    }
}

#pragma mark - 路由协议事件触发

/**
 成功识别路由跳转处理
 
 @param routerClass 路由类
 @param routerInfo 路由信息
 */
- (void)routerToRecognizeRouterEventWithRouterClass:(Class <QBRouterProtocol>)routerClass routerInfo:(QBRouterInfo * _Nullable)routerInfo {
    SEL sel_handler = @selector(preproceseRouterEventWithRouterInfo:completionHandler:);//未识别路由跳转协议
    Class routerMetaClass;
    SEL sel_isPreproceseHandler = @selector(isPreprocese);//路由预处理事件
    routerMetaClass = (Class)object_getClass(routerClass);
    if (routerMetaClass && class_respondsToSelector(routerMetaClass, sel_isPreproceseHandler)) {
        routerInfo.isPreprocese =  [routerClass isPreprocese];
    }
    if (routerInfo.isPreprocese && self->metaClass && class_respondsToSelector(self->metaClass, sel_handler)) {
        __block Class <QBRouterProtocol> blockRouterClass = routerClass;
        [self->routerExtentionClass preproceseRouterEventWithRouterInfo:routerInfo completionHandler:^(BOOL sucess, id  _Nullable result) {
            if (sucess) {
                [blockRouterClass handleRouterEventWithRouterInfo:routerInfo];
            }
        }];
    } else {
        [routerClass handleRouterEventWithRouterInfo:routerInfo];
    }
}

/**
 未识别路由跳转处理
 
 @param routerInfo 路由信息
 */
- (void)routerToUnRecognizeRouterEventWithRouterInfo:(QBRouterInfo * _Nullable)routerInfo {
    SEL sel_unRecognizeHandler = @selector(handleUnRecognizeRouterEventWithRouterInfo:);
    if (self->metaClass && class_respondsToSelector(self->metaClass, sel_unRecognizeHandler)) {
        [self handleUnRecognizeRouterEventWithRouterInfo:routerInfo];
    } else {
        if (routerInfo.completionHandler) {
            routerInfo.completionHandler(NO,[self routerResultWithCode:(QBRouterResultCodeInvalidURL) message:@"无效的URL" resultData:nil]);
        }
    }
}

/**
 未识别路由处理
 
 @param routerInfo 路由信息
 */
- (void)handleUnRecognizeRouterEventWithRouterInfo:(QBRouterInfo * _Nullable)routerInfo {
    SEL sel_preproceseHandler = @selector(preproceseRouterEventWithRouterInfo:completionHandler:);//路由预处理事件
    if (routerInfo.isPreprocese && self->metaClass && class_respondsToSelector(self->metaClass, sel_preproceseHandler)) {
        __block Class <QBRouterExtentionProtocol> blockRouterClass = self->routerExtentionClass;
        [self->routerExtentionClass preproceseRouterEventWithRouterInfo:routerInfo completionHandler:^(BOOL sucess, id  _Nullable result) {
            if (sucess) {
                [blockRouterClass handleUnRecognizeRouterEventWithRouterInfo:routerInfo];
            }
        }];
    } else {
        [self->routerExtentionClass handleUnRecognizeRouterEventWithRouterInfo:routerInfo];
    }
}

#pragma mark - 路由是否可以打开

/**
 解析路由URL返回控制器
 
 @param url url
 @return 是否可以打开
 */
- (BOOL)isCanOpenWithRouterUrl:(NSString * _Nullable)url {
    if (!url || ![url isKindOfClass:[NSString class]]) {
        return NO;
    }
    BOOL isCanOpenURL = NO;
    NSString *key = @"";
    if ([url hasPrefix:@"http://"]) {
        key = @"http://";
    } else if ([url hasPrefix:@"https://"]) {
        key = @"https://";
    } else {
        //索引处理
        NSArray *keyArray = [url componentsSeparatedByString:@"#"];
        key = [keyArray firstObject];
        keyArray = [url componentsSeparatedByString:@"?"];
        key = [keyArray firstObject];
    }
    if (self->routerUrlMap[key?:@""]) {
        isCanOpenURL = YES;
    } else {
        SEL sel_canOpenHandler = @selector(isCanOpenUnRecognizeRouterEventWithUrl:);//未识别路由事件是否可识别
        if (self->metaClass && class_respondsToSelector(self->metaClass, sel_canOpenHandler)) {
            isCanOpenURL = [self->routerExtentionClass isCanOpenUnRecognizeRouterEventWithUrl:url];
        } else {
            isCanOpenURL = NO;
        }
    }
    return isCanOpenURL;
}


#pragma mark - 协议加载

/** 动态加载协议 */
- (void)loadProtocolClasses {
    self->routerUrlMap = [[NSMutableDictionary alloc]initWithCapacity:30];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        unsigned int img_count = 0;
        const char **imgs = objc_copyImageNames(&img_count);
        const char *main = NSBundle.mainBundle.bundlePath.UTF8String;
        
        SEL sel_handler = @selector(handleRouterEventWithRouterInfo:);//路由跳转协议
        SEL sel_path = @selector(routerPath);//路由路径协议
        SEL sel_multiPath = @selector(multiRouterPath);//路由多路径协议
        Protocol *protocol = @protocol(QBRouterProtocol);//路由协议
        
        for (unsigned int i = 0 ; i < img_count ; ++ i) {
            const char *image = imgs[i];
            if (!strstr(image, main)) {
                continue;
            }
            unsigned int cls_count = 0;
            const char **names = objc_copyClassNamesForImage(image, &cls_count);
            for (unsigned int i = 0 ; i < cls_count ; ++ i) {
                const char *cls_name = names[i];
                Class _Nullable cls = objc_getClass(cls_name);
                Class _Nullable supercls = cls;
                while (supercls && !class_conformsToProtocol(supercls, protocol)) {
                    supercls = class_getSuperclass(supercls);
                }
                
                if ( !supercls) {
                    continue;//不存在协议
                }
                //存在协议
                Class metaClass = (Class)object_getClass(cls);
                if (!class_respondsToSelector(metaClass, sel_handler)) {
                    continue;//不存在路由跳转事件
                }
                if (class_respondsToSelector(metaClass, sel_path)) {
                    //单路径注册
                    IMP func = class_getMethodImplementation(metaClass, sel_path);
                    NSString *routePath = ((NSString *(*)(id, SEL))func)(cls, sel_path);
                    if (routePath.length > 0) {
                        self->routerUrlMap[routePath] = cls;
                    }
                } else if (class_respondsToSelector(metaClass, sel_multiPath)) {
                    //多路径注册
                    IMP func = class_getMethodImplementation(metaClass, sel_multiPath);
                    for ( NSString *routePath in ((NSArray<NSString *> *(*)(id, SEL))func)(cls, sel_multiPath)) {
                        if (routePath.length > 0) {
                            self->routerUrlMap[routePath] = cls;
                        }
                    }
                }
            }
            if (names) {
                free(names);
            }
        }
        if (imgs) {
            free(imgs);
        }
    });
}

#pragma mark - 打开控制器

/**
 打开控制器
 @param viewController 控制器
 @param transtionType  跳转方式
 @param animation      动画
 @param completionHandler 跳转结果
 */
+ (void)openViewController:(UIViewController *)viewController transtionType:(QBRouterTranstionType)transtionType animation:(BOOL)animation completionHandler:(QBRouterCompletionCallback _Nullable)completionHandler {
    
    return [[QBRouter standardRouter]openViewController:viewController transtionType:transtionType animation:animation completionHandler:completionHandler];
}

/**
 打开控制器
 @param viewController 控制器
 @param transtionType  跳转方式
 @param animation      动画
 @param completionHandler 跳转结果
 */
- (void)openViewController:(UIViewController *)viewController transtionType:(QBRouterTranstionType)transtionType animation:(BOOL)animation completionHandler:(QBRouterCompletionCallback _Nullable)completionHandler {
    
    if (viewController) {
        //根据跳转类型进行跳转
        UIViewController *topVC = [QBRouterUtils topViewController];
        QBWeakSelf;
        //如果顶层是UIAlertController 先移除后弹出
        if ([topVC isKindOfClass:[UIAlertController class]]) {
            [topVC dismissViewControllerAnimated:YES completion:^{
                [weakSelf jumpToViewController:viewController transtionType:transtionType animation:animation completionHandler:completionHandler];
            }];
        } else {
            [weakSelf jumpToViewController:viewController transtionType:transtionType animation:animation completionHandler:completionHandler];
        }
    } else {
        if (completionHandler) {
            completionHandler(NO,nil);
        }
    }
}

/**
 跳转控制器
 @param viewController 控制器
 @param transtionType  跳转方式
 @param animation      动画
 @param completionHandler 跳转结果
 */
- (void)jumpToViewController:(UIViewController *)viewController transtionType:(QBRouterTranstionType)transtionType animation:(BOOL)animation completionHandler:(QBRouterCompletionCallback _Nullable)completionHandler {
    // 根据跳转类型进行跳转
    UIViewController *topVC = [QBRouterUtils topViewController];
    if (transtionType == QBRouterTranstionTypeNativePush && topVC.navigationController) {
        [topVC.navigationController pushViewController:viewController animated:animation];
        if (completionHandler) {
            completionHandler(YES,nil);
        }
    } else if (transtionType ==  QBRouterTranstionTypeNativePresent || transtionType ==   QBRouterTranstionTypeNativePresentWithNav) {
        UIViewController *presentVC ;
        if (transtionType == QBRouterTranstionTypeNativePresentWithNav) {
            presentVC = [[UINavigationController alloc]initWithRootViewController:viewController];
        } else {
            presentVC = viewController;
        }
        [topVC presentViewController:presentVC animated:animation completion:^{
            if (completionHandler) {
                completionHandler(YES,nil);
            }
        }];
    }
}

#pragma mark - 打开外链URL

/**
 是否可以打开外链
 
 @param url url
 @return 是否可以打开
 */
+ (BOOL)applicationCanOpenURL:(NSString * _Nullable)url {
    return [[QBRouter standardRouter]applicationCanOpenURL:url];
}

/**
 是否可以打开外链
 
 @param url url
 @return 是否可以打开
 */
- (BOOL)applicationCanOpenURL:(NSString * _Nullable)url {
    if (url && [url isKindOfClass:[NSString class]]) {
        // 跳转外部URL
        UIApplication *app = [UIApplication sharedApplication];
        NSURL *lastURL = [NSURL URLWithString:url];
        if ([app canOpenURL:lastURL]) {
            return YES;
        }
    }
    return NO;
}

/**
 打开外链URL
 
 @param url url
 @param completionHandler 跳转结果
 */
+ (void)applicationOpenURLWithURL:(NSString * _Nullable)url completionHandler:(QBRouterCompletionCallback _Nullable)completionHandler {
    return [[QBRouter standardRouter]applicationOpenURLWithURL:url completionHandler:completionHandler];
}

/**
 打开外链URL
 
 @param url url
 @param completionHandler 跳转结果
 */
- (void)applicationOpenURLWithURL:(NSString * _Nullable)url completionHandler:(QBRouterCompletionCallback _Nullable)completionHandler {
    if (!(url && [url isKindOfClass:[NSString class]])) {
        if (completionHandler) {
            completionHandler(NO,[self applicationOpenURLResultWithSucess:NO resultData:nil]);
        }
    }
    // 跳转外部URL
    UIApplication *app = [UIApplication sharedApplication];
    NSURL *lastURL = [NSURL URLWithString:url];
    if ([app canOpenURL:lastURL]) {
        if (@available(iOS 10.0, *)) {
            [app openURL:lastURL options:@{} completionHandler:^(BOOL success) {
                if (completionHandler) {
                    completionHandler(success,[self applicationOpenURLResultWithSucess:success resultData:nil]);
                }
            }];
        } else {
            BOOL success = [app openURL:lastURL];
            if (completionHandler) {
                completionHandler(success,[self applicationOpenURLResultWithSucess:success resultData:nil]);
            }
        }
    }
}

#pragma mark - 返回信息快速生成

/**
 返回信息生成
 
 @param code     状态码
 @param message   描述信息
 @param result 数据
 @return 返回信息
 */
- (NSError *)routerResultWithCode:(QBRouterResultCode)code message:(NSString * _Nullable)message resultData:(id _Nullable )result {
    return [self resultWithTrigger:QBRouterCompletionTriggerRouter code:code message:message resultData:result];
}

/**
 app打开外部url结果返回信息生成
 
 @param success 状态
 @param result 信息
 @return 返回信息
 */
- (NSError *)applicationOpenURLResultWithSucess:(BOOL)success resultData:(id _Nullable )result {
    QBRouterResultCode code;
    NSString * message;
    if (success) {
        code = QBRouterResultCodeSucess;
        message = @"成功";
    } else {
        code = QBRouterResultCodeInvalidURL;
        message = @"无效的URL";
    }
    return [self resultWithTrigger:QBRouterCompletionTriggerRouter code:code message:message resultData:result];
}

/**
 返回信息快速生成
 
 @param trigger 触发方
 @param code     状态码
 @param message   描述信息
 @param result 数据
 @return 返回信息
 */
- (NSError *)resultWithTrigger:(QBRouterCompletionTrigger)trigger code:(QBRouterResultCode)code message:(NSString * _Nullable)message resultData:(id _Nullable )result {
    
    NSMutableDictionary *resultDic=[NSMutableDictionary dictionary];
    [resultDic setObject:@(trigger).stringValue forKey:QBRouterTrigger];
    [resultDic setObject:@(code).stringValue forKey:QBRouterCode];
    if (message) {
        [resultDic setObject:message forKey:QBRouterMessage];
    }
    if (result) {
        [resultDic setObject:result forKey:QBRouterData];
    }
    NSError *error = [NSError errorWithDomain:@"com.router.errordomain" code:@(code).integerValue userInfo:resultDic];
    return error;
}


@end
