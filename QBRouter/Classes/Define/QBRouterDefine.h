//
//  QBRouterDefine.h
//  QBRouterDemo
//
//  Created by 覃斌 卢    on 2019/9/22.
//  Copyright © 2019 覃斌 卢   . All rights reserved.
//

#ifndef QBRouterDefine_h
#define QBRouterDefine_h

/**
 * 跳转方式
 */
typedef NS_ENUM(NSInteger , QBRouterTranstionType) {
    QBRouterTranstionTypeNativePush               = 1,                      //采用Push方式
    QBRouterTranstionTypeNativePresent            = 2,                      //采用Present方式
    QBRouterTranstionTypeNativePresentWithNav     = 3,                      //采用Present方式带navbar
};

/**
 触发方
 */
typedef NS_ENUM(NSInteger , QBRouterCompletionTrigger) {
    QBRouterCompletionTriggerProtocol           = 0,                          //路由协议触发
    QBRouterCompletionTriggerExtentionProtocol  = 1,                          //路由扩展协议触发
    QBRouterCompletionTriggerRouter             = 2,                          //路由触发
};

/**
 返回结果码
 */
typedef NS_ENUM(NSInteger , QBRouterResultCode) {
    QBRouterResultCodeSucess                     = -21000,                          //成功
    QBRouterResultCodeInvalidURL                 = -21001,                          //无效跳转的url
    QBRouterResultCodeProtocolError              = -21002,                          //路由协议错误
    QBRouterResultCodeExtentionProtocolError     = -21003,                          //路由扩展协议错误
};

/**
 路由返回信息block
 
 @param sucess 状态
 @param result 结果
 */
typedef void (^QBRouterCompletionCallback)(BOOL sucess, id _Nullable result);

#define QBRouterTrigger @"trigger"      // 触发方 QBRouterCompletionTrigger
#define QBRouterCode @"retCode"         // code QBRouterResultCode
#define QBRouterMessage @"msg"          // 描述信息
#define QBRouterData @"data"            // 数据

#ifndef QBWeakSelf
#define QBWeakSelf typeof(self) __weak weakSelf = self;
#endif



#endif /* QBRouterDefine_h */
