//
//  QBRouterAnimatedTransition.h
//  Pods-QBRouter_Example
//
//  Created by 覃斌 卢    on 2020/7/31.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QBRouterAnimatedTransition : NSObject

@property (nullable, nonatomic, strong) id<UIViewControllerTransitioningDelegate> transitioningDelegate;
@property(nullable, nonatomic, strong) id<UINavigationControllerDelegate> navigationControllerDelegate;

@end

NS_ASSUME_NONNULL_END
