#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "QBRouterDefine.h"
#import "QBRouterInfo.h"
#import "QBRouterExtentionProtocol.h"
#import "QBRouterProtocol.h"
#import "QBRouterHeader.h"
#import "QBRouter.h"
#import "QBRouterUtils.h"

FOUNDATION_EXPORT double QBRouterVersionNumber;
FOUNDATION_EXPORT const unsigned char QBRouterVersionString[];

