//
//  QBRouterHeader.h
//  QBRouterDemo
//
//  Created by 覃斌 卢    on 2019/9/22.
//  Copyright © 2019 覃斌 卢   . All rights reserved.
//

#ifndef QBRouterHeader_h
#define QBRouterHeader_h

#if __has_include(<QBRouter/QBRouter.h>)

#import <QBRouter/QBRouter.h>
#import <QBRouter/QBRouterInfo.h>
#import <QBRouter/QBRouterProtocol.h>
#import <QBRouter/QBRouterExtentionProtocol.h>
#import <QBRouter/QBRouterDefine.h>
#import <QBRouter/QBRouterUtils.h>

#else

#import "QBRouter.h"
#import "QBRouterProtocol.h"
#import "QBRouterExtentionProtocol.h"
#import "QBRouterDefine.h"
#import "QBRouterUtils.h"

#endif


#endif /* QBRouterHeader_h */
