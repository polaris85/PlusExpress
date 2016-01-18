//
//  AppDelegate.h
//  PLUS
//
//  Created by Ben Folds on 9/16/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTabbarViewController.h"
#import "BAgreementViewController.h"
#import "BLiveTrafficViewController.h"
#import "PlusMilesServiceProxy.h"
#import "GAI.h"
#import <GoogleMaps/GoogleMaps.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIScrollViewDelegate, Wsdl2CodeProxyDelegate> {
    PlusMilesServiceProxy *proxy;
    BLiveTrafficViewController *vc;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIStoryboard *myStoryBoard;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) BTabbarViewController *tabBarController;
@property (strong, nonatomic) BAgreementViewController *agreeVc;

@end
