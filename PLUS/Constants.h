//
//  Constants.h
//  PLUS
//
//  Created by Ben Folds on 9/19/14.
//  Copyright (c) 2014 Ben. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IS_IPAD   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define TOP_HEADER_HEIGHT (IS_IPAD? 132:64)
#define AD_HEIGHT (IS_IPAD? 100:50)

#define DEVICE_TYPE_IPAD 1
#define DEVICE_TYPE_IPHONE 0

@interface Constants : NSObject


@end
